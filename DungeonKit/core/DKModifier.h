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
    /** Priority for modifiers that do not modify a statistic's value, but modify the statistic in some other context */
    kDKModifierPriority_Informational,
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
/** A flag for whether this modifier should be applied to its owner */
@property (nonatomic, assign) BOOL enabled;
/** Describes when this modifier should be applied relative to other modifiers applied to the same statistic. */
@property (nonatomic, readonly) DKModifierPriority priority;
/** A function to perform the modification. */
@property (nonatomic, copy, readonly) DKModifierBlockType modifierBlock;
/** An expression to perform the modification. */
@property (nonatomic, copy, readonly) NSExpression* modifierExpression;
/** An optional explanation of the nature or source of this modifier */
@property (nonatomic, copy) NSString* explanation;
/** The statistic to which this modifier is currently applied, if any. */
@property (nonatomic, weak, readonly) id<DKModifierOwner> owner;

- (id)init __unavailable;
/** @see DKModifierBuilder */
- (id)initWithValue:(int)value
           priority:(DKModifierPriority)priority
              block:(DKModifierBlockType)block;

- (id)initWithValue:(int)value
           priority:(DKModifierPriority)priority
         expression:(NSExpression*)expression;

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

/** Initializes a standard additive modifier, ex: +2 to a statistic. */
+ (id)modifierWithAdditiveBonus:(int)bonus;
/** Initializes a standard additive modifier, ex: +2 to a statistic. */
+ (id)modifierWithAdditiveBonus:(int)bonus explanation:(NSString*)explanation;

/** Initializes a modifier that keeps the statistic value above the given minimum */
+ (id)modifierWithMinimum:(int)min;
/** Initializes a modifier that keeps the statistic value above the given minimum */
+ (id)modifierWithMinimum:(int)min explanation:(NSString*)explanation;

/** Initializes a modifier that keeps the statistic value within the given range */
+ (id)modifierWithClampBetween:(int)min and:(int)max;
/** Initializes a modifier that keeps the statistic value within the given range */
+ (id)modifierWithClampBetween:(int)min and:(int)max explanation:(NSString*)explanation;

+ (id)modifierWithExplanation:(NSString*)explanation;

+ (NSExpression*)simpleAdditionModifierExpression;
+ (DKModifierBlockType)simpleAdditionModifierBlock;

@end
