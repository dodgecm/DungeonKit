//
//  DKCharacter5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/3/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCharacter5E.h"
#import "DKDependentModifier+5E.h"

@implementation DKCharacter5E

@synthesize level = _level;
@synthesize abilities = _abilities;
@synthesize savingThrows = _savingThrows;
@synthesize skills = _skills;
@synthesize proficiencyBonus = _proficiencyBonus;
@synthesize armorClass = _armorClass;
@synthesize initiativeBonus = _initiativeBonus;
@synthesize movementSpeed = _movementSpeed;

+ (NSDictionary*) keyPaths {
    return @{
             DKStatIDLevel: @"level",
             DKStatIDProficiencyBonus: @"proficiencyBonus",
             DKStatIDArmorClass: @"armorClass",
             DKStatIDInitiative: @"initiativeBonus",
             DKStatIDMoveSpeed: @"movementSpeed",
             
             DKStatIDStrength: @"abilities.strength",
             DKStatIDDexterity: @"abilities.dexterity",
             DKStatIDConstitution: @"abilities.constitution",
             DKStatIDIntelligence: @"abilities.intelligence",
             DKStatIDWisdom: @"abilities.wisdom",
             DKStatIDCharisma: @"abilities.charisma",
             
             DKStatIDSavingThrowStrength: @"savingThrows.strength",
             DKStatIDSavingThrowDexterity: @"savingThrows.dexterity",
             DKStatIDSavingThrowConstitution: @"savingThrows.constitution",
             DKStatIDSavingThrowIntelligence: @"savingThrows.intelligence",
             DKStatIDSavingThrowWisdom: @"savingThrows.wisdom",
             DKStatIDSavingThrowCharisma: @"savingThrows.charisma",
             
             DKStatIDSkillAcrobatics: @"skills.acrobatics",
             DKStatIDSkillAnimalHandling: @"skills.animalHandling",
             DKStatIDSkillArcana: @"skills.arcana",
             DKStatIDSkillAthletics: @"skills.athletics",
             DKStatIDSkillDeception: @"skills.deception",
             DKStatIDSkillHistory: @"skills.history",
             DKStatIDSkillInsight: @"skills.insight",
             DKStatIDSkillIntimidation: @"skills.intimidation",
             DKStatIDSkillInvestigation: @"skills.investigation",
             DKStatIDSkillMedicine: @"skills.medicine",
             DKStatIDSkillNature: @"skills.nature",
             DKStatIDSkillPerception: @"skills.perception",
             DKStatIDSkillPerformance: @"skills.performance",
             DKStatIDSkillPersuasion: @"skills.persuasion",
             DKStatIDSkillReligion: @"skills.religion",
             DKStatIDSkillSleightOfHand: @"skills.sleightOfHand",
             DKStatIDSkillStealth: @"skills.stealth",
             DKStatIDSkillSurvival: @"skills.survival",
             };
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSDictionary* keyPaths = [DKCharacter5E keyPaths];
        for (NSString* statID in [keyPaths allKeys]) {
            [self addKeyPath:keyPaths[statID] forStatisticID:statID];
        }
        
        //Initialize level, set up proficiency bonus to increase based on the level automatically
        self.level = [DKStatistic statisticWithBase:1];
        self.proficiencyBonus = [DKStatistic statisticWithBase:2];
        DKDependentModifier* levelModifier = [DKDependentModifierBuilder proficiencyBonusModifierFromLevel:_level];
        [_proficiencyBonus applyModifier:levelModifier];
        
        //Initialize ability score block and saving throws
        self.abilities = [[DKAbilities5E alloc] initWithStr:12 dex:12 con:12 intel:12 wis:12 cha:12];
        self.savingThrows = [[DKSavingThrows5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
        self.skills = [[DKSkills5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
        
        //Initialize armor class so that it gets a bonus from dexterity
        self.armorClass = [DKStatistic statisticWithBase:10];
        [_armorClass applyModifier:[_abilities.dexterity modifierFromAbilityScore]];
        
        //Initialize initiative so that it gets a bonus from dexterity
        self.initiativeBonus = [DKStatistic statisticWithBase:0];
        [_initiativeBonus applyModifier:[_abilities.dexterity modifierFromAbilityScore]];
        
        self.movementSpeed = [DKStatistic statisticWithBase:0];
    }
    return self;
}

@end
