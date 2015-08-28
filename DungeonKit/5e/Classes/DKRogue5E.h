//
//  DKRogue5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 6/29/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKClass5E.h"

@class DKAbilities5E;
@class DKEquipment5E;

@interface DKRogue5E : DKClass5E

@property (nonatomic, strong) DKNumericStatistic* strokeOfLuckUsesCurrent;
@property (nonatomic, strong) DKNumericStatistic* strokeOfLuckUsesMax;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities
              equipment:(DKEquipment5E*)equipment
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus;

@end
