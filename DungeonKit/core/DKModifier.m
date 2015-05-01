//
//  DKModifier.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKModifier.h"

@interface DKModifier()
@end

@implementation DKModifier

@synthesize value = _value;
@synthesize enabled = _enabled;
@synthesize priority = _priority;
@synthesize modifierBlock = _modifierBlock;
@synthesize modifierExpression = _modifierExpression;
@synthesize explanation = _explanation;
@synthesize owner = _owner;

- (id)initWithValue:(int)value priority:(DKModifierPriority)priority block:(DKModifierBlockType)block {
    self = [super init];
    if (self) {
        _value = value;
        _enabled = YES;
        _priority = priority;
        _modifierBlock = block;
    }
    return self;
}

- (id)initWithValue:(int)value
           priority:(DKModifierPriority)priority
         expression:(NSExpression*)expression {
    
    self = [super init];
    if (self) {
        _value = value;
        _enabled = YES;
        _priority = priority;
        _modifierExpression = expression;
    }
    return self;
}

- (void)removeFromStatistic {
    [_owner removeModifier:self];
    _owner = nil;
}

- (int) modifyStatistic:(int)input {
    
    if (self.modifierExpression != nil && self.enabled) {
        NSMutableDictionary* context = [@{ @"input": @(input),
                                           @"value": @(self.value) } mutableCopy];
        return [[_modifierExpression expressionValueWithObject:self context:context] intValue];
    }
    else if (self.modifierBlock != nil && self.enabled) {
        return _modifierBlock(self.value, input);
    } else {
        return input;
    }
}

- (void)wasAppliedToStatistic:(id<DKModifierOwner>)owner {
    _owner = owner;
}

- (NSString*)description {
    
    if (![_explanation length]) {
        return [super description];
    }
    
    NSString* modifierString = @"";
    if (_priority == kDKModifierPriority_Additive) {
        
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.positivePrefix = @"+";
        formatter.zeroSymbol = @"+0";
        modifierString = [NSString stringWithFormat:@"%@: ", [formatter stringFromNumber:@([self modifyStatistic:0])]];
    }
    
    NSString* disabled = @"";
    if (!self.enabled) { disabled = @" - disabled"; }
    return [NSString stringWithFormat:@"%@%@%@", modifierString, _explanation, disabled];
}

@end


@implementation DKModifierBuilder

+ (id)modifierWithAdditiveBonus:(int)bonus {
    DKModifier* modifier = [[DKModifier alloc] initWithValue:bonus
                                                    priority:kDKModifierPriority_Additive
                                                  expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    return modifier;
}

+ (id)modifierWithAdditiveBonus:(int)bonus explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:bonus];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithMinimum:(int)min {

    NSExpression* maxExpression =  [NSExpression expressionWithFormat:@"max:({%i, $input})", min];
    DKModifier* modifier = [[DKModifier alloc] initWithValue:0
                                                    priority:kDKModifierPriority_Clamping
                                                       expression:maxExpression];
    return modifier;
}

+ (id)modifierWithMinimum:(int)min explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithMinimum:min];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithClampBetween:(int)min and:(int)max {
    
    NSExpression* clampExpression =  [NSExpression expressionWithFormat:@"min:({%i, max:({%i, $input}) })",max, min];
    DKModifier* modifier = [[DKModifier alloc] initWithValue:0
                                                    priority:kDKModifierPriority_Clamping
                                                       expression:clampExpression];
    return modifier;
}


+ (id)modifierWithClampBetween:(int)min and:(int)max explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithClampBetween:min and:max];
    modifier.explanation = explanation;
    return modifier;
}

+ (NSExpression*)simpleAdditionModifierExpression {
    return [NSExpression expressionWithFormat:@"$input+$value"];
}

+ (DKModifierBlockType)simpleAdditionModifierBlock {
    return ^int(int modifierValue, int valueToModify) {
        return modifierValue + valueToModify;
    };
}

+ (id)modifierWithExplanation:(NSString*)explanation {
    
    DKModifier* modifier = [[DKModifier alloc] initWithValue:0
                                                    priority:kDKModifierPriority_Informational
                                                       block:^int(int modifierValue, int valueToModify) {
                                                           return valueToModify;
                                                       }];
    modifier.explanation = explanation;
    return modifier;
}

@end