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
@synthesize modifierExpression = _modifierExpression;
@synthesize explanation = _explanation;
@synthesize owner = _owner;

+ (id)modifierWithNumericValue:(int)value
                      priority:(DKModifierPriority)priority
                    expression:(NSExpression*)expression {
    
    DKModifier* modifier = [[[self class] alloc] initWithValue:@(value)
                                                      priority:priority
                                                    expression:expression];
    return modifier;
}

+ (id)modifierWithCollectionValue:(NSSet*)value
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
        _priority = priority;
        _modifierExpression = expression;
    }
    return self;
}

- (void)removeFromStatistic {
    [_owner removeModifier:self];
    _owner = nil;
}

- (NSNumber*) modifyStatistic:(NSNumber*)input {
    
    if (self.modifierExpression != nil && self.enabled) {
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

- (NSString*)description {
    
    if (![_explanation length]) {
        return [super description];
    }
    
    NSString* modifierString = @"";
    if (_priority == kDKModifierPriority_Additive) {
        
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.positivePrefix = @"+";
        formatter.zeroSymbol = @"+0";
        modifierString = [NSString stringWithFormat:@"%@: ", [formatter stringFromNumber:(NSNumber*)[self modifyStatistic:@(0)]]];
    }
    
    NSString* disabled = @"";
    if (!self.enabled) { disabled = @" - disabled"; }
    return [NSString stringWithFormat:@"%@%@%@", modifierString, _explanation, disabled];
}

@end