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
@synthesize proficiencyBonus = _proficiencyBonus;
@synthesize abilities = _abilities;
@synthesize savingThrows = _savingThrows;
@synthesize skills = _skills;
@synthesize hitPointsMax = _hitPointsMax;
@synthesize hitPointsTemporary = _hitPointsTemporary;
@synthesize hitPointsCurrent = _hitPointsCurrent;
@synthesize armorClass = _armorClass;
@synthesize initiativeBonus = _initiativeBonus;
@synthesize movementSpeed = _movementSpeed;
@synthesize deathSaveSuccesses = _deathSaveSuccesses;
@synthesize deathSaveFailures = _deathSaveFailures;

+ (NSDictionary*) keyPaths {
    return @{
             DKStatIDLevel: @"level",
             DKStatIDProficiencyBonus: @"proficiencyBonus",
             DKStatIDHitPointsMax: @"hitPointsMax",
             DKStatIDHitPointsTemporary: @"hitPointsTemporary",
             DKStatIDHitPointsCurrent: @"hitPointsCurrent",
             DKStatIDArmorClass: @"armorClass",
             DKStatIDInitiative: @"initiativeBonus",
             DKStatIDMoveSpeed: @"movementSpeed",
             DKStatIDDeathSaveSuccesses: @"deathSaveSuccesses",
             DKStatIDDeathSaveFailures: @"deathSaveFailures",
             
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
             
             DKStatIDSkillPassivePerception: @"skills.passivePerception",
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
        self.abilities = [[DKAbilities5E alloc] initWithStr:10 dex:10 con:10 intel:10 wis:10 cha:10];
        self.savingThrows = [[DKSavingThrows5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
        self.skills = [[DKSkills5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
        
        //Link maximum and current HP so that current HP value will update when max HP value changes
        self.hitPointsMax = [DKStatistic statisticWithBase:0];
        self.hitPointsTemporary = [DKStatistic statisticWithBase:0];
        self.hitPointsCurrent = [DKStatistic statisticWithBase:0];
        [_hitPointsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_hitPointsMax]];
        [_hitPointsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_hitPointsTemporary]];
        
        //Initialize armor class so that it gets a bonus from dexterity
        self.armorClass = [DKStatistic statisticWithBase:10];
        [_armorClass applyModifier:[_abilities.dexterity modifierFromAbilityScore]];
        
        //Initialize initiative so that it gets a bonus from dexterity
        self.initiativeBonus = [DKStatistic statisticWithBase:0];
        [_initiativeBonus applyModifier:[_abilities.dexterity modifierFromAbilityScore]];
        
        self.movementSpeed = [DKStatistic statisticWithBase:0];
        
        //Cap the value of death saves between 0 and 3
        self.deathSaveSuccesses = [DKStatistic statisticWithBase:0];
        self.deathSaveFailures = [DKStatistic statisticWithBase:0];
        [_deathSaveSuccesses applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:3]];
        [_deathSaveFailures applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:3]];
    }
    return self;
}

@end
