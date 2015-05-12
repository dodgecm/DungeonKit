//
//  DKCharacter5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/3/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCharacter5E.h"
#import "DKModifierBuilder.h"

@implementation DKCharacter5E

@synthesize level = _level;
@synthesize race = _race;
@synthesize subrace = _subrace;
@synthesize classes = _classes;
@synthesize inspiration = _inspiration;
@synthesize proficiencyBonus = _proficiencyBonus;
@synthesize abilities = _abilities;
@synthesize savingThrows = _savingThrows;
@synthesize skills = _skills;
@synthesize spells = _spells;
@synthesize currency = _currency;
@synthesize hitPointsMax = _hitPointsMax;
@synthesize hitPointsTemporary = _hitPointsTemporary;
@synthesize hitPointsCurrent = _hitPointsCurrent;
@synthesize hitDiceMax = _hitDiceMax;
@synthesize hitDiceCurrent = _hitDiceCurrent;
@synthesize armorClass = _armorClass;
@synthesize initiativeBonus = _initiativeBonus;
@synthesize movementSpeed = _movementSpeed;
@synthesize darkvisionRange = _darkvisionRange;
@synthesize deathSaveSuccesses = _deathSaveSuccesses;
@synthesize deathSaveFailures = _deathSaveFailures;
@synthesize weaponProficiencies = _weaponProficiencies;
@synthesize armorProficiencies = _armorProficiencies;
@synthesize toolProficiencies = _toolProficiencies;
@synthesize languages = _languages;
@synthesize resistances = _resistances;
@synthesize immunities = _immunities;
@synthesize otherTraits = _otherTraits;

+ (NSDictionary*) statisticKeyPaths {
    return @{
             DKStatIDLevel: @"level",
             DKStatIDInspiration: @"inspiration",
             DKStatIDProficiencyBonus: @"proficiencyBonus",
             
             DKStatIDHitPointsMax: @"hitPointsMax",
             DKStatIDHitPointsTemporary: @"hitPointsTemporary",
             DKStatIDHitPointsCurrent: @"hitPointsCurrent",
             
             DKStatIDHitDiceMax: @"hitDiceMax",
             DKStatIDHitDiceCurrent: @"hitDiceCurrent",
             
             DKStatIDArmorClass: @"armorClass",
             DKStatIDInitiative: @"initiativeBonus",
             DKStatIDMoveSpeed: @"movementSpeed",
             DKStatIDDarkvision: @"darkvisionRange",
             
             DKStatIDDeathSaveSuccesses: @"deathSaveSuccesses",
             DKStatIDDeathSaveFailures: @"deathSaveFailures",
             
             DKStatIDWeaponProficiencies: @"weaponProficiencies",
             DKStatIDArmorProficiencies: @"armorProficiencies",
             DKStatIDToolProficiencies: @"toolProficiencies",
             
             DKStatIDLanguages: @"languages",
             
             DKStatIDResistances: @"resistances",
             DKStatIDImmunities: @"immunities",
             
             DKStatIDOtherTraits: @"otherTraits",
             
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
             DKStatIDSavingThrowOther: @"savingThrows.other",
             
             DKStatIDSavingThrowStrengthProficiency: @"savingThrows.strength.proficiencyLevel",
             DKStatIDSavingThrowDexterityProficiency: @"savingThrows.dexterity.proficiencyLevel",
             DKStatIDSavingThrowConstitutionProficiency: @"savingThrows.constitution.proficiencyLevel",
             DKStatIDSavingThrowIntelligenceProficiency: @"savingThrows.intelligence.proficiencyLevel",
             DKStatIDSavingThrowWisdomProficiency: @"savingThrows.wisdom.proficiencyLevel",
             DKStatIDSavingThrowCharismaProficiency: @"savingThrows.charisma.proficiencyLevel",
             
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
             
             DKStatIDSkillAcrobaticsProficiency: @"skills.acrobatics.proficiencyLevel",
             DKStatIDSkillAnimalHandlingProficiency: @"skills.animalHandling.proficiencyLevel",
             DKStatIDSkillArcanaProficiency: @"skills.arcana.proficiencyLevel",
             DKStatIDSkillAthleticsProficiency: @"skills.athletics.proficiencyLevel",
             DKStatIDSkillDeceptionProficiency: @"skills.deception.proficiencyLevel",
             DKStatIDSkillHistoryProficiency: @"skills.history.proficiencyLevel",
             DKStatIDSkillInsightProficiency: @"skills.insight.proficiencyLevel",
             DKStatIDSkillIntimidationProficiency: @"skills.intimidation.proficiencyLevel",
             DKStatIDSkillInvestigationProficiency: @"skills.investigation.proficiencyLevel",
             DKStatIDSkillMedicineProficiency: @"skills.medicine.proficiencyLevel",
             DKStatIDSkillNatureProficiency: @"skills.nature.proficiencyLevel",
             DKStatIDSkillPerceptionProficiency: @"skills.perception.proficiencyLevel",
             DKStatIDSkillPerformanceProficiency: @"skills.performance.proficiencyLevel",
             DKStatIDSkillPersuasionProficiency: @"skills.persuasion.proficiencyLevel",
             DKStatIDSkillReligionProficiency: @"skills.religion.proficiencyLevel",
             DKStatIDSkillSleightOfHandProficiency: @"skills.sleightOfHand.proficiencyLevel",
             DKStatIDSkillStealthProficiency: @"skills.stealth.proficiencyLevel",
             DKStatIDSkillSurvivalProficiency: @"skills.survival.proficiencyLevel",
             
             DKStatIDSkillPassivePerception: @"skills.passivePerception",
             
             DKStatIDCurrencyCopper: @"currency.copper",
             DKStatIDCurrencySilver: @"currency.silver",
             DKStatIDCurrencyElectrum: @"currency.electrum",
             DKStatIDCurrencyGold: @"currency.gold",
             DKStatIDCurrencyPlatinum: @"currency.platinum",
             
             DKStatIDSpellSaveDC: @"spells.spellSaveDC",
             DKStatIDSpellAttackBonus: @"spells.spellAttackBonus",
             DKStatIDPreparedSpells: @"spells.preparedSpells",
             DKStatIDPreparedSpellsMax: @"spells.preparedSpellsMax",
             
             DKStatIDFirstLevelSpellSlotsCurrent: @"spells.firstLevelSpellSlotsCurrent",
             DKStatIDSecondLevelSpellSlotsCurrent: @"spells.secondLevelSpellSlotsCurrent",
             DKStatIDThirdLevelSpellSlotsCurrent: @"spells.thirdLevelSpellSlotsCurrent",
             DKStatIDFourthLevelSpellSlotsCurrent: @"spells.fourthLevelSpellSlotsCurrent",
             DKStatIDFifthLevelSpellSlotsCurrent: @"spells.fifthLevelSpellSlotsCurrent",
             DKStatIDSixthLevelSpellSlotsCurrent: @"spells.sixthLevelSpellSlotsCurrent",
             DKStatIDSeventhLevelSpellSlotsCurrent: @"spells.seventhLevelSpellSlotsCurrent",
             DKStatIDEighthLevelSpellSlotsCurrent: @"spells.eighthLevelSpellSlotsCurrent",
             DKStatIDNinthLevelSpellSlotsCurrent: @"spells.ninthLevelSpellSlotsCurrent",
             
             DKStatIDFirstLevelSpellSlotsMax: @"spells.firstLevelSpellSlotsMax",
             DKStatIDSecondLevelSpellSlotsMax: @"spells.secondLevelSpellSlotsMax",
             DKStatIDThirdLevelSpellSlotsMax: @"spells.thirdLevelSpellSlotsMax",
             DKStatIDFourthLevelSpellSlotsMax: @"spells.fourthLevelSpellSlotsMax",
             DKStatIDFifthLevelSpellSlotsMax: @"spells.fifthLevelSpellSlotsMax",
             DKStatIDSixthLevelSpellSlotsMax: @"spells.sixthLevelSpellSlotsMax",
             DKStatIDSeventhLevelSpellSlotsMax: @"spells.seventhLevelSpellSlotsMax",
             DKStatIDEighthLevelSpellSlotsMax: @"spells.eighthLevelSpellSlotsMax",
             DKStatIDNinthLevelSpellSlotsMax: @"spells.ninthLevelSpellSlotsMax",
             
             DKStatIDCantrips: @"spells.spellbook.cantrips",
             DKStatIDFirstLevelSpells: @"spells.spellbook.firstLevelSpells",
             DKStatIDSecondLevelSpells: @"spells.spellbook.secondLevelSpells",
             DKStatIDThirdLevelSpells: @"spells.spellbook.thirdLevelSpells",
             DKStatIDFourthLevelSpells: @"spells.spellbook.fourthLevelSpells",
             DKStatIDFifthLevelSpells: @"spells.spellbook.fifthLevelSpells",
             DKStatIDSixthLevelSpells: @"spells.spellbook.sixthLevelSpells",
             DKStatIDSeventhLevelSpells: @"spells.spellbook.seventhLevelSpells",
             DKStatIDEighthLevelSpells: @"spells.spellbook.eighthLevelSpells",
             DKStatIDNinthLevelSpells: @"spells.spellbook.ninthLevelSpells",
             
             DKStatIDClericLevel: @"classes.cleric.classLevel",
             DKStatIDClericTraits: @"classes.cleric.classTraits",
             DKStatIDClericHitDice: @"classes.cleric.classHitDice",
             DKStatIDChannelDivinityUsesCurrent: @"classes.cleric.channelDivinityUsesCurrent",
             DKStatIDChannelDivinityUsesMax: @"classes.cleric.channelDivinityUsesMax",
             DKStatIDTurnUndead: @"classes.cleric.turnUndead",
             DKStatIDDivineIntervention: @"classes.cleric.divineIntervention",
             
             DKStatIDFighterLevel: @"classes.fighter.classLevel",
             DKStatIDFighterTraits: @"classes.fighter.classTraits",
             DKStatIDFighterHitDice: @"classes.fighter.classHitDice",
             DKStatIDSecondWindUsesCurrent: @"classes.fighter.secondWindUsesCurrent",
             DKStatIDSecondWindUsesMax: @"classes.fighter.secondWindUsesMax",
             DKStatIDActionSurgeUsesCurrent: @"classes.fighter.actionSurgeUsesCurrent",
             DKStatIDActionSurgeUsesMax: @"classes.fighter.actionSurgeUsesMax",
             DKStatIDExtraAttacks: @"classes.fighter.extraAttacks",
             DKStatIDIndomitableUsesCurrent: @"classes.fighter.indomitableUsesCurrent",
             DKStatIDIndomitableUsesMax: @"classes.fighter.indomitableUsesMax",
             };
}

+ (NSDictionary*) modifierGroupKeyPaths {
    return @{
             DKModifierGroupIDRace: @"race",
             DKModifierGroupIDSubrace: @"subrace",
             DKModifierGroupIDClericClass: @"classes.cleric.classModifiers",
             DKModifierGroupIDClericDivineDomain: @"classes.cleric.divineDomain",
             DKModifierGroupIDFighterClass: @"classes.fighter.classModifiers",
             DKModifierGroupIDFighterMartialArchetype: @"classes.fighter.martialArchetype",
             };
}

- (id)init {
    self = [super init];
    if (self) {
        
        NSDictionary* statKeyPaths = [DKCharacter5E statisticKeyPaths];
        for (NSString* statID in [statKeyPaths allKeys]) {
            [self addKeyPath:statKeyPaths[statID] forStatisticID:statID];
        }
        
        NSDictionary* groupKeyPaths = [DKCharacter5E modifierGroupKeyPaths];
        for (NSString* groupID in [groupKeyPaths allKeys]) {
            [self addKeyPath:groupKeyPaths[groupID] forModifierGroupID:groupID];
        }
        
        self.level = [DKNumericStatistic statisticWithInt:0];
        
        //Inspiration is binary
        self.inspiration = [DKNumericStatistic statisticWithInt:0];
        [_inspiration applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:1]];
        
        //Set up proficiency bonus to increase based on the level automatically
        self.proficiencyBonus = [DKNumericStatistic statisticWithInt:2];
        DKDependentModifier* levelModifier = [[DKDependentModifier alloc] initWithSource:_level
                                                                                   value:[NSExpression expressionWithFormat:
                                                                                          @"max:({ 0, ($source - 1) / 4 })"]
                                                                                priority:kDKModifierPriority_Additive
                                                                              expression:[DKModifierBuilder simpleAdditionModifierExpression]];
        [_proficiencyBonus applyModifier:levelModifier];
        
        //Initialize ability score block and saving throws
        self.abilities = [[DKAbilities5E alloc] initWithStr:10 dex:10 con:10 intel:10 wis:10 cha:10];
        self.savingThrows = [[DKSavingThrows5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
        self.skills = [[DKSkills5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
        self.spells = [[DKSpells5E alloc] initWithProficiencyBonus:_proficiencyBonus];
        self.currency = [[DKCurrency5E alloc] init];
        
        //Link maximum and current HP so that current HP value will update when max HP value changes
        self.hitPointsMax = [DKNumericStatistic statisticWithInt:0];
        self.hitPointsTemporary = [DKNumericStatistic statisticWithInt:0];
        self.hitPointsCurrent = [DKNumericStatistic statisticWithInt:0];
        [_hitPointsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_hitPointsMax]];
        [_hitPointsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_hitPointsTemporary]];
        
        //Set up hit dice similarly to HP dependencies
        self.hitDiceMax = [DKDiceStatistic statisticWithNoDice];
        self.hitDiceCurrent = [DKDiceStatistic statisticWithNoDice];
        
        //Initialize armor class so that it gets a bonus from dexterity
        self.armorClass = [DKNumericStatistic statisticWithInt:10];
        [_armorClass applyModifier:[_abilities.dexterity modifierFromAbilityScore]];
        
        //Initialize initiative so that it gets a bonus from dexterity
        self.initiativeBonus = [DKNumericStatistic statisticWithInt:0];
        [_initiativeBonus applyModifier:[_abilities.dexterity modifierFromAbilityScore]];
        
        self.movementSpeed = [DKNumericStatistic statisticWithInt:0];
        self.darkvisionRange = [DKNumericStatistic statisticWithInt:0];
        
        self.weaponProficiencies = [DKSetStatistic statisticWithEmptySet];
        self.armorProficiencies = [DKSetStatistic statisticWithEmptySet];
        self.toolProficiencies = [DKSetStatistic statisticWithEmptySet];
        
        self.languages = [DKSetStatistic statisticWithEmptySet];
        self.resistances = [DKSetStatistic statisticWithEmptySet];
        self.immunities = [DKSetStatistic statisticWithEmptySet];
        
        self.otherTraits = [DKNumericStatistic statisticWithInt:0];
        
        //Cap the value of death saves between 0 and 3
        self.deathSaveSuccesses = [DKNumericStatistic statisticWithInt:0];
        self.deathSaveFailures = [DKNumericStatistic statisticWithInt:0];
        [_deathSaveSuccesses applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:3]];
        [_deathSaveFailures applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:3]];
        
        //Now that all the statistics are set up, we can add modifier groups
        self.race = [DKRace5EBuilder human];
        self.subrace = nil;
        
        self.classes = [[DKClasses5E alloc] init];
        _classes.cleric = [[DKCleric5E alloc] initWithAbilities:_abilities];
        _classes.fighter = [[DKFighter5E alloc] initWithAbilities:_abilities];
    }
    return self;
}

@end
