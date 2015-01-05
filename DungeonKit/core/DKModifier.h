//
//  DKModifier.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    /** An addition/subtraction operation, ex: +2 to STR */
    kDKModifierPriority_Additive = 1,
    /** A min/max/clamp operation, ex: Raises STR to a minimum of 18 */
    kDKModifierPriority_Clamping,
} DKModifierPriority;

typedef int (^DKModifierBlockType)(int modifierValue, int valueToModify);

@class DKModifier;
@protocol DKModifierOwner <NSObject>
@required
- (int)value;
- (NSArray*)modifiers;
- (void)removeModifier:(DKModifier*)modifier;
@end

/** The DKModifier class represents a modifier to some character statistic.  The modifier is comprised of:

 An identifier for the type of statistic it modifies
 A value for the amount of the modification
 A method to perform the modification
 A priority field that describes when this modifier should be applied relative to other modifiers applied to the same statistic

 For most common modifier types, you should use the convenience methods in DKModifierBuilder rather than 
 trying to initialize DKModifier directly. 
 */
@interface DKModifier : NSObject

/** The amount of the modification. */
@property (nonatomic, assign) int value;
/** Describes when this modifier should be applied relative to other modifiers applied to the same statistic. */
@property (nonatomic, readonly) DKModifierPriority priority;
/** A function to perform the modification. */
@property (nonatomic, copy, readonly) DKModifierBlockType modifierBlock;
/** The statistic to which this modifier is currently applied, if any. */
@property (nonatomic, weak, readonly) id<DKModifierOwner> owner;

- (id)init __unavailable;
/** @see DKModifierBuilder */
- (id)initWithValue:(int)value
           priority:(DKModifierPriority)priority
              block:(DKModifierBlockType)block;

/** Removes the modifier from its owner statistic. */
- (void)removeFromStatistic;

/** Performs the modification on an input number.  Only DKStatistic and similar modifier owner
 classes should call this method directly. */
- (int)modifyStatistic:(int)input;
/** Callback method for when the modifier gets applied.  Only DKStatistic and similar modifier owner 
 classes should call this method directly.  */
- (void)wasAppliedToStatistic:(id<DKModifierOwner>)owner;

@end

/** The DKModifierBuilder class provides convenience initialization methods for common DKModifier operations. */
@interface DKModifierBuilder : NSObject

/** Initializes a standard additive modifier, ex: +2 to STR. */
+ (id)modifierWithAdditiveBonus:(int)bonus;

@end
