//
//  DKModifier.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kDKModifierPriority_Additive = 1,
    kDKModifierPriority_Clamping,
} DKModifierPriority;

typedef int (^DKModifierBlockType)(int modifierValue, int valueToModify);

@class DKModifier;
@protocol DKModifierOwner <NSObject>
@required
- (void)removeModifier:(DKModifier*)modifier;
@end

@interface DKModifier : NSObject

@property (nonatomic, readonly) int value;
@property (nonatomic, readonly) DKModifierPriority priority;
@property (nonatomic, copy, readonly) DKModifierBlockType modifierBlock;
@property (nonatomic, weak, readonly) id<DKModifierOwner> owner;

- (id)initWithValue:(int)value priority:(DKModifierPriority)priority block:(DKModifierBlockType)block;

- (void)removeFromStatistic;
- (int)modifyStatistic:(int)input;

- (void)wasAppliedToStatistic:(id<DKModifierOwner>)owner;

@end

@interface DKModifierBuilder : NSObject

+ (id)modifierWithAdditiveBonus:(int)bonus;

@end
