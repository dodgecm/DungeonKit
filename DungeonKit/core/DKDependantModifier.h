//
//  DKDependantModifier.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"

typedef int (^DKDependantModifierBlockType)(int valueToModify);

/** The DKModifier class represents a modifier whose value is dependant on another statistic.  For example, the 
 initiative statistic is modified by the character's dexterity score, most skills are modified by the proficiency bonus, etc.
 
 For most use cases, it's best to generate DKDependantModifier objects from the owner DKStatistic class directly.
 */
@interface DKDependantModifier : DKModifier

- (id)initWithValue:(int)value
           priority:(DKModifierPriority)priority
              block:(DKModifierBlockType)block __unavailable;

/** @param source The object that this modifier's value will be calculated from. 
    @param value A method that calculates the value of the modifier from the value of the source.  If nil, it will use the source's value directly.
    @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
    @param block A function to perform the modification. */
- (id)initWithSource:(NSObject<DKModifierOwner>*)source
               value:(DKDependantModifierBlockType)valueBlock
            priority:(DKModifierPriority)priority
               block:(DKModifierBlockType)block;

/** The statistic to which this modifier is currently applied, if any. */
@property (nonatomic, weak, readonly) NSObject<DKModifierOwner>* source;
/** A method that calculates the value of the modifier from the value of the source. */
@property (nonatomic, copy, readonly) DKDependantModifierBlockType valueBlock;

@end
