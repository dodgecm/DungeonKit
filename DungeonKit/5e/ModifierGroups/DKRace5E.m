//
//  DKRace5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKRace5E.h"
#import "DKStatisticIDs5E.h"
#import "DKCharacter5E.h"
#import "DKWeapon5E.h"
#import "DKModifierBuilder.h"

@implementation DKRace5EBuilder

+ (DKRace5E*)dwarf {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    race.explanation = @"Dwarven racial modifiers";
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Dwarven racial trait"]
       forStatisticID:DKStatIDConstitution];
    [race addModifier:[DKModifierBuilder modifierWithOverrideString:@"Medium"] forStatisticID:DKStatIDSize];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:25 explanation:@"Dwarven base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Dwarven Trait: Speed is not reduced by wearing heavy armor"]
       forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:60 explanation:@"Dwarven darkvision range"]
       forStatisticID:DKStatIDDarkvision];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Poison" explanation:@"Dwarven Resilience: Resistance against poison damage"]
       forStatisticID:DKStatIDResistances];
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Dwarven Resilience: Advantage on saving throws against poison"]
       forStatisticID:DKStatIDSavingThrowOther];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Battleaxe]
                                                        explanation:@"Dwarven Combat Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Handaxe]
                                                        explanation:@"Dwarven Combat Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_LightHammer]
                                                        explanation:@"Dwarven Combat Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Warhammer]
                                                        explanation:@"Dwarven Combat Training"] forStatisticID:DKStatIDWeaponProficiencies];
    
    DKModifierGroup* toolSubgroup = [[DKModifierGroup alloc] init];
    toolSubgroup.explanation = @"Dwarven Tool Proficiency: Proficiency with one of the following: smith's tools, brewer's supplies, or mason's tools";
    [toolSubgroup addModifier:[DKModifierBuilder modifierWithAppendedString:@"Smith's Tools" explanation:@"Dwarven Tool Proficiency (default)"]
               forStatisticID:DKStatIDToolProficiencies];
    [race addSubgroup:toolSubgroup];
    
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Dwarven Stonecunning: When making a History check related to the origin of stonework, "
                       "you are considered proficient in the History skill and add double your proficiency bonus to the check, instead of your normal proficiency bonus"]
       forStatisticID:DKStatIDSkillHistory];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Common" explanation:@"Dwarven Languages"]
       forStatisticID:DKStatIDLanguages];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Dwarvish" explanation:@"Dwarven Languages"]
       forStatisticID:DKStatIDLanguages];
    
    return race;
}

+ (DKRace5E*)elf {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    race.explanation = @"Elven racial modifiers";
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Elven racial dexterity bonus"]
       forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithOverrideString:@"Medium"] forStatisticID:DKStatIDSize];
    [race addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Elven Keen Senses: Proficiency in the Perception skill"]
       forStatisticID:DKStatIDSkillPerceptionProficiency];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:30 explanation:@"Elven base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:60 explanation:@"Elven darkvision range"]
       forStatisticID:DKStatIDDarkvision];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Sleep" explanation:@"Elven Fey Ancestry: Immune to magical sleep effects"]
       forStatisticID:DKStatIDImmunities];
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Elven Fey Ancestry: Advantage on saving throws against being charmed"]
       forStatisticID:DKStatIDSavingThrowOther];
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Elven Trance: Medidate deeply for 4 hours to gain the same benefit as 8 hours of human sleep"]
       forStatisticID:DKStatIDOtherTraits];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Common" explanation:@"Elven Languages"]
       forStatisticID:DKStatIDLanguages];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Elvish" explanation:@"Elven Languages"]
       forStatisticID:DKStatIDLanguages];
    
    return race;
}

+ (DKRace5E*)halfling {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    race.explanation = @"Halfling racial modifiers";
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Halfling racial dexterity bonus"]
       forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithOverrideString:@"Small"] forStatisticID:DKStatIDSize];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:25 explanation:@"Halfling base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Halfling Lucky: On a roll of 1 on an attack roll, ability check, or saving throw, "
                       "reroll the die and use the new roll"]
       forStatisticID:DKStatIDOtherTraits];
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Halfling Nimbleness: Able to move through the space of any creature"
                       "that is of a size larger than yours"]
       forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithExplanation:@"Halfling Bravery: Advantage on saving throws against being frightened"]
       forStatisticID:DKStatIDSavingThrowOther];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Common" explanation:@"Halfling Languages"]
       forStatisticID:DKStatIDLanguages];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Halfling" explanation:@"Halfling Languages"]
       forStatisticID:DKStatIDLanguages];
    return race;
}

+ (DKRace5E*)human {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    race.explanation = @"Human racial modifiers";
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial strength bonus"]
       forStatisticID:DKStatIDStrength];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial dexterity bonus"]
       forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial constitution bonus"]
       forStatisticID:DKStatIDConstitution];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial intelligence bonus"]
       forStatisticID:DKStatIDIntelligence];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial wisdom bonus"]
       forStatisticID:DKStatIDWisdom];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial charisma bonus"]
       forStatisticID:DKStatIDCharisma];
    [race addModifier:[DKModifierBuilder modifierWithOverrideString:@"Medium"] forStatisticID:DKStatIDSize];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:30  explanation:@"Human base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithAppendedString:@"Common" explanation:@"Human Languages"]
       forStatisticID:DKStatIDLanguages];
    
    DKModifierGroup* languageSubgroup = [[DKModifierGroup alloc] init];
    languageSubgroup.explanation = @"Human Language Proficiency: Knowledge of one chosen language";
    [languageSubgroup addModifier:[DKModifierBuilder modifierWithAppendedString:@"Dwarvish" explanation:@"Human Bonus Language (default)"]
       forStatisticID:DKStatIDLanguages];
    [race addSubgroup:languageSubgroup];
    
    return race;
}

@end


@implementation DKSubrace5EBuilder

+ (DKSubrace5E*)hillDwarfFromCharacter:(DKCharacter5E*)character {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    subrace.explanation = @"Hill Dwarf racial modifiers";
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Hill Dwarf racial wisdom bonus"] forStatisticID:DKStatIDWisdom];
    
    DKModifier* hpModifier = [DKDependentModifierBuilder simpleModifierFromSource:character.level];
    hpModifier.explanation = @"Hill Dwarf racial hit point bonus";
    [subrace addModifier:hpModifier forStatisticID:DKStatIDHitPointsMax];
    
    return subrace;
}

+ (DKSubrace5E*)mountainDwarf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    subrace.explanation = @"Mountain Dwarf racial modifiers";
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Mountain Dwarf racial strength bonus"]
          forStatisticID:DKStatIDStrength];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Light]
                                                           explanation:@"Mountain Dwarf Armor Training"]
                   forStatisticID:DKStatIDArmorProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Medium]
                                                           explanation:@"Mountain Dwarf Armor Training"]
          forStatisticID:DKStatIDArmorProficiencies];
    return subrace;
}

+ (DKSubrace5E*)highElf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    subrace.explanation = @"High Elf racial modifiers";
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"High Elf racial intelligence bonus"]
          forStatisticID:DKStatIDIntelligence];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longsword]
                                                           explanation:@"High Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortsword]
                                                           explanation:@"High Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortbow]
                                                           explanation:@"High Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longbow]
                                                           explanation:@"High Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    
    DKModifierGroup* languageSubgroup = [[DKModifierGroup alloc] init];
    languageSubgroup.explanation = @"High Elf Language Proficiency: Knowledge of one chosen language";
    [languageSubgroup addModifier:[DKModifierBuilder modifierWithAppendedString:@"Sylvan" explanation:@"High Elf Bonus Language (default)"]
                   forStatisticID:DKStatIDLanguages];
    [subrace addSubgroup:languageSubgroup];
    
    //TODO: Cantrip
    return subrace;
}

+ (DKSubrace5E*)woodElf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    subrace.explanation = @"Wood Elf racial modifiers";
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Wood Elf racial wisdom bonus"] forStatisticID:DKStatIDWisdom];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longsword]
                                                           explanation:@"Wood Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortsword]
                                                           explanation:@"Wood Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortbow]
                                                           explanation:@"Wood Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longbow]
                                                           explanation:@"Wood Elf Weapon Training"] forStatisticID:DKStatIDWeaponProficiencies];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:5 explanation:@"Wood Elf racial movement speed bonus"] forStatisticID:DKStatIDMoveSpeed];
    [subrace addModifier:[DKModifierBuilder modifierWithExplanation:@"Wood Elf Mask of the Wild: Can attempt to hide even when lightly obscured by foliage, "
                          "heavy rain, falling snow, mist, and other natural phenomena"]
          forStatisticID:DKStatIDSkillStealth];
    return subrace;
}

+ (DKSubrace5E*)lightfootHalfling {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    subrace.explanation = @"Lightfoot Halfling racial modifiers";
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Lightfoot Halfling racial charisma bonus"]
          forStatisticID:DKStatIDCharisma];
    [subrace addModifier:[DKModifierBuilder modifierWithExplanation:@"Lightfoot Halfling Natural Stealth: Able to attempt to hide even when obscured "
                          "by a creature that is at least one size larger than you"]
          forStatisticID:DKStatIDSkillStealth];
    return subrace;
}

+ (DKSubrace5E*)stoutHalfling {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    subrace.explanation = @"Stout Halfling racial modifiers";
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Stout halfling racial constitution bonus"]
          forStatisticID:DKStatIDConstitution];
    [subrace addModifier:[DKModifierBuilder modifierWithAppendedString:@"Poison" explanation:@"Stout Halfling Resilience"]
       forStatisticID:DKStatIDResistances];
    [subrace addModifier:[DKModifierBuilder modifierWithExplanation:@"Stout Halfling Resilience: Advantage on saving throws against poison"]
       forStatisticID:DKStatIDSavingThrowOther];
    return subrace;
}

@end