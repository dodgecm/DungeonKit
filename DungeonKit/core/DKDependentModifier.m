//
//  DKDependantModifier.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKDependentModifier.h"
#import "DKDiceCollection.h"

@interface DKDependentModifier()
@end

@implementation DKDependentModifier

@synthesize valueExpression = _valueExpression;
@synthesize enabledPredicate = _enabledPredicate;

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
    
    NSAssert(dependencies.count, @"Dependencies for dependent modifier must not be empty.");
    self = [super initWithValue:0
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

- (void)refresh {
    
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    for (NSString* key in self.dependencies) {
        NSObject<DKDependency>* dependency = self.dependencies[key];
        context[key] = dependency.value;
    }
    
    if (self.enabledPredicate != nil) {
        self.enabled = [_enabledPredicate evaluateWithObject:self substitutionVariables:context];
    }
    
    if (self.valueExpression != nil) {
        self.value = [_valueExpression expressionValueWithObject:self context:context];
    }
    else {
        self.value = 0;
    }
}

- (void)remove {
    [self removeFromStatistic];
}

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
        else { return [super description]; }
    }
    else { return [super description]; };
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    DKDependentModifier* modifier = [[[self class] allocWithZone:zone] initWithDependencies:[self.dependencies copy]
                                                                                      value:[self.valueExpression copy]
                                                                                    enabled:[self.enabledPredicate copy]
                                                                                   priority:self.priority
                                                                                 expression:[self.modifierExpression copy]];
    modifier.explanation = [self.explanation copy];
    return modifier;
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:self.valueExpression forKey:@"valueExpression"];
    [aCoder encodeObject:self.enabledPredicate forKey:@"enabledPredicate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _valueExpression = [aDecoder decodeObjectForKey:@"valueExpression"];
        _enabledPredicate = [aDecoder decodeObjectForKey:@"enabledPredicate"];
        
        [self refresh];
    }
    
    return self;
}

@end