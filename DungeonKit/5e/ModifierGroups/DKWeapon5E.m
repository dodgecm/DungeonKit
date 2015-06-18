//
//  DKWeapon5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 6/17/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKWeapon5E.h"
#import "DKAbilities5E.h"
#import "DKModifierBuilder.h"
#import "DKStatisticIDs5E.h"
#import "DKCharacter5E.h"

@implementation DKWeaponBuilder5E

+ (NSString*)weaponDamageStatIDForMainHand:(BOOL)isMainHand {
    if (isMainHand) { return DKStatIDMainHandWeaponDamage; }
    else { return DKStatIDOffHandWeaponDamage; }
}

+ (NSString*)weaponAttackBonusStatIDForMainHand:(BOOL)isMainHand {
    if (isMainHand) { return DKStatIDMainHandWeaponAttackBonus; }
    else { return DKStatIDOffHandWeaponAttackBonus; }
}

+ (NSString*)weaponRangeStatIDForMainHand:(BOOL)isMainHand {
    if (isMainHand) { return DKStatIDMainHandWeaponRange; }
    else { return DKStatIDOffHandWeaponRange; }
}

+ (NSString*)weaponAttacksPerActionStatIDForMainHand:(BOOL)isMainHand {
    if (isMainHand) { return DKStatIDMainHandWeaponAttacksPerAction; }
    else { return DKStatIDOffHandWeaponAttacksPerAction; }
}

+ (DKModifier*)proficiencyModifierFromBonus:(DKNumericStatistic*)proficiencyBonus
                        weaponProficiencies:(DKSetStatistic*)weaponProficiencies
                           proficiencyTypes:(NSArray*)proficiencyTypes {
    
    NSDictionary* dependencies = @{ @"bonus" : proficiencyBonus,
                                    @"proficiencies" : weaponProficiencies };
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithDependencies:dependencies
                                                                                value:[DKDependentModifierBuilder valueFromDependency:@"bonus"]
                                                                              enabled:[DKDependentModifierBuilder enabledWhen:@"proficiencies"containsAnyFromObjects:proficiencyTypes]
                                                                             priority:kDKModifierPriority_Additive
                                                                           expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    return modifier;
}

+ (DKModifier*)finesseAttackBonusModifierFromAbilities:(DKAbilities5E*)abilities {
    
    NSDictionary* dependencies = @{ @"str" : abilities.strength,
                                    @"dex" : abilities.dexterity};
    NSExpression* strExpression = [DKAbilityScore abilityScoreValueForDependency:@"str"];
    NSExpression* dexExpression = [DKAbilityScore abilityScoreValueForDependency:@"dex"];
    NSExpression* valueExpression = [NSExpression expressionForFunction:@"max:" arguments:@[ @[ strExpression, dexExpression ] ]];
    
    return [[DKDependentModifier alloc] initWithDependencies:dependencies
                                                       value:valueExpression
                                                     enabled:nil
                                                    priority:kDKModifierPriority_Additive
                                                  expression:[DKModifierBuilder simpleAdditionModifierExpression]];
}

+ (DKModifierGroup*)damageAbilityScoreModifierFromAbilities:(DKAbilities5E*)abilities
                                        weaponProficiencies:(DKSetStatistic*)weaponProficiencies
                                                   mainHand:(BOOL)isMainHand
                                                    finesse:(BOOL)isFinesse {
    DKModifierGroup* damage = [[DKModifierGroup alloc] init];
    
    NSDictionary* dependencies;
    NSExpression* valueExpression;
    if (isFinesse) {
        dependencies = @{ @"str" : abilities.strength,
                          @"dex" : abilities.dexterity,
                          @"proficiencies" : weaponProficiencies };
        NSExpression* strExpression = [DKAbilityScore abilityScoreValueForDependency:@"str"];
        NSExpression* dexExpression = [DKAbilityScore abilityScoreValueForDependency:@"dex"];
        valueExpression = [NSExpression expressionForFunction:@"max:" arguments:@[ @[ strExpression, dexExpression ] ]];
    } else {
        dependencies = @{ @"str" : abilities.strength,
                          @"proficiencies" : weaponProficiencies };
        valueExpression = [DKAbilityScore abilityScoreValueForDependency:@"str"];
    }
    
    NSPredicate* enabled;
    if (isMainHand) {
        enabled = nil;
    } else {
        enabled = [DKDependentModifierBuilder enabledWhen:@"proficiencies" containsObject:@"Two-Weapon Fighting"];
    }
    
    [damage addModifier:[[DKDependentModifier alloc] initWithDependencies:dependencies
                                                                    value:[DKDependentModifierBuilder valueAsDiceCollectionFromExpression:valueExpression]
                                                                  enabled:enabled
                                                                 priority:kDKModifierPriority_Additive
                                                               expression:[DKModifierBuilder simpleAddDiceModifierExpression]]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    
    if (!isMainHand) {
        //For non proficient off-hand weapon, the ability score only gets applied if it is negative
        valueExpression = [NSExpression expressionForFunction:@"min:" arguments:@[ @[ valueExpression, [NSExpression expressionForConstantValue:@(0)] ] ] ];
        DKModifier* nonProficientModifier = [[DKDependentModifier alloc] initWithDependencies:dependencies
                                                                                        value:[DKDependentModifierBuilder valueAsDiceCollectionFromExpression:valueExpression]
                                                                                      enabled:[DKDependentModifierBuilder enabledWhen:@"proficiencies" doesNotContainAnyFromObjects:@[ @"Two-Weapon Fighting"] ]
                                                                                     priority:kDKModifierPriority_Additive
                                                                                   expression:[DKModifierBuilder simpleAddDiceModifierExpression]];
        nonProficientModifier.explanation = @"Off-hand weapons do not receive ability score bonuses to damage unless the ability score is negative or the character is proficient in Two-Weapon Fighting.";
        [damage addModifier:nonProficientModifier
             forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
        
    }
    
    return damage;
}

+ (DKWeapon5E*)weaponWithName:(NSString*)name
                   damageDice:(DKDiceCollection*)damageDice
          versatileDamageDice:(DKDiceCollection*)versatileDamageDiceOrNil
                   damageType:(NSString*)damageType
             proficiencyTypes:(NSArray*)proficiencyTypes
                   isMainHand:(BOOL)isMainHand
                   meleeReach:(NSInteger)meleeReach
                  rangedReach:(NSValue*)rangedReachOrNil
              otherAttributes:(NSArray*)attributes
                    abilities:(DKAbilities5E*)abilities
             proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
                characterSize:(DKStringStatistic*)characterSize
          weaponProficiencies:(DKSetStatistic*)weaponProficiencies
              offHandOccupied:(DKNumericStatistic*)offHandOccupied {
    
    BOOL hasAmmunition = [attributes containsObject:@"Ammunition"];
    BOOL isFinesse = [attributes containsObject:@"Finesse"];
    BOOL isTwoHanded = [attributes containsObject:@"Two-handed"];
    BOOL isLight = [attributes containsObject:@"Light"];
    BOOL isHeavy = [attributes containsObject:@"Heavy"];
    BOOL isLoading = [attributes containsObject:@"Loading"];
    
    NSAssert(isMainHand || isLight, @"Weapon cannot be off-handed unless it is a light weapon");
    
    DKModifierGroup* weapon = [[DKModifierGroup alloc] init];
    weapon.explanation = [name copy];
    
    //Damage dice
    if (!versatileDamageDiceOrNil || !isMainHand) {
        [weapon addModifier:[DKModifierBuilder modifierWithAddedDice:damageDice]
             forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    } else {
        
        //Versatile weapon damage dice
        [weapon addModifier:[DKDependentModifierBuilder appendedModifierFromSource:offHandOccupied
                                                                     constantValue:damageDice
                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                    isGreaterThanOrEqualTo:1]
                                                                       explanation:@"Versatile damage bonus requires a free off hand"]
             forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
        
        [weapon addModifier:[DKDependentModifierBuilder appendedModifierFromSource:offHandOccupied
                                                                     constantValue:versatileDamageDiceOrNil
                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                        isEqualToOrBetween:0 and:0]
                                                                       explanation:@"Versatile damage bonus"]
             forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    }
    
    //Damage type
    [weapon addModifier:[DKModifierBuilder modifierWithExplanation:[NSString stringWithFormat:@"%@ damage", damageType]]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    
    //Ability score bonus to damage
    [weapon addSubgroup:[DKWeaponBuilder5E damageAbilityScoreModifierFromAbilities:abilities
                                                               weaponProficiencies:weaponProficiencies
                                                                          mainHand:isMainHand
                                                                           finesse:isFinesse]];
    
    //Ability score bonus to hit
    if (isFinesse) {
        [weapon addModifier:[DKWeaponBuilder5E finesseAttackBonusModifierFromAbilities:abilities]
             forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    } else {
        [weapon addModifier:[abilities.strength modifierFromAbilityScore]
             forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    }
    
    //Proficiency bonus to hit
    [weapon addModifier:[DKWeaponBuilder5E proficiencyModifierFromBonus:proficiencyBonus
                                                    weaponProficiencies:weaponProficiencies
                                                       proficiencyTypes:proficiencyTypes]
         forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    
    //Melee reach
    [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:meleeReach]
         forStatisticID:[DKWeaponBuilder5E weaponRangeStatIDForMainHand:isMainHand]];
    
    //Ranged reach
    if (rangedReachOrNil) {
        NSRange range = [rangedReachOrNil rangeValue];
        [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:range.location
                                                             explanation:[NSString stringWithFormat:@"%@ thrown range limit", name]]
             forStatisticID:[DKWeaponBuilder5E weaponRangeStatIDForMainHand:isMainHand]];
        [weapon addModifier:[DKModifierBuilder modifierWithExplanation:
                             [NSString stringWithFormat:@"Roll at disadvantage to throw at targets between %lul and %lul feet away",
                              (unsigned long)range.location, (unsigned long)NSMaxRange(range)]]
             forStatisticID:[DKWeaponBuilder5E weaponRangeStatIDForMainHand:isMainHand]];
    }
    
    //Number of attacks per action
    [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1]
         forStatisticID:[DKWeaponBuilder5E weaponAttacksPerActionStatIDForMainHand:isMainHand]];
    
    //Ammunition weapons
    if (hasAmmunition) {
        [weapon addModifier:[DKModifierBuilder modifierWithExplanation:@"This weapon requires ammunition in order to execute a ranged attack."]
             forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    }
    
    //Loading weapons
    if (isLoading) {
        [weapon addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Weapons that need to be loaded may only be fired once per action, bonus action, or reaction."]
             forStatisticID:[DKWeaponBuilder5E weaponAttacksPerActionStatIDForMainHand:isMainHand]];
    }
    
    //Heavy weapons
    if (isHeavy) {
        [weapon addModifier:[DKDependentModifierBuilder informationalModifierFromSource:characterSize
                                                                                enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                isEqualToAnyFromStrings:@[@"Small", @"Tiny"]]
                                                                            explanation:@"Small creatures have disadvantage on attack rolls with heavy weapons."]
             forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    }
    
    //Occupy hands as appropriate
    if (isMainHand) {
        [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDMainHandOccupied];
    }
    if (!isMainHand || isTwoHanded) {
        [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDOffHandOccupied];
    }
    
    return weapon;
}

#pragma mark -

+ (DKWeapon5E*)weaponOfType:(DKWeaponType5E)type
               forCharacter:(DKCharacter5E*)character
                 isMainHand:(BOOL)isMainHand {
    
    return [DKWeaponBuilder5E weaponOfType:type
                                 abilities:character.abilities
                          proficiencyBonus:character.proficiencyBonus
                             characterSize:character.size
                       weaponProficiencies:character.weaponProficiencies
                           offHandOccupied:character.equipment.offHandOccupied
                                isMainHand:isMainHand];
}

+ (DKWeapon5E*)weaponOfType:(DKWeaponType5E)type
                  abilities:(DKAbilities5E*)abilities
           proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
              characterSize:(DKStringStatistic*)characterSize
        weaponProficiencies:(DKSetStatistic*)weaponProficiencies
            offHandOccupied:(DKNumericStatistic*)offHandOccupied
                 isMainHand:(BOOL)isMainHand {
    
    switch (type) {
            
        case kDKWeaponType5E_Unarmed: {
            return [DKWeaponBuilder5E weaponWithName:@"Unarmed"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:0 sides:0 modifier:1]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Simple Weapons"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Club: {
            return [DKWeaponBuilder5E weaponWithName:@"Club"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Simple Weapons", @"Clubs"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Dagger: {
            return [DKWeaponBuilder5E weaponWithName:@"Dagger"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Daggers"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(20, 60)]
                                     otherAttributes:@[@"Finesse", @"Light"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Greatclub: {
            return [DKWeaponBuilder5E weaponWithName:@"Greatclub"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Simple Weapons", @"Clubs"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Handaxe: {
            return [DKWeaponBuilder5E weaponWithName:@"Handaxe"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Axes"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(20, 60)]
                                     otherAttributes:@[@"Light"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Javelin: {
            return [DKWeaponBuilder5E weaponWithName:@"Javelin"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Javelins"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(30, 120)]
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_LightHammer: {
            return [DKWeaponBuilder5E weaponWithName:@"Light hammer"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Simple Weapons", @"Hammers"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(20, 60)]
                                     otherAttributes:@[@"Light"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Mace: {
            return [DKWeaponBuilder5E weaponWithName:@"Mace"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Simple Weapons", @"Maces"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Quarterstaff: {
            return [DKWeaponBuilder5E weaponWithName:@"Quarterstaff"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Simple Weapons", @"Quarterstaves"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Sickle: {
            return [DKWeaponBuilder5E weaponWithName:@"Sickle"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Sickles"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Light"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Spear: {
            return [DKWeaponBuilder5E weaponWithName:@"Spear"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Spears"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(20, 60)]
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_LightCrossbow: {
            return [DKWeaponBuilder5E weaponWithName:@"Light Crossbow"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Crossbows"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(80, 320)]
                                     otherAttributes:@[@"Ammunition", @"Loading", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Dart: {
            return [DKWeaponBuilder5E weaponWithName:@"Dart"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Darts"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(20, 60)]
                                     otherAttributes:@[@"Finesse"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Shortbow: {
            return [DKWeaponBuilder5E weaponWithName:@"Shortbow"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Simple Weapons", @"Shortbows"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(80, 320)]
                                     otherAttributes:@[@"Ammunition", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Sling: {
            return [DKWeaponBuilder5E weaponWithName:@"Sling"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Simple Weapons", @"Slings"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(30, 120)]
                                     otherAttributes:@[@"Ammunition"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Battleaxe: {
            return [DKWeaponBuilder5E weaponWithName:@"Battleaxe"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:10 modifier:0]
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Axes"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Flail: {
            return [DKWeaponBuilder5E weaponWithName:@"Flail"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Martial Weapons", @"Flails"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Glaive: {
            return [DKWeaponBuilder5E weaponWithName:@"Glaive"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:10 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Glaives"]
                                          isMainHand:isMainHand
                                          meleeReach:10
                                         rangedReach:nil
                                     otherAttributes:@[@"Heavy", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Greataxe: {
            return [DKWeaponBuilder5E weaponWithName:@"Greataxe"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:12 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Greataxes"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Heavy", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Greatsword: {
            return [DKWeaponBuilder5E weaponWithName:@"Greatsword"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:2 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Greatswords"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Heavy", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Halberd: {
            return [DKWeaponBuilder5E weaponWithName:@"Halberd"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:10 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Halberds"]
                                          isMainHand:isMainHand
                                          meleeReach:10
                                         rangedReach:nil
                                     otherAttributes:@[@"Heavy", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Lance: {
            DKWeapon5E* lance = [DKWeaponBuilder5E weaponWithName:@"Lance"
                                                       damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:12 modifier:0]
                                              versatileDamageDice:nil
                                                       damageType:@"Piercing"
                                                 proficiencyTypes:@[@"Martial Weapons", @"Lances"]
                                                       isMainHand:isMainHand
                                                       meleeReach:10
                                                      rangedReach:nil
                                                  otherAttributes:nil
                                                        abilities:abilities
                                                 proficiencyBonus:proficiencyBonus
                                                    characterSize:characterSize
                                              weaponProficiencies:weaponProficiencies
                                                  offHandOccupied:offHandOccupied];
            
            return lance;
            break;
        }
            
        case kDKWeaponType5E_Longsword: {
            return [DKWeaponBuilder5E weaponWithName:@"Longsword"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:10 modifier:0]
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Longswords"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Maul: {
            return [DKWeaponBuilder5E weaponWithName:@"Maul"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:2 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Martial Weapons", @"Mauls"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Heavy", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Morningstar: {
            return [DKWeaponBuilder5E weaponWithName:@"Morningstar"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Morningstars"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Pike: {
            return [DKWeaponBuilder5E weaponWithName:@"Pike"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:10 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Pikes"]
                                          isMainHand:isMainHand
                                          meleeReach:10
                                         rangedReach:nil
                                     otherAttributes:@[@"Heavy", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Rapier: {
            return [DKWeaponBuilder5E weaponWithName:@"Rapier"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Rapiers"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Finesse"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Scimitar: {
            return [DKWeaponBuilder5E weaponWithName:@"Scimitar"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Scimitars"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Finesse", @"Light"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Shortsword: {
            return [DKWeaponBuilder5E weaponWithName:@"Shortsword"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Shortswords"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:@[@"Finesse", @"Light"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Trident: {
            return [DKWeaponBuilder5E weaponWithName:@"Trident"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Tridents"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(20, 60)]
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_WarPick: {
            return [DKWeaponBuilder5E weaponWithName:@"War Pick"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Picks"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Warhammer: {
            return [DKWeaponBuilder5E weaponWithName:@"Warhammer"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:10 modifier:0]
                                          damageType:@"Bludgeoning"
                                    proficiencyTypes:@[@"Martial Weapons", @"Warhammers"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:nil
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Whip: {
            return [DKWeaponBuilder5E weaponWithName:@"Whip"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Slashing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Whips"]
                                          isMainHand:isMainHand
                                          meleeReach:10
                                         rangedReach:nil
                                     otherAttributes:@[@"Finesse"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Blowgun: {
            return [DKWeaponBuilder5E weaponWithName:@"Blowgun"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:0 sides:0 modifier:1]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Blowguns"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(25, 100)]
                                     otherAttributes:@[@"Ammunition", @"Loading"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_HandCrossbow: {
            return [DKWeaponBuilder5E weaponWithName:@"Hand Crossbow"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Crossbows"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(30, 120)]
                                     otherAttributes:@[@"Ammunition", @"Light", @"Loading"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_HeavyCrossbow: {
            return [DKWeaponBuilder5E weaponWithName:@"Heavy Crossbow"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:10 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Crossbows"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(100, 400)]
                                     otherAttributes:@[@"Ammunition", @"Heavy", @"Loading", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Longbow: {
            return [DKWeaponBuilder5E weaponWithName:@"Longbow"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:8 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@"Piercing"
                                    proficiencyTypes:@[@"Martial Weapons", @"Longbows"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(150, 600)]
                                     otherAttributes:@[@"Ammunition", @"Heavy", @"Two-handed"]
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        case kDKWeaponType5E_Net: {
            return [DKWeaponBuilder5E weaponWithName:@"Net"
                                          damageDice:[DKDiceCollection diceCollectionWithQuantity:0 sides:0 modifier:0]
                                 versatileDamageDice:nil
                                          damageType:@""
                                    proficiencyTypes:@[@"Martial Weapons", @"Nets"]
                                          isMainHand:isMainHand
                                          meleeReach:5
                                         rangedReach:[NSValue valueWithRange:NSMakeRange(5, 15)]
                                     otherAttributes:nil
                                           abilities:abilities
                                    proficiencyBonus:proficiencyBonus
                                       characterSize:characterSize
                                 weaponProficiencies:weaponProficiencies
                                     offHandOccupied:offHandOccupied];
            break;
        }
            
        default:
            break;
    }
    
    NSLog(@"DKWeaponBuilder5E: Unrecognized weapon type: %li", (long)type);
    return nil;
}

@end
