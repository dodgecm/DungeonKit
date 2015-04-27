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
        
        self.cantrips = [DKStatistic statisticWithBase:0];
        self.firstLevelSpells = [DKStatistic statisticWithBase:0];
        self.secondLevelSpells = [DKStatistic statisticWithBase:0];
        self.thirdLevelSpells = [DKStatistic statisticWithBase:0];
        self.fourthLevelSpells = [DKStatistic statisticWithBase:0];
        self.fifthLevelSpells = [DKStatistic statisticWithBase:0];
        self.sixthLevelSpells = [DKStatistic statisticWithBase:0];
        self.seventhLevelSpells = [DKStatistic statisticWithBase:0];
        self.eighthLevelSpells = [DKStatistic statisticWithBase:0];
        self.ninthLevelSpells = [DKStatistic statisticWithBase:0];
    }
    
    return self;
}

@end
