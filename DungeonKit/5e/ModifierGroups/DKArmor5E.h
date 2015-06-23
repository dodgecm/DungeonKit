//
//  DKArmor5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 6/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifierGroup.h"
#import "DKStatistic.h"

@class DKCharacter5E;
@class DKAbilities5E;

typedef NS_ENUM(NSInteger, DKArmorType5E) {
    
    //Light Armor
    DKArmorType5E_Padded,
    DKArmorType5E_Leather,
    DKArmorType5E_StuddedLeather,
    
    //Medium Armor
    DKArmorType5E_Hide,
    DKArmorType5E_ChainShirt,
    DKArmorType5E_ScaleMail,
    DKArmorType5E_Breastplate,
    DKArmorType5E_HalfPlate,
    
    //Heavy Armor
    DKArmorType5E_RingMail,
    DKArmorType5E_ChainMail,
    DKArmorType5E_Splint,
    DKArmorType5E_Plate,
};

@compatibility_alias DKArmor5E DKModifierGroup;

@interface DKArmorBuilder5E : NSObject

+ (DKArmor5E*)armorOfType:(DKArmorType5E)type
             forCharacter:(DKCharacter5E*)character;

+ (DKArmor5E*)armorOfType:(DKArmorType5E)type
                abilities:(DKAbilities5E*)abilities
       armorProficiencies:(DKSetStatistic*)armorProficiencies;

@end
