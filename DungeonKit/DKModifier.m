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
@end

@implementation DKModifier

@synthesize value = _value;
@synthesize priority = _priority;
@synthesize valueExpression = _valueExpression;
@synthesize modifierExpression = _modifierExpression;
@synthesize expectedValueType = _expectedValueType;
@synthesize expectedInputType = _expectedInputType;
@synthesize explanation = _explanation;
@synthesize owner = _owner;

- (id)initWithValue:(id<NSObject>)value
           priority:(DKModifierPriority)priority
         expression:(NSExpression*)expression {
    
    self = [super init];
    if (self) {
        _value = value;
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
        self.enabledPredicate = enabledPredicate;
        
        [self refresh];
        
    }
    return self;
}

- (void)removeFromStatistic {
    [_owner removeModifier:self];
    _owner = nil;
}

- (id<NSObject>) modifyStatistic:(id<NSObject>)input {
    
    if (_expectedInputType) {
        NSAssert2([input isKindOfClass:_expectedInputType], @"Expected input of type %@, but instead have %@",
                  NSStringFromClass([_expectedInputType class]), NSStringFromClass([input class]));
    }
    
    if (self.modifierExpression != nil && self.enabled && input) {
        NSMutableDictionary* context = [@{ @"input": input,
                                           @"value": self.value } mutableCopy];
        id output = [_modifierExpression expressionValueWithObject:self context:context];

        return output;
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
    
    [super refresh];
    
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    for (NSString* key in self.dependencies) {
        NSObject<DKDependency>* dependency = self.dependencies[key];
        context[key] = dependency.value;
    }
    
    if (self.valueExpression != nil) {
        self.value = [_valueExpression expressionValueWithObject:self context:context];
        
        if (_expectedValueType) {
            NSAssert2([self.value isKindOfClass:_expectedValueType], @"Expected value of type %@, but instead have %@",
                      NSStringFromClass([_expectedValueType class]), NSStringFromClass([self.value class]));
        }
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
    [aCoder encodeInt:self.priority forKey:@"priority"];
    [aCoder encodeObject:NSStringFromClass(self.expectedValueType) forKey:@"expectedValueType"];
    [aCoder encodeObject:NSStringFromClass(self.expectedInputType) forKey:@"expectedInputType"];
    [aCoder encodeObject:self.modifierExpression forKey:@"modifierExpression"];
    [aCoder encodeObject:self.explanation forKey:@"explanation"];
    [aCoder encodeConditionalObject:self.owner forKey:@"owner"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _value = [aDecoder decodeObjectForKey:@"value"];
        _priority = [aDecoder decodeIntForKey:@"priority"];
        _valueExpression = [aDecoder decodeObjectForKey:@"valueExpression"];
        _modifierExpression = [aDecoder decodeObjectForKey:@"modifierExpression"];
        _expectedValueType = NSClassFromString([aDecoder decodeObjectForKey:@"expectedValueType"]);
        _expectedInputType = NSClassFromString([aDecoder decodeObjectForKey:@"expectedInputType"]);
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
            if (!self.active) { disabled = @" - inactive"; }
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
    if (!self.active) { disabled = @" - inactive"; }
    return [NSString stringWithFormat:@"%@%@%@", modifierString, explanation, disabled];
}

@end