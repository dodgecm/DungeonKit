//
//  DKCleric5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/27/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCleric5E.h"
#import "DKStatisticIDs5E.h"
#import "DKAbilities5E.h"

@implementation DKCleric5EBuilder

+ (DKClass5E*)clericWithLevel:(DKStatistic*)level Abilities:(DKAbilities5E*)abilities {
    
    DKClass5E* class = [[DKClass5E alloc] init];
    class.explanation = @"Cleric class modifiers";
    [class addModifier:[DKModifierBuilder modifierWithAdditiveBonus:8 explanation:@"Cleric hit die"]
        forStatisticID:DKStatIDHitDiceMaxSides];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:abilities.wisdom explanation:@"Cleric spellcasting ability: Wisdom"]  forStatisticID:DKStatIDSpellSaveDC];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:abilities.wisdom explanation:@"Cleric spellcasting ability: Wisdom"] forStatisticID:DKStatIDSpellAttackBonus];
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
    
    DKModifierGroup* cantripsGroup = [DKCleric5EBuilder cantripsGroupWithLevel:level];
    [class addSubgroup:cantripsGroup];
    
    return class;
}

+ (DKModifierGroup*)cantripsGroupWithLevel:(DKStatistic*)level {
    
    DKModifierGroup* cantripsGroup = [[DKModifierGroup alloc] init];
    DKModifierGroup* cantripStartingGroup = [[DKModifierGroup alloc] init];
    cantripStartingGroup.explanation = @"Clerics are granted three cantrips at first level";
    [cantripsGroup addSubgroup:cantripStartingGroup];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithExplanation:@"Light (default)"] forStatisticID:DKStatIDCantrips];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithExplanation:@"Sacred Flame (default)"] forStatisticID:DKStatIDCantrips];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithExplanation:@"Thaumaturgy (default)"] forStatisticID:DKStatIDCantrips];
    
    DKModifierGroup* cantripSecondGroup = [[DKModifierGroup alloc] init];
    cantripSecondGroup.explanation = @"Clerics are granted one additional cantrip at fourth level";
    [cantripsGroup addSubgroup:cantripSecondGroup];
    [cantripSecondGroup addModifier:[DKDependentModifierBuilder informationalModifierFromSource:level threshold:4
                                                                                    explanation:@"Spare the Dying (default)"]
                     forStatisticID:DKStatIDCantrips];
    
    DKModifierGroup* cantripThirdGroup = [[DKModifierGroup alloc] init];
    cantripThirdGroup.explanation = @"Clerics are granted one additional cantrip at tenth level";
    [cantripsGroup addSubgroup:cantripThirdGroup];
    [cantripThirdGroup addModifier:[DKDependentModifierBuilder informationalModifierFromSource:level threshold:10
                                                                                   explanation:@"Guidance (default)"]
                    forStatisticID:DKStatIDCantrips];
    
    return cantripsGroup;
}

@end
