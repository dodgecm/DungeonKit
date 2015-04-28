//
//  DKSpells5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKSpells5E.h"

@implementation DKSpells5E

@synthesize spellbook = _spellbook;

@synthesize spellSaveDC = _spellSaveDC;
@synthesize spellAttackBonus = _spellAttackBonus;
@synthesize preparedSpellsMax = _preparedSpellsMax;

@synthesize firstLevelSpellSlotsCurrent = _firstLevelSpellSlotsCurrent;
@synthesize secondLevelSpellSlotsCurrent = _secondLevelSpellSlotsCurrent;
@synthesize thirdLevelSpellSlotsCurrent = _thirdLevelSpellSlotsCurrent;
@synthesize fourthLevelSpellSlotsCurrent = _fourthLevelSpellSlotsCurrent;
@synthesize fifthLevelSpellSlotsCurrent = _fifthLevelSpellSlotsCurrent;
@synthesize sixthLevelSpellSlotsCurrent = _sixthLevelSpellSlotsCurrent;
@synthesize seventhLevelSpellSlotsCurrent = _seventhLevelSpellSlotsCurrent;
@synthesize eighthLevelSpellSlotsCurrent = _eighthLevelSpellSlotsCurrent;
@synthesize ninthLevelSpellSlotsCurrent = _ninthLevelSpellSlotsCurrent;

@synthesize firstLevelSpellSlotsMax = _firstLevelSpellSlotsMax;
@synthesize secondLevelSpellSlotsMax = _secondLevelSpellSlotsMax;
@synthesize thirdLevelSpellSlotsMax = _thirdLevelSpellSlotsMax;
@synthesize fourthLevelSpellSlotsMax = _fourthLevelSpellSlotsMax;
@synthesize fifthLevelSpellSlotsMax = _fifthLevelSpellSlotsMax;
@synthesize sixthLevelSpellSlotsMax = _sixthLevelSpellSlotsMax;
@synthesize seventhLevelSpellSlotsMax = _seventhLevelSpellSlotsMax;
@synthesize eighthLevelSpellSlotsMax = _eighthLevelSpellSlotsMax;
@synthesize ninthLevelSpellSlotsMax = _ninthLevelSpellSlotsMax;

- (id)initWithProficiencyBonus:(DKStatistic*)proficiencyBonus {
    
    self = [super init];
    if (self) {
        
        if (!proficiencyBonus) {
            NSLog(@"DKSkills5E: Expected non-nil proficiency bonus: %@", proficiencyBonus);
            return nil;
        }
        
        self.spellbook = [[DKSpellbook5E alloc] init];
        
        self.spellSaveDC = [DKStatistic statisticWithBase:8];
        self.spellAttackBonus = [DKStatistic statisticWithBase:0];
        [self.spellSaveDC applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:proficiencyBonus]];
        [self.spellAttackBonus applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:proficiencyBonus]];
        self.preparedSpellsMax = [DKStatistic statisticWithBase:0];
        
        self.firstLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.secondLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.thirdLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.fourthLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.fifthLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.sixthLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.seventhLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.eighthLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        self.ninthLevelSpellSlotsCurrent = [DKStatistic statisticWithBase:0];
        
        self.firstLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.secondLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.thirdLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.fourthLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.fifthLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.sixthLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.seventhLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.eighthLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        self.ninthLevelSpellSlotsMax = [DKStatistic statisticWithBase:0];
        
        [_firstLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_firstLevelSpellSlotsMax]];
        [_secondLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_secondLevelSpellSlotsMax]];
        [_thirdLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_thirdLevelSpellSlotsMax]];
        [_fourthLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_fourthLevelSpellSlotsMax]];
        [_fifthLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_fifthLevelSpellSlotsMax]];
        [_sixthLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_sixthLevelSpellSlotsMax]];
        [_seventhLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_seventhLevelSpellSlotsMax]];
        [_eighthLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_eighthLevelSpellSlotsMax]];
        [_ninthLevelSpellSlotsCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_ninthLevelSpellSlotsMax]];
    }
    
    return self;
}

@end
