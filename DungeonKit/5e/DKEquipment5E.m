//
//  DKEquipment5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 5/5/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKEquipment5E.h"
#import "DKStatisticIDs5E.h"
#import "DKModifierBuilder.h"
#import "DKAbilities5E.h"

@implementation DKEquipment5E

@synthesize mainHandWeapon = _mainHandWeapon;
@synthesize mainHandWeaponAttackBonus = _mainHandWeaponAttackBonus;
@synthesize mainHandWeaponDamage = _mainHandWeaponDamage;
@synthesize mainHandWeaponRange = _mainHandWeaponRange;

@synthesize offHandWeapon = _offHandWeapon;
@synthesize offHandWeaponAttackBonus = _offHandWeaponAttackBonus;
@synthesize offHandWeaponDamage = _offHandWeaponDamage;
@synthesize offHandWeaponRange = _offHandWeaponRange;

@synthesize armor = _armor;
@synthesize shield = _shield;
@synthesize otherEquipment = _otherEquipment;

- (id)initWithAbilities:(DKAbilities5E*)abilities
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
    weaponProficiencies:(DKSetStatistic*)weaponProficiencies {
    
    self = [super init];
    if (self) {
        
        self.mainHandWeaponAttackBonus = [DKNumericStatistic statisticWithInt:0];
        self.mainHandWeaponDamage = [DKDiceStatistic statisticWithNoDice];
        self.mainHandWeaponRange = [DKNumericStatistic statisticWithInt:0];
        
        self.offHandWeaponAttackBonus = [DKNumericStatistic statisticWithInt:0];
        self.offHandWeaponDamage = [DKDiceStatistic statisticWithNoDice];
        self.offHandWeaponRange = [DKNumericStatistic statisticWithInt:0];
        
        self.mainHandWeapon = [DKWeaponBuilder5E unarmedFromAbilities:abilities
                                                     proficiencyBonus:proficiencyBonus
                                                  weaponProficiencies:weaponProficiencies];
    }
    return self;
}

@end

#pragma mark -

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

#pragma mark -

+ (DKModifierGroup*)unarmedFromAbilities:(DKAbilities5E*)abilities
                        proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
                     weaponProficiencies:(DKSetStatistic*)weaponProficiencies {
    
    DKModifierGroup* weapon = [[DKModifierGroup alloc] init];
    weapon.explanation = @"Unarmed Strike";
    
    [weapon addModifier:[DKModifierBuilder modifierWithAddedDice:[DKDiceCollection diceCollectionWithQuantity:0 sides:0 modifier:1]]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:YES]];
    [weapon addSubgroup:[DKWeaponBuilder5E damageAbilityScoreModifierFromAbilities:abilities
                                                               weaponProficiencies:weaponProficiencies
                                                                          mainHand:YES
                                                                           finesse:NO]];
    [weapon addModifier:[DKModifierBuilder modifierWithExplanation:@"Bludgeoninig damage"]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:YES]];
    
    [weapon addModifier:[abilities.strength modifierFromAbilityScore]
         forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:YES]];
    [weapon addModifier:[DKWeaponBuilder5E proficiencyModifierFromBonus:proficiencyBonus
                                                    weaponProficiencies:weaponProficiencies
                                                       proficiencyTypes:@[@"Simple Weapons"]]
         forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:YES]];
    
    [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:5]
         forStatisticID:[DKWeaponBuilder5E weaponRangeStatIDForMainHand:YES]];
    return weapon;
}

+ (DKModifierGroup*)clubFromAbilities:(DKAbilities5E*)abilities
                     proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
                  weaponProficiencies:(DKSetStatistic*)weaponProficiencies
                           isMainHand:(BOOL)isMainHand {
    
    DKModifierGroup* weapon = [[DKModifierGroup alloc] init];
    weapon.explanation = @"Club";
    
    [weapon addModifier:[DKModifierBuilder modifierWithAddedDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    [weapon addSubgroup:[DKWeaponBuilder5E damageAbilityScoreModifierFromAbilities:abilities
                                                               weaponProficiencies:weaponProficiencies
                                                                          mainHand:isMainHand
                                                                           finesse:NO]];
    [weapon addModifier:[DKModifierBuilder modifierWithExplanation:@"Bludgeoninig damage"]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    
    [weapon addModifier:[abilities.strength modifierFromAbilityScore]
         forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    [weapon addModifier:[DKWeaponBuilder5E proficiencyModifierFromBonus:proficiencyBonus
                                                    weaponProficiencies:weaponProficiencies
                                                       proficiencyTypes:@[@"Simple Weapons", @"Clubs"]]
         forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    
    [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:5]
         forStatisticID:[DKWeaponBuilder5E weaponRangeStatIDForMainHand:isMainHand]];
    return weapon;
}

+ (DKModifierGroup*)daggerFromAbilities:(DKAbilities5E*)abilities
                       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
                    weaponProficiencies:(DKSetStatistic*)weaponProficiencies
                             isMainHand:(BOOL)isMainHand {
    
    DKModifierGroup* weapon = [[DKModifierGroup alloc] init];
    weapon.explanation = @"Dagger";
    
    [weapon addModifier:[DKModifierBuilder modifierWithAddedDice:[DKDiceCollection diceCollectionWithQuantity:1 sides:4 modifier:0]]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    [weapon addSubgroup:[DKWeaponBuilder5E damageAbilityScoreModifierFromAbilities:abilities
                                                               weaponProficiencies:weaponProficiencies
                                                                          mainHand:isMainHand
                                                                           finesse:YES]];
    [weapon addModifier:[DKModifierBuilder modifierWithExplanation:@"Piercing damage"]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:isMainHand]];
    
    [weapon addModifier:[DKWeaponBuilder5E finesseAttackBonusModifierFromAbilities:abilities]
         forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    [weapon addModifier:[DKWeaponBuilder5E proficiencyModifierFromBonus:proficiencyBonus
                                                    weaponProficiencies:weaponProficiencies
                                                       proficiencyTypes:@[@"Simple Weapons", @"Clubs"]]
         forStatisticID:[DKWeaponBuilder5E weaponAttackBonusStatIDForMainHand:isMainHand]];
    
    [weapon addModifier:[DKModifierBuilder modifierWithAdditiveBonus:20 explanation:@"Throwing dagger normal range limit"]
         forStatisticID:[DKWeaponBuilder5E weaponRangeStatIDForMainHand:isMainHand]];
    [weapon addModifier:[DKModifierBuilder modifierWithExplanation:@"Roll at disadvantage to throw at targets between 20 and 60 feet away"]
         forStatisticID:[DKWeaponBuilder5E weaponRangeStatIDForMainHand:isMainHand]];
    return weapon;
}

@end

@implementation DKArmorBuilder5E

@end