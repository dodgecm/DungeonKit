//
//  DKSpellbook5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKSpellbook5E.h"

@implementation DKSpellbook5E

@synthesize cantrips = _cantrips;
@synthesize firstLevelSpells = _firstLevelSpells;
@synthesize secondLevelSpells = _secondLevelSpells;
@synthesize thirdLevelSpells = _thirdLevelSpells;
@synthesize fourthLevelSpells = _fourthLevelSpells;
@synthesize fifthLevelSpells = _fifthLevelSpells;
@synthesize sixthLevelSpells = _sixthLevelSpells;
@synthesize seventhLevelSpells = _seventhLevelSpells;
@synthesize eighthLevelSpells = _eighthLevelSpells;
@synthesize ninthLevelSpells = _ninthLevelSpells;

- (id)init {
    
    self = [super init];
    if (self) {
        
        self.cantrips = [DKNumericStatistic statisticWithBase:0];
        self.firstLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.secondLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.thirdLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.fourthLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.fifthLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.sixthLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.seventhLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.eighthLevelSpells = [DKNumericStatistic statisticWithBase:0];
        self.ninthLevelSpells = [DKNumericStatistic statisticWithBase:0];
    }
    
    return self;
}

@end
