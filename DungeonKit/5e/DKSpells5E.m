//
//  DKSpells5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKSpells5E.h"
#import "DKModifierBuilder.h"

@implementation DKSpells5E

@synthesize spellbook = _spellbook;

@synthesize spellSaveDC = _spellSaveDC;
@synthesize spellAttackBonus = _spellAttackBonus;
@synthesize preparedSpells = _preparedSpells;
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

- (id)initWithProficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    self = [super init];
    if (self) {
        
        if (!proficiencyBonus) {
            NSLog(@"DKSkills5E: Expected non-nil proficiency bonus: %@", proficiencyBonus);
            return nil;
        }
        
        self.spellbook = [[DKSpellbook5E alloc] init];
        
        self.spellSaveDC = [DKNumericStatistic statisticWithBase:8];
        self.spellAttackBonus = [DKNumericStatistic statisticWithBase:0];
        [self.spellSaveDC applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:proficiencyBonus]];
        [self.spellAttackBonus applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:proficiencyBonus]];
        self.preparedSpells = [DKNumericStatistic statisticWithBase:0];
        self.preparedSpellsMax = [DKNumericStatistic statisticWithBase:0];
        
        self.firstLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.secondLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.thirdLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.fourthLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.fifthLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.sixthLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.seventhLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.eighthLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        self.ninthLevelSpellSlotsCurrent = [DKNumericStatistic statisticWithBase:0];
        
        self.firstLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.secondLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.thirdLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.fourthLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.fifthLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.sixthLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.seventhLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.eighthLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        self.ninthLevelSpellSlotsMax = [DKNumericStatistic statisticWithBase:0];
        
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
