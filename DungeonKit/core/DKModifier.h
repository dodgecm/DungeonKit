//
//  DKModifier.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKDependencyOwner.h"

typedef enum {
    /** An addition/subtraction operation, ex: +2 to STR */
    kDKModifierPriority_Additive = 1,
    /** A min/max/clamp operation, ex: Raises STR to a minimum of 18 */
    kDKModifierPriority_Clamping,
    /** Priority for modifiers that do not modify a statistic's value, but modify the statistic in some other context */
    kDKModifierPriority_Informational,
} DKModifierPriority;

@class DKModifier;
@protocol DKModifierOwner <NSObject>
@required
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
@interface DKModifier : DKDependencyOwner <NSCoding, NSCopying>

/** The amount of the modification. */
@property (nonatomic, strong) id<NSObject> value;
/** Describes when this modifier should be applied relative to other modifiers applied to the same statistic. */
@property (nonatomic, readonly) DKModifierPriority priority;
/** A method that calculates the value of the modifier from the value of the source. */
@property (nonatomic, copy, readonly) NSExpression* valueExpression;
/** An expression to perform the modification. */
@property (nonatomic, copy, readonly) NSExpression* modifierExpression;
/** An optional explanation of the nature or source of this modifier */
@property (nonatomic, copy) NSString* explanation;
/** The statistic to which this modifier is currently applied, if any. */
@property (nonatomic, weak, readonly) id<DKModifierOwner> owner;

+ (id)modifierWithValue:(id<NSObject>)value
               priority:(DKModifierPriority)priority
             expression:(NSExpression*)expression;

- (id)init __unavailable;

/** @see DKModifierBuilder */
- (id)initWithValue:(id<NSObject>)value
           priority:(DKModifierPriority)priority
         expression:(NSExpression*)expression;

/** @param source The object that this modifier's value will be calculated from.  Assigned the dependency key of "source" by default.
 @param valueExpression An expression that calculates the value of the modifier from the value of the source.  If nil, the modifier will have a value of 0.
 @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
 @param expression An expression that applies the modifier's value to the owner statistic. */
- (id)initWithSource:(NSObject<DKDependency>*)source
               value:(NSExpression*)valueExpression
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression;

/** @param source The object that this modifier's value will be calculated from.  Assigned the dependency key of "source" by default.
 @param valueExpression An expression that calculates the value of the modifier from the value of the source.  If nil, the modifier will have a value of 0.
 @param enabledPredicate A predicate that evaluates based on its dependencies whether this modifier should apply its value to its owner statistic.
 @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
 @param expression An expression that applies the modifier's value to the owner statistic. */
- (id)initWithSource:(NSObject<DKDependency>*)source
               value:(NSExpression*)valueExpression
             enabled:(NSPredicate*)enabledPredicate
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression;

/** @param dependencies A dictionary of strings mapped to DKDependentModifierOwner objects.  The value of each statistic this modifier depends on can be referenced by its key string inside the value expression and the enabled expression.
 @param valueExpression An expression that calculates the value of the modifier from the value of the source.  If nil, the modifier will have a value of 0.
 @param enabledPredicate A predicate that evaluates based on its dependencies whether this modifier should apply its value to its owner statistic.
 @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
 @param expression An expression that applies the modifier's value to the owner statistic. */
- (id)initWithDependencies:(NSDictionary*)dependencies
                     value:(NSExpression*)valueExpression
                   enabled:(NSPredicate*)enabledPredicate
                  priority:(DKModifierPriority)priority
                expression:(NSExpression*)expression;

/** Removes the modifier from its owner statistic. */
- (void)removeFromStatistic;

/** Performs the modification on an input number.  Only DKStatistic and similar modifier owner
 classes should call this method directly. */
- (id<NSObject>) modifyStatistic:(id<NSObject>)input;
/** Callback method for when the modifier gets applied.  Only DKStatistic and similar modifier owner 
 classes should call this method directly.  */
- (void)wasAppliedToStatistic:(id<DKModifierOwner>)owner;

@end
