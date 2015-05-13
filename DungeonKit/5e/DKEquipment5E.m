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

+ (DKModifierGroup*)offHandDamageAbilityScoreModifierFromAbilities:(DKAbilities5E*)abilities
                                          weaponProficiencies:(DKSetStatistic*)weaponProficiencies {
    DKModifierGroup* offHandDamage = [[DKModifierGroup alloc] init];
    
    NSDictionary* dependencies = @{ @"str" : abilities.strength,
                                    @"proficiencies" : weaponProficiencies };
    [offHandDamage addModifier:[[DKDependentModifier alloc] initWithDependencies:dependencies
                                                                           value:[NSExpression expressionWithFormat:@"floor:( ($str-10)/2.0 )"]
                                                                         enabled:[DKDependentModifierBuilder enabledWhen:@"proficiencies" containsObject:@"Two-Weapon Fighting"]
                                                                        priority:kDKModifierPriority_Additive
                                                                      expression:[DKModifierBuilder simpleAdditionModifierExpression]]
                forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:NO]];
    
    [offHandDamage addModifier:[[DKDependentModifier alloc] initWithDependencies:dependencies
                                                                           value:[NSExpression expressionWithFormat:@"min:( 0, floor:( ($str-10)/2.0 ) )"]
                                                                         enabled:[DKDependentModifierBuilder enabledWhen:@"proficiencies" doesNotContainAnyFromObjects:@[ @"Two-Weapon Fighting"] ]
                                                                        priority:kDKModifierPriority_Additive
                                                                      expression:[DKModifierBuilder simpleAdditionModifierExpression]]
                forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:NO]];
    
    return offHandDamage;
}

+ (DKModifierGroup*)unarmedFromAbilities:(DKAbilities5E*)abilities
                        proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
                     weaponProficiencies:(DKSetStatistic*)weaponProficiencies {
    
    DKModifierGroup* weapon = [[DKModifierGroup alloc] init];
    weapon.explanation = @"Unarmed Strike";
    
    [weapon addModifier:[DKModifierBuilder modifierWithAddedDice:[DKDiceCollection diceCollectionWithQuantity:0 sides:0 modifier:1]]
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:YES]];
    [weapon addModifier:abilities.strength.diceCollectionModifierFromAbilityScore
         forStatisticID:[DKWeaponBuilder5E weaponDamageStatIDForMainHand:YES]];
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

@end

@implementation DKArmorBuilder5E

@end