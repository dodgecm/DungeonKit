//
//  DKWeaponBuilder5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 6/17/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKModifierGroup.h"

@class DKCharacter5E;
@class DKAbilities5E;

typedef NS_ENUM(NSInteger, DKWeaponType5E) {
    kDKWeaponType5E_Unarmed,
    kDKWeaponType5E_Club,
    kDKWeaponType5E_Dagger,
    kDKWeaponType5E_Greatclub,
    kDKWeaponType5E_Handaxe,
    kDKWeaponType5E_Javelin,
    kDKWeaponType5E_LightHammer,
    kDKWeaponType5E_Mace,
    kDKWeaponType5E_Quarterstaff,
    kDKWeaponType5E_Sickle,
    kDKWeaponType5E_Spear,
};

@interface DKWeaponBuilder5E : NSObject

+ (DKModifierGroup*)weaponOfType:(DKWeaponType5E)type
                    forCharacter:(DKCharacter5E*)character
                      isMainHand:(BOOL)isMainHand;

+ (DKModifierGroup*)weaponOfType:(DKWeaponType5E)type
                       abilities:(DKAbilities5E*)abilities
                proficiencyBonus:(DKNumericStatistic*)proficiencyBonus
             weaponProficiencies:(DKSetStatistic*)weaponProficiencies
                 offHandOccupied:(DKNumericStatistic*)offHandOccupied
                      isMainHand:(BOOL)isMainHand;
@end