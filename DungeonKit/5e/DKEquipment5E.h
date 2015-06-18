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
#import "DKWeapon5E.h"

@class DKAbilities5E;

@interface DKEquipment5E : NSObject

@property (nonatomic, strong) DKNumericStatistic* mainHandOccupied;
@property (nonatomic, strong) DKNumericStatistic* offHandOccupied;

@property (nonatomic, strong) DKWeapon5E* mainHandWeapon;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponAttackBonus;
@property (nonatomic, strong) DKDiceStatistic* mainHandWeaponDamage;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponRange;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponAttacksPerAction;

@property (nonatomic, strong) DKWeapon5E* offHandWeapon;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponAttackBonus;
@property (nonatomic, strong) DKDiceStatistic* offHandWeaponDamage;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponRange;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponAttacksPerAction;

@property (nonatomic, strong) DKModifierGroup* armor;
@property (nonatomic, strong) DKModifierGroup* shield;
@property (nonatomic, strong) DKModifierGroup* otherEquipment;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
          characterSize:(DKStringStatistic*)characterSize
    weaponProficiencies:(DKSetStatistic*)weaponProficiencies;

@end

#pragma mark -

@interface DKArmorBuilder5E : NSObject

@end

//to hit
//proficiency bonus
//primary attribute

//damage
//primary attribute