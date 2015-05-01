//
//  DKDependantModifier.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"

typedef int (^DKDependentModifierBlockType)(int sourceValue);
typedef BOOL (^DKDependentModifierEnabledBlockType)(int sourceValue);

@class DKDependentModifier;
@protocol DKDependentModifierOwner <DKModifierOwner>
@required
- (void)willBecomeSourceForModifier:(DKDependentModifier*)modifier;
@end

/** The DKModifier class represents a modifier whose value is dependent on another statistic.  For example, the 
 initiative statistic is modified by the character's dexterity score, most skills are modified by the proficiency bonus, etc.
 
 For most use cases, it's best to generate DKDependantModifier objects from the owner DKStatistic class directly.
 */
@interface DKDependentModifier : DKModifier

- (id)initWithValue:(int)value
           priority:(DKModifierPriority)priority
              block:(DKModifierBlockType)block __unavailable;

/** @param source The object that this modifier's value will be calculated from. 
    @param value A method that calculates the value of the modifier from the value of the source.  If nil, it will use the source's value directly.
    @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
    @param block A function to perform the modification. */
- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(DKDependentModifierBlockType)valueBlock
            priority:(DKModifierPriority)priority
               block:(DKModifierBlockType)block;

/** @param source The object that this modifier's value will be calculated from.
 @param value A method that calculates the value of the modifier from the value of the source.  If nil, it will use the source's value directly.
 @param value A method that returns whether to enable the modifier based on the value of the source.  If nil, the modifier will always be enabled.
 @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
 @param block A function to perform the modification. */
- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(DKDependentModifierBlockType)valueBlock
             enabled:(DKDependentModifierEnabledBlockType)enabledBlock
            priority:(DKModifierPriority)priority
               block:(DKModifierBlockType)block;

- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(NSExpression*)valueExpression
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression;

- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(NSExpression*)valueExpression
             enabled:(NSPredicate*)enabledPredicate
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression;

/** The object that this modifier's value will be calculated from. */
@property (nonatomic, strong, readonly) NSObject<DKDependentModifierOwner>* source;
/** A method that calculates the value of the modifier from the value of the source. */
@property (nonatomic, copy, readonly) NSExpression* valueExpression;
/** A method that enables or disables the modifier from the value of the source. */
@property (nonatomic, copy, readonly) NSPredicate* enabledPredicate;
/** A method that calculates the value of the modifier from the value of the source. */
@property (nonatomic, copy, readonly) DKDependentModifierBlockType valueBlock;
/** A method that enables or disables the modifier from the value of the source. */
@property (nonatomic, copy, readonly) DKDependentModifierEnabledBlockType enabledBlock;

@end

/** The DKDependentModifierBuilder class provides convenience initialization methods for generating common modifiers from statistics. */
@interface DKDependentModifierBuilder : NSObject

/** Initializes a modifier from the source object that simply adds the source's value to the modifier's owner. */
+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source;
+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source explanation:(NSString*)explanation;

+ (id)informationalModifierFromSource:(NSObject<DKDependentModifierOwner>*)source threshold:(int)threshold explanation:(NSString*)explanation;

/** A block that simply uses source's value as the modifier value. */
+ (DKDependentModifierBlockType)simpleValueBlock;
/** An expression that simply uses source's value as the modifier value. */
+ (NSExpression*)simpleValueExpression;

+ (DKDependentModifierEnabledBlockType)enableWhenGreaterThanOrEqualTo:(int)threshold;

@end