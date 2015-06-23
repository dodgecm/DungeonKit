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
        _priority = priority;
        _modifierExpression = expression;
    }
    return self;
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

- (NSString*)description {
    
    if (![_explanation length]) {
        return [super description];
    }
    
    NSString* modifierString = @"";
    if (_priority == kDKModifierPriority_Additive && [self.value isKindOfClass:[NSNumber class]]) {
        
        NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
        formatter.positivePrefix = @"+";
        formatter.zeroSymbol = @"+0";
        modifierString = [NSString stringWithFormat:@"%@: ", [formatter stringFromNumber:(NSNumber*)[self modifyStatistic:@(0)]]];
    } else if ([self.value isKindOfClass:[NSString class]]) {
        modifierString = [(NSString*)self.value stringByAppendingString:@" - "];
    }
    
    NSString* disabled = @"";
    if (!self.enabled) { disabled = @" - disabled"; }
    return [NSString stringWithFormat:@"%@%@%@", modifierString, _explanation, disabled];
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    DKModifier* modifier = [[[self class] allocWithZone:zone] initWithValue:self.value
                                                                   priority:self.priority
                                                                 expression:[self.modifierExpression copy]];
    modifier.explanation = [self.explanation copy];
    modifier.enabled = self.enabled;
    return modifier;
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeBool:self.enabled forKey:@"enabled"];
    [aCoder encodeInt:self.priority forKey:@"priority"];
    [aCoder encodeObject:self.modifierExpression forKey:@"modifierExpression"];
    [aCoder encodeObject:self.explanation forKey:@"explanation"];
    [aCoder encodeConditionalObject:self.owner forKey:@"owner"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _value = [aDecoder decodeObjectForKey:@"value"];
        _enabled = [aDecoder decodeBoolForKey:@"enabled"];
        _priority = [aDecoder decodeIntForKey:@"priority"];
        _modifierExpression = [aDecoder decodeObjectForKey:@"modifierExpression"];
        _explanation = [aDecoder decodeObjectForKey:@"explanation"];
        _owner = [aDecoder decodeObjectForKey:@"owner"];
    }
    
    return self;
}

@end