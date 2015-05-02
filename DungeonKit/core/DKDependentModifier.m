//
//  DKDependantModifier.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKDependentModifier.h"
#import "DKConstants.h"

@interface DKDependentModifier()
@end

@implementation DKDependentModifier {
    NSMutableDictionary* _dependencies;
}

@synthesize dependencies = _dependencies;
@synthesize valueExpression = _valueExpression;
@synthesize enabledPredicate = _enabledPredicate;
@synthesize valueBlock = _valueBlock;
@synthesize enabledBlock = _enabledBlock;

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DKStatObjectChangedNotification object:nil];
    for (NSObject<DKDependentModifierOwner>* dependency in _dependencies.allValues) {
        [dependency removeObserver:self forKeyPath:@"value"];
    }
}

- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(DKDependentModifierBlockType)valueBlock
            priority:(DKModifierPriority)priority
               block:(DKModifierBlockType)block {
    
    return [self initWithSource:source
                          value:valueBlock
                        enabled:^BOOL(int sourceValue) { return YES; }
                       priority:priority
                          block:block];
}

- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(DKDependentModifierBlockType)valueBlock
             enabled:(DKDependentModifierEnabledBlockType)enabledBlock
            priority:(DKModifierPriority)priority
               block:(DKModifierBlockType)block {
    
    NSAssert(source, @"Source for dependent modifier must not be nil.");
    
    //Set the value block to grab the owner's value directly if an explicit function wasn't provided
    if (!valueBlock) {
        valueBlock = ^int(int valueToModify) {
            return valueToModify;
        };
    }
    int startingValue = valueBlock([source value]);
    
    self = [super initWithValue:startingValue
                       priority:priority
                          block:block];
    if (self) {
        
        //_source = source;
        _valueBlock = valueBlock;
        _enabledBlock = enabledBlock;
        
        [self refreshValue];
        
        /*[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dependencyChanged:) name:DKStatObjectChangedNotification object:_source];
        [_source addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];*/
        
    }
    return self;
}

- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(NSExpression*)valueExpression
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression {
    
    NSPredicate* enabledPredicate = [NSPredicate predicateWithValue:YES];
    return [self initWithSource:source
                          value:valueExpression
                        enabled:enabledPredicate
                       priority:priority
                          expression:expression];
}

- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(NSExpression*)valueExpression
             enabled:(NSPredicate*)enabledPredicate
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression {
    
    return [self initWithDependencies:@{ @"source":source }
                                value:valueExpression
                              enabled:enabledPredicate
                             priority:priority
                           expression:expression];
}

- (id)initWithDependencies:(NSDictionary*)dependencies
                     value:(NSExpression*)valueExpression
                   enabled:(NSPredicate*)enabledPredicate
                  priority:(DKModifierPriority)priority
                expression:(NSExpression*)expression {
    
    NSAssert(dependencies.count, @"Dependencies for dependent modifier must not be empty.");
    self = [super initWithValue:0
                       priority:priority
                     expression:expression];
    if (self) {
        
        _dependencies = [NSMutableDictionary dictionary];
        for (NSString* key in dependencies) {
            [self addDependency:dependencies[key] forKey:key];
        }
        _valueExpression = valueExpression;
        _enabledPredicate = enabledPredicate;
        
        [self refreshValue];
        
    }
    return self;
}

- (void)addDependency:(NSObject<DKDependentModifierOwner>*)dependency forKey:(NSString*)key {
    
    static NSArray* reservedKeys;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //These keys are reserved by the NSExpression string parser; see the very bottom of
        //https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
        reservedKeys = @[@"AND", @"OR", @"IN", @"NOT", @"ALL", @"ANY", @"SOME", @"NONE", @"LIKE", @"CASEINSENSITIVE", @"CI", @"MATCHES", @"CONTAINS", @"BEGINSWITH", @"ENDSWITH", @"BETWEEN", @"NULL", @"NIL", @"SELF", @"TRUE", @"YES", @"FALSE", @"NO", @"FIRST", @"LAST", @"SIZE", @"ANYKEY", @"SUBQUERY", @"CAST", @"TRUEPREDICATE", @"FALSEPREDICATE", @"UTI-CONFORMS-TO", @"UTI-EQUALS"];
    });
    
    NSAssert([key length], @"Key for dependency must not be empty or nil.");
    NSAssert(dependency, @"Source for dependent modifier must not be nil.");
    NSAssert(![_dependencies allKeysForObject:dependency].count, @"Source must not already be a dependency of this modifier.");
    NSAssert1(![reservedKeys containsObject:[key uppercaseString]], @"Key \"%@\" is one of the NSExpression reserved words.  Name it something else instead.", key);
    
    [self removeDependencyforKey:key];
    
    _dependencies[key] = dependency;
    [dependency willBecomeSourceForModifier:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dependencyChanged:) name:DKStatObjectChangedNotification object:dependency];
    [dependency addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    
    [self refreshValue];
}

- (void)removeDependencyforKey:(NSString*)key {
    
    NSAssert([key length], @"Key for dependency must not be empty or nil.");
    NSObject<DKDependentModifierOwner>* dependency = _dependencies[key];
    
    if (dependency) {
        
        [_dependencies removeObjectForKey:key];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DKStatObjectChangedNotification object:dependency];
        [dependency removeObserver:self forKeyPath:@"value"];
    }
}

- (void)dependencyChanged:(NSNotification*)notif {
    
    NSObject<DKDependentModifierOwner>* oldSource = notif.userInfo[@"old"];
    NSObject<DKDependentModifierOwner>* newSource = notif.userInfo[@"new"];
    
    if ([oldSource isEqual:[NSNull null]] || !oldSource) { }
    else {
        
        NSArray* keys = [_dependencies allKeysForObject:oldSource];
        //Hopefully there should only be one key returned here...
        for (NSString* key in keys) {
            
            if ([newSource isEqual:[NSNull null]] || !newSource) {
                [self removeDependencyforKey:key];
            } else {
                [self addDependency:newSource forKey:key];
            }
        }
    }
    
    if (!_dependencies.count) {
        [self removeFromStatistic];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //The value of our source statistic changed, so we need to recalculate our value
    [self refreshValue];
}

- (void)refreshValue {
    
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    for (NSString* key in _dependencies) {
        NSObject<DKDependentModifierOwner>* dependency = _dependencies[key];
        context[key] = @(dependency.value);
    }
    
    if (self.enabledPredicate != nil) {
        self.enabled = [_enabledPredicate evaluateWithObject:self substitutionVariables:context];
    } else if (_enabledBlock) {
        //self.enabled = _enabledBlock([_source value]);
    } 
    
    if (self.valueExpression != nil) {
        self.value = [[_valueExpression expressionValueWithObject:self context:context] intValue];
    }
    else if (_valueBlock) {
        //self.value = _valueBlock([_source value]);
    } else {
        self.value = 0;
    }
}

- (NSString*)description {
    
    if (![self.explanation length]) {
        
        NSString* modifierString = @"";
        if (self.priority == kDKModifierPriority_Additive) {
            
            NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
            formatter.positivePrefix = @"+";
            formatter.zeroSymbol = @"+0";
            modifierString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:@(self.value)]];
            
            NSString* disabled = @"";
            if (!self.enabled) { disabled = @" - disabled"; }
            return [modifierString stringByAppendingString:disabled];
        }
        else { return [super description]; }
    }
    else { return [super description]; };
}

@end

@implementation DKDependentModifierBuilder

+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source {
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:[DKDependentModifierBuilder simpleValueExpression]
                                                                       priority:kDKModifierPriority_Additive
                                                                          expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    return modifier;
}

+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source explanation:(NSString*)explanation {
    DKDependentModifier* modifier = [DKDependentModifierBuilder simpleModifierFromSource:source];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)informationalModifierFromSource:(NSObject<DKDependentModifierOwner>*)source threshold:(int)threshold explanation:(NSString*)explanation {
    
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:nil
                                                                        enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                 isGreaterThanOrEqualTo:threshold]
                                                                       priority:kDKModifierPriority_Informational
                                                                     expression:nil];
    modifier.explanation = explanation;
    return modifier;
}

+ (DKDependentModifierBlockType)simpleValueBlock {
    return ^int(int valueToModify) {
        return valueToModify;
    };
}

+ (NSExpression*)simpleValueExpression {
    return [NSExpression expressionForVariable:@"source"];
}

/** An expression that simply uses the dependency's value as the modifier value. */
+ (NSExpression*)valueFromDependency:(NSString*)dependencyName {
    return [NSExpression expressionForVariable:dependencyName];
}

+ (NSExpression*)expressionForConstantValue:(int)value {
    return [NSExpression expressionForConstantValue:@(value)];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isGreaterThanOrEqualTo:(int)threshold {

    // $dependencyName >= threshold
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                              rightExpression:[NSExpression expressionForConstantValue:@(threshold)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSGreaterThanOrEqualToPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToOrBetween:(int)lowThreshold and:(int)highThreshold {
    
    // ($dependencyName >= lowThreshold) && ($dependencyName <= highThreshold)
    NSPredicate* firstPredicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                                                     rightExpression:[NSExpression expressionForConstantValue:@(lowThreshold)]
                                                                            modifier:NSDirectPredicateModifier
                                                                                type:NSGreaterThanOrEqualToPredicateOperatorType
                                                                             options:0];
    
    NSPredicate* secondPredicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                                                      rightExpression:[NSExpression expressionForConstantValue:@(highThreshold)]
                                                                             modifier:NSDirectPredicateModifier
                                                                                 type:NSLessThanOrEqualToPredicateOperatorType
                                                                              options:0];
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate, secondPredicate]];
}

@end
