//
//  DKSpellbook5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKSpellbook5E.h"
#import "DKStatisticIDs5E.h"

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

+ (NSString*)statIDForSpellLevel:(NSInteger)spellLevel {
    static dispatch_once_t once;
    static NSDictionary* spellLevelToStatIDs;
    dispatch_once(&once, ^ {
        
        spellLevelToStatIDs = @{ @(1) : DKStatIDFirstLevelSpells,
                                 @(2) : DKStatIDSecondLevelSpells,
                                 @(3) : DKStatIDThirdLevelSpells,
                                 @(4) : DKStatIDFourthLevelSpells,
                                 @(5) : DKStatIDFifthLevelSpells,
                                 @(6) : DKStatIDSixthLevelSpells,
                                 @(7) : DKStatIDSeventhLevelSpells,
                                 @(8) : DKStatIDEighthLevelSpells,
                                 @(9) : DKStatIDNinthLevelSpells,
                                 };
    });
    
    return spellLevelToStatIDs[@(spellLevel)];
}


- (NSDictionary*) statisticKeyPaths {
    return @{
             DKStatIDCantrips: @"cantrips",
             DKStatIDFirstLevelSpells: @"firstLevelSpells",
             DKStatIDSecondLevelSpells: @"secondLevelSpells",
             DKStatIDThirdLevelSpells: @"thirdLevelSpells",
             DKStatIDFourthLevelSpells: @"fourthLevelSpells",
             DKStatIDFifthLevelSpells: @"fifthLevelSpells",
             DKStatIDSixthLevelSpells: @"sixthLevelSpells",
             DKStatIDSeventhLevelSpells: @"seventhLevelSpells",
             DKStatIDEighthLevelSpells: @"eighthLevelSpells",
             DKStatIDNinthLevelSpells: @"ninthLevelSpells",
             };
}

- (void)loadStatistics {
    
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

@end
