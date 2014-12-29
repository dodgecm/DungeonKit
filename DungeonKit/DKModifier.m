//
//  DKModifier.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKModifier.h"

@interface DKModifier()
@property (nonatomic, copy, readwrite) DKModifierBlockType modifierBlock;
@end

@implementation DKModifier

@synthesize value = _value;
@synthesize priority = _priority;
@synthesize modifierBlock = _modifierBlock;
@synthesize owner = _owner;

- (id)initWithValue:(int)value priority:(DKModifierPriority)priority block:(DKModifierBlockType)block {
    self = [super init];
    if (self) {
        _value = value;
        _priority = priority;
        self.modifierBlock = block;
    }
    return self;
}

- (void)removeFromStatistic {
    [self.owner removeModifier:self];
    _owner = nil;
}

- (int) modifyStatistic:(int)input {
    
    if (self.modifierBlock != nil) {
        return self.modifierBlock(self.value, input);
    } else {
        return input;
    }
}

- (void)wasAppliedToStatistic:(id<DKModifierOwner>)owner {
    _owner = owner;
}

@end


@implementation DKModifierBuilder

+ (id)modifierWithAdditiveBonus:(int)bonus {
    DKModifier* modifier = [[DKModifier alloc] initWithValue:bonus
                                                    priority:kDKModifierPriority_Additive
                                                       block:^int(int modifierValue, int valueToModify) {
                                return modifierValue + valueToModify;
                            }];
    return modifier;
}

@end