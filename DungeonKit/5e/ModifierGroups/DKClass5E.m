//
//  DKClass5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKClass5E.h"
#import "DKStatisticIDs5E.h"

@implementation DKClass5EBuilder

+ (DKClass5E*)cleric {
    
    DKClass5E* class = [[DKClass5E alloc] init];
    class.explanation = @"Cleric class modifiers";
    [class addModifier:[DKModifierBuilder modifierWithAdditiveBonus:8 explanation:@"Cleric hit die"]
        forStatisticID:DKStatIDHitDiceMaxSides];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Saving Throw Proficiency: Wisdom"]
       forStatisticID:DKStatIDSavingThrowWisdomProficiency];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Saving Throw Proficiency: Charisma"]
       forStatisticID:DKStatIDSavingThrowCharismaProficiency];
    [class addModifier:[DKModifierBuilder modifierWithExplanation:@"Cleric Weapon Proficiencies: Simple weapons"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithExplanation:@"Cleric Armor Proficiencies: Light and medium armor, shields"]
          forStatisticID:DKStatIDArmorProficiencies];
    
    DKModifierGroup* skillSubgroup = [[DKModifierGroup alloc] init];
    skillSubgroup.explanation = @"Cleric Skill Proficiencies: Choose two from History, Insight, Medicine, Persuasion, and Religion";
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Skill Proficiency: History (default)"]
        forStatisticID:DKStatIDSkillHistoryProficiency];
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Skill Proficiency: Religion (default)"]
                forStatisticID:DKStatIDSkillReligionProficiency];
    [class addSubgroup:skillSubgroup];
    
    return class;
}

@end