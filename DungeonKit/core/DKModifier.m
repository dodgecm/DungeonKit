//
//  DKModifier.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKModifier.h"
#import "DKDiceCollection.h"

@interface DKModifier()
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic) BOOL cachedPredicateResult;
@end

@implementation DKModifier

@synthesize value = _value;
@synthesize priority = _priority;
@synthesize valueExpression = _valueExpression;
@synthesize enabledPredicate = _enabledPredicate;
@synthesize enabled = _enabled;
@synthesize active = _active;
@synthesize modifierExpression = _modifierExpression;
@synthesize explanation = _explanation;
@synthesize owner = _owner;

@synthesize cachedPredicateResult = _cachedPredicateResult;

+ (id)modifierWithValue:(id<NSObject>)value
               priority:(DKModifierPriority)priority
             expression:(NSExpression*)expression {
    
    DKModifier* modifier = [[[self class] alloc] initWithValue:value
                                                      priority:priority
                                                    expression:expression];
    return modifier;
}

- (id)initWithValue:(id<NSObject>)value
           priority:(DKModifierPriority)priority
         expression:(NSExpression*)expression {
    
    self = [super init];
    if (self) {
        _value = value;
        _enabled = YES;
        _active = YES;
        _cachedPredicateResult = YES;
        _priority = priority;
        _modifierExpression = expression;
    }
    return self;
}

- (id)initWithSource:(NSObject<DKDependency>*)source
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

- (id)initWithSource:(NSObject<DKDependency>*)source
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
    
    self = [self initWithValue:nil
                      priority:priority
                    expression:expression];
    if (self) {
        
        for (NSString* key in dependencies) {
            [self addDependency:dependencies[key] forKey:key];
        }
        _valueExpression = valueExpression;
        _enabledPredicate = enabledPredicate;
        
        [self refresh];
        
    }
    return self;
}

- (void)setActive:(BOOL)active {
    _active = active;
    self.enabled = (_cachedPredicateResult && _active);
}

- (void)removeFromStatistic {
    [_owner removeModifier:self];
    _owner = nil;
}

- (id<NSObject>) modifyStatistic:(id<NSObject>)input {
    
    if (self.modifierExpression != nil && self.enabled && input) {
        NSMutableDictionary* context = [@{ @"input": input,
                                           @"value": self.value } mutableCopy];
        return [_modifierExpression expressionValueWithObject:self context:context];
    }
    else {
        return input;
    }
}

- (void)wasAppliedToStatistic:(id<DKModifierOwner>)owner {
    _owner = owner;
}

#pragma mark DKDependencyOwner override
- (void)refresh {
    
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    for (NSString* key in self.dependencies) {
        NSObject<DKDependency>* dependency = self.dependencies[key];
        context[key] = dependency.value;
    }
    
    if (self.enabledPredicate != nil) {
        self.cachedPredicateResult = [_enabledPredicate evaluateWithObject:self substitutionVariables:context];
    }
    self.enabled = (_cachedPredicateResult && _active);
    
    if (self.valueExpression != nil) {
        self.value = [_valueExpression expressionValueWithObject:self context:context];
    }
}

- (void)remove {
    [self removeFromStatistic];
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    DKModifier* modifier = [[[self class] allocWithZone:zone] initWithDependencies:[self.dependencies copy]
                                                                             value:[self.valueExpression copy]
                                                                           enabled:[self.enabledPredicate copy]
                                                                          priority:self.priority
                                                                        expression:[self.modifierExpression copy]];
    modifier.value = self.value;
    modifier.explanation = [self.explanation copy];
    return modifier;
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.valueExpression forKey:@"valueExpression"];
    [aCoder encodeBool:self.active forKey:@"active"];
    [aCoder encodeObject:self.enabledPredicate forKey:@"enabledPredicate"];
    [aCoder encodeInt:self.priority forKey:@"priority"];
    [aCoder encodeObject:self.modifierExpression forKey:@"modifierExpression"];
    [aCoder encodeObject:self.explanation forKey:@"explanation"];
    [aCoder encodeConditionalObject:self.owner forKey:@"owner"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _cachedPredicateResult = YES;
        _value = [aDecoder decodeObjectForKey:@"value"];
        _priority = [aDecoder decodeIntForKey:@"priority"];
        _valueExpression = [aDecoder decodeObjectForKey:@"valueExpression"];
        _active = [aDecoder decodeBoolForKey:@"active"];
        _enabledPredicate = [aDecoder decodeObjectForKey:@"enabledPredicate"];
        _modifierExpression = [aDecoder decodeObjectForKey:@"modifierExpression"];
        _explanation = [aDecoder decodeObjectForKey:@"explanation"];
        _owner = [aDecoder decodeObjectForKey:@"owner"];
        
        [self refresh];
    }
    
    return self;
}

#pragma mark NSObject override

- (NSString*)description {
    
    if (![self.explanation length]) {
        
        NSString* modifierString = @"";
        if (self.priority == kDKModifierPriority_Additive) {
            
            if ([self.value isKindOfClass:[NSNumber class]]) {
                NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
                formatter.positivePrefix = @"+";
                formatter.zeroSymbol = @"+0";
                modifierString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:(NSNumber*)self.value]];
                
            } else if ([self.value isKindOfClass:[DKDiceCollection class]]) {
                DKDiceCollection* diceValue = (DKDiceCollection*)self.value;
                modifierString = [diceValue stringValue];
            }
            
            NSString* disabled = @"";
            if (!self.enabled) { disabled = @" - disabled"; }
            return [modifierString stringByAppendingString:disabled];
        }
    }
    
    NSString* modifierString = @"";
    if (_priority == kDKModifierPriority_Additive && [self.value isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.positivePrefix = @"+";
        formatter.zeroSymbol = @"+0";
        modifierString = [NSString stringWithFormat:@"%@", [formatter stringFromNumber:(NSNumber*)[self modifyStatistic:@(0)]]];
        
    } else if ([self.value isKindOfClass:[DKDiceCollection class]]) {
        DKDiceCollection* diceValue = (DKDiceCollection*)self.value;
        modifierString = [diceValue stringValue];
    } else if ([self.value isKindOfClass:[NSString class]]) {
        modifierString = [(NSString*)self.value stringByAppendingString:@" - "];
    }
    
    NSString* explanation = @"";
    if (_explanation.length) {
        if (_priority == kDKModifierPriority_Additive) { explanation = @": "; }
        explanation = [explanation stringByAppendingString:_explanation];
    }
    
    NSString* disabled = @"";
    if (!self.enabled) { disabled = @" - disabled"; }
    return [NSString stringWithFormat:@"%@%@%@", modifierString, explanation, disabled];
}

@end