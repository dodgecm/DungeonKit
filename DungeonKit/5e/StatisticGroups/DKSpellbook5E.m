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
        
        self.cantrips = [DKSetStatistic statisticWithEmptySet];
        self.firstLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.secondLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.thirdLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.fourthLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.fifthLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.sixthLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.seventhLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.eighthLevelSpells = [DKSetStatistic statisticWithEmptySet];
        self.ninthLevelSpells = [DKSetStatistic statisticWithEmptySet];
    }
    
    return self;
}

@end
