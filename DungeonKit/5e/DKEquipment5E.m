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

@synthesize mainHandOccupied = _mainHandOccupied;
@synthesize offHandOccupied = _offHandOccupied;

@synthesize mainHandWeapon = _mainHandWeapon;
@synthesize mainHandWeaponAttackBonus = _mainHandWeaponAttackBonus;
@synthesize mainHandWeaponDamage = _mainHandWeaponDamage;
@synthesize mainHandWeaponRange = _mainHandWeaponRange;
@synthesize mainHandWeaponAttacksPerAction = _mainHandWeaponAttacksPerAction;

@synthesize offHandWeapon = _offHandWeapon;
@synthesize offHandWeaponAttackBonus = _offHandWeaponAttackBonus;
@synthesize offHandWeaponDamage = _offHandWeaponDamage;
@synthesize offHandWeaponRange = _offHandWeaponRange;
@synthesize offHandWeaponAttacksPerAction = _offHandWeaponAttacksPerAction;

@synthesize armor = _armor;
@synthesize shield = _shield;
@synthesize otherEquipment = _otherEquipment;

- (id)initWithAbilities:(DKAbilities5E*)abilities
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
          characterSize:(DKStringStatistic*)characterSize
    weaponProficiencies:(DKSetStatistic*)weaponProficiencies
     armorProficiencies:(DKSetStatistic*)armorProficiencies {
    
    self = [super init];
    if (self) {
        
        self.mainHandOccupied = [DKNumericStatistic statisticWithInt:0];
        self.offHandOccupied = [DKNumericStatistic statisticWithInt:0];
        
        self.mainHandWeaponAttackBonus = [DKNumericStatistic statisticWithInt:0];
        self.mainHandWeaponDamage = [DKDiceStatistic statisticWithNoDice];
        self.mainHandWeaponRange = [DKNumericStatistic statisticWithInt:0];
        self.mainHandWeaponAttacksPerAction = [DKNumericStatistic statisticWithInt:0];
        
        self.offHandWeaponAttackBonus = [DKNumericStatistic statisticWithInt:0];
        self.offHandWeaponDamage = [DKDiceStatistic statisticWithNoDice];
        self.offHandWeaponRange = [DKNumericStatistic statisticWithInt:0];
        self.offHandWeaponAttacksPerAction = [DKNumericStatistic statisticWithInt:0];
        
        self.mainHandWeapon = [DKWeaponBuilder5E weaponOfType:kDKWeaponType5E_Unarmed
                                                    abilities:abilities
                                             proficiencyBonus:proficiencyBonus
                                                characterSize:characterSize
                                          weaponProficiencies:weaponProficiencies
                                              offHandOccupied:_offHandOccupied
                                                   isMainHand:YES];
        
        self.armor = [DKArmorBuilder5E armorOfType:kDKArmorType5E_Unarmored
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
    }
    return self;
}

@end