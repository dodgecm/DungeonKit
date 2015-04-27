//
//  DKSpells5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKSpellbook5E.h"

@interface DKSpells5E : NSObject

@property (nonatomic, strong) DKSpellbook5E* spellbook;

@property (nonatomic, strong) DKStatistic* spellSaveDC;
@property (nonatomic, strong) DKStatistic* spellAttackBonus;

@property (nonatomic, strong) DKStatistic* firstLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* secondLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* thirdLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* fourthLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* fifthLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* sixthLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* seventhLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* eighthLevelSpellSlotsCurrent;
@property (nonatomic, strong) DKStatistic* ninthLevelSpellSlotsCurrent;

@property (nonatomic, strong) DKStatistic* firstLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* secondLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* thirdLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* fourthLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* fifthLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* sixthLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* seventhLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* eighthLevelSpellSlotsMax;
@property (nonatomic, strong) DKStatistic* ninthLevelSpellSlotsMax;

- (id)init __unavailable;
- (id)initWithProficiencyBonus:(DKStatistic*)proficiencyBonus;

@end
