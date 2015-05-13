//
//  DKEquipment5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 5/5/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKModifierGroup.h"

@class DKAbilities5E;

@interface DKEquipment5E : NSObject

@property (nonatomic, strong) DKModifierGroup* mainHandWeapon;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponAttackBonus;
@property (nonatomic, strong) DKDiceStatistic* mainHandWeaponDamage;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponRange;

@property (nonatomic, strong) DKModifierGroup* offHandWeapon;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponAttackBonus;
@property (nonatomic, strong) DKDiceStatistic* offHandWeaponDamage;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponRange;

@property (nonatomic, strong) DKModifierGroup* armor;
@property (nonatomic, strong) DKModifierGroup* shield;
@property (nonatomic, strong) DKModifierGroup* otherEquipment;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
    weaponProficiencies:(DKSetStatistic*)weaponProficiencies;

@end

@interface DKWeaponBuilder5E : NSObject

#pragma mark Main Hand Weapons
+ (DKModifierGroup*)unarmedFromAbilities:(DKAbilities5E*)abilities
                        proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
                     weaponProficiencies:(DKSetStatistic*)weaponProficiencies;

#pragma mark Dual Wield Weapons
+ (DKModifierGroup*)clubFromAbilities:(DKAbilities5E*)abilities
                     proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
                  weaponProficiencies:(DKSetStatistic*)weaponProficiencies
                           isMainHand:(BOOL)isMainHand;

@end

@interface DKArmorBuilder5E : NSObject

@end

//to hit
//proficiency bonus
//primary attribute

//damage
//primary attribute