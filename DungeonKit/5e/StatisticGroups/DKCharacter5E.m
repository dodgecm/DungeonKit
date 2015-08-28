//
//  DKCharacter5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/3/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCharacter5E.h"
#import "DKModifierBuilder.h"
#import "DKStatisticIDs5E.h"
#import "DKModifierGroupIDs5E.h"
#import "DKStatisticGroupIDs5E.h"

@implementation DKCharacter5E

@synthesize name = _name;
@synthesize level = _level;
@synthesize size = _size;
@synthesize alignment = _alignment;
@synthesize inspiration = _inspiration;
@synthesize proficiencyBonus = _proficiencyBonus;
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

@synthesize classes = _classes;
@synthesize abilities = _abilities;
@synthesize savingThrows = _savingThrows;
@synthesize skills = _skills;
@synthesize spells = _spells;
@synthesize currency = _currency;
@synthesize equipment = _equipment;

@synthesize race = _race;
@synthesize subrace = _subrace;

- (NSDictionary*) statisticKeyPaths {
    return @{
             DKStatIDName: @"name",
             DKStatIDLevel: @"level",
             DKStatIDInspiration: @"inspiration",
             DKStatIDProficiencyBonus: @"proficiencyBonus",
             DKStatIDSize: @"size",
             DKStatIDAlignment: @"alignment",
             
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
             };
}

- (NSDictionary*) statisticGroupKeyPaths {
    return @{
             DKStatisticGroupIDAbilities: @"abilities",
             DKStatisticGroupIDClasses: @"classes",
             DKStatisticGroupIDCurrency: @"currency",
             DKStatisticGroupIDEquipment: @"equipment",
             DKStatisticGroupIDSavingThrows: @"savingThrows",
             DKStatisticGroupIDSkills: @"skills",
             DKStatisticGroupIDSpells: @"spells",
             };
}

- (NSDictionary*) modifierGroupKeyPaths {
    return @{
             DKModifierGroupIDRace: @"race",
             DKModifierGroupIDSubrace: @"subrace",
             
             DKModifierGroupIDClericClass: @"classes.cleric.classModifiers",
             DKModifierGroupIDFighterClass: @"classes.fighter.classModifiers",
             DKModifierGroupIDRogueClass: @"classes.rogue.classModifiers",
             DKModifierGroupIDWizardClass: @"classes.wizard.classModifiers",
             DKModifierGroupIDWizardArcaneTradition: @"classes.wizard.arcaneTradition",
             
             DKModifierGroupIDMainHandWeapon: @"equipment.mainHandWeapon",
             DKModifierGroupIDOffHandWeapon: @"equipment.offHandWeapon",
             DKModifierGroupIDArmor: @"equipment.armor",
             DKModifierGroupIDShield: @"equipment.shield",
             DKModifierGroupIDOtherEquipment: @"equipment.otherEquipment",
             };
}

- (void)loadStatistics {
    
    self.name = [DKStringStatistic statisticWithString:@""];
    self.level = [DKNumericStatistic statisticWithInt:0];
    self.size = [DKStringStatistic statisticWithString:@""];
    self.alignment = [DKStringStatistic statisticWithString:@""];
    
    self.inspiration = [DKNumericStatistic statisticWithInt:0];
    self.proficiencyBonus = [DKNumericStatistic statisticWithInt:2];
    
    self.hitPointsMax = [DKNumericStatistic statisticWithInt:0];
    self.hitPointsTemporary = [DKNumericStatistic statisticWithInt:0];
    self.hitPointsCurrent = [DKNumericStatistic statisticWithInt:0];
    self.hitDiceMax = [DKDiceStatistic statisticWithNoDice];
    self.hitDiceCurrent = [DKDiceStatistic statisticWithNoDice];
    
    self.armorClass = [DKNumericStatistic statisticWithInt:10];
    self.initiativeBonus = [DKNumericStatistic statisticWithInt:0];
    
    self.movementSpeed = [DKNumericStatistic statisticWithInt:0];
    self.darkvisionRange = [DKNumericStatistic statisticWithInt:0];
    
    self.weaponProficiencies = [DKSetStatistic statisticWithEmptySet];
    self.armorProficiencies = [DKSetStatistic statisticWithEmptySet];
    self.toolProficiencies = [DKSetStatistic statisticWithEmptySet];
    
    self.languages = [DKSetStatistic statisticWithEmptySet];
    self.resistances = [DKSetStatistic statisticWithEmptySet];
    self.immunities = [DKSetStatistic statisticWithEmptySet];
    
    self.otherTraits = [DKSetStatistic statisticWithEmptySet];
    
    self.deathSaveSuccesses = [DKNumericStatistic statisticWithInt:0];
    self.deathSaveFailures = [DKNumericStatistic statisticWithInt:0];
}

- (void)loadStatisticGroups {
    
    //Initialize ability score block and saving throws
    self.abilities = [[DKAbilities5E alloc] initWithStr:10 dex:10 con:10 intel:10 wis:10 cha:10];
    self.savingThrows = [[DKSavingThrows5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
    self.skills = [[DKSkills5E alloc] initWithAbilities:_abilities proficiencyBonus:_proficiencyBonus];
    self.spells = [[DKSpellcasting5E alloc] initWithProficiencyBonus:_proficiencyBonus];
    self.currency = [[DKCurrency5E alloc] init];
    
    self.equipment = [[DKEquipment5E alloc] initWithAbilities:_abilities
                                             proficiencyBonus:_proficiencyBonus
                                                characterSize:_size
                                          weaponProficiencies:_weaponProficiencies
                                           armorProficiencies:_armorProficiencies];
    
    self.classes = [[DKClasses5E alloc] init];
}

- (void)loadModifiers {
    
    //Inspiration is binary
    [_inspiration applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:1]];
    
    //Set up proficiency bonus to increase based on the level automatically
    DKModifier* levelModifier = [[DKModifier alloc] initWithSource:_level
                                                             value:[NSExpression expressionWithFormat:
                                                                    @"max:({ 0, ($source - 1) / 4 })"]
                                                          priority:kDKModifierPriority_Additive
                                                        expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [_proficiencyBonus applyModifier:levelModifier];
    
    //Link maximum and current HP so that current HP value will update when max HP value changes
    [_hitPointsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_hitPointsMax]];
    [_hitPointsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_hitPointsTemporary]];
    
    [_initiativeBonus applyModifier:[_abilities.dexterity modifierFromAbilityScore]];
    
    [_deathSaveSuccesses applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:3]];
    [_deathSaveFailures applyModifier:[DKModifierBuilder modifierWithClampBetween:0 and:3]];
    
    //Modifier groups
    self.race = [DKRace5EBuilder human];
    self.subrace = nil;
}

@end
