//
//  DKEquipment5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 5/5/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKStatisticGroup5E.h"
#import "DKChoiceModifierGroup.h"
#import "DKWeapon5E.h"
#import "DKArmor5E.h"

@class DKAbilities5E;

@interface DKEquipment5E : DKStatisticGroup5E

@property (nonatomic, strong) DKNumericStatistic* mainHandOccupied;
@property (nonatomic, strong) DKNumericStatistic* offHandOccupied;
@property (nonatomic, strong) DKNumericStatistic* armorSlotOccupied;

@property (nonatomic, strong) DKSubgroupChoiceModifierGroup* mainHandWeapon;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponAttackBonus;
@property (nonatomic, strong) DKDiceStatistic* mainHandWeaponDamage;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponRange;
@property (nonatomic, strong) DKNumericStatistic* mainHandWeaponAttacksPerAction;
@property (nonatomic, strong) DKSetStatistic* mainHandWeaponAttributes;

@property (nonatomic, strong) DKSubgroupChoiceModifierGroup* offHandWeapon;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponAttackBonus;
@property (nonatomic, strong) DKDiceStatistic* offHandWeaponDamage;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponRange;
@property (nonatomic, strong) DKNumericStatistic* offHandWeaponAttacksPerAction;
@property (nonatomic, strong) DKSetStatistic* offHandWeaponAttributes;

/** Non-combat related items */
@property (nonatomic, strong) DKSetStatistic* inventory;

@property (nonatomic, strong) DKSubgroupChoiceModifierGroup* armor;
@property (nonatomic, strong) DKSubgroupChoiceModifierGroup* shield;
@property (nonatomic, strong) DKModifierGroup* otherEquipment;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
          characterSize:(DKStringStatistic*)characterSize
    weaponProficiencies:(DKSetStatistic*)weaponProficiencies
     armorProficiencies:(DKSetStatistic*)armorProficiencies;

- (void)equipWeapon:(DKWeapon5E*)weapon
          inMainHand:(BOOL)isMainHand;
- (void)equipArmor:(DKArmor5E*)armor;
- (void)equipShield:(DKArmor5E*)shield;

@end