//
//  DKAbilities.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"

@interface DKAbilityScore : DKStatistic

/** The modifier based on the raw score.  modifier = ((score - 10) / 2) */
@property (nonatomic, readonly) int abilityModifier;

/** Returns the modifier with the proper prefix, ex: +4, +2, +0, -1 */
- (NSString*) formattedAbilityModifier;

@end

typedef enum {
    kDKAbility_Strength = 1,
    kDKAbility_Dexterity,
    kDKAbility_Constitution,
    kDKAbility_Intelligence,
    kDKAbility_Wisdom,
    kDKAbility_Charisma,
} DKAbility;

@interface DKAbilities : NSObject

/** Returns an array of all DKAbility enumeration values as NSNumbers. */
+ (NSArray*) allAbilities;
/** Returns a string abbreviation (ex: STR, DEX) for the provided DKAbility enumeration value. */
+ (NSString*) descriptionForAbility: (DKAbility) ability;

/** Convenience constructor that accepts exactly 6 NSNumbers for ability scores in the order: STR, DEX, CON, INT, WIS, CON */
- (id)initWithScores:(NSNumber*)firstScore, ... NS_REQUIRES_NIL_TERMINATION;
/** Constructor that accepts an array of 6 NSNumbers for ability scores
 @param scoreArray An array of exactly 6 NSNumbers in the order: STR, DEX, CON, INT, WIS, CON */
- (id)initWithScoreArray:(NSArray*)scoreArray;
/** Constructor that accepts an 6 values for ability scores */
- (id)initWithStr:(int)str dex:(int)dex con:(int)con intel:(int)intel wis:(int)wis cha:(int)cha;

/** Returns the DKAbilityScore object for the provied ability type */
- (DKAbilityScore*)scoreObjectForAbility:(DKAbility)ability;
/** Convenience method that returns the score for the provided ability type */
- (int)scoreForAbility:(DKAbility)ability;
/** Convenience method that returns the modifier for the provided ability type */
- (int)modifierForAbility:(DKAbility)ability;

/** Convenience method that updates the ability score for the provided ability type */
- (void)setScore:(int)score ability:(DKAbility)ability;

@end
