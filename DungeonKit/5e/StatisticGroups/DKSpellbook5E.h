//
//  DKSpellbook5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatisticGroup5E.h"
#import "DKStatistic.h"

@interface DKSpellbook5E : DKStatisticGroup5E

@property (nonatomic, strong) DKSetStatistic* cantrips;
@property (nonatomic, strong) DKSetStatistic* firstLevelSpells;
@property (nonatomic, strong) DKSetStatistic* secondLevelSpells;
@property (nonatomic, strong) DKSetStatistic* thirdLevelSpells;
@property (nonatomic, strong) DKSetStatistic* fourthLevelSpells;
@property (nonatomic, strong) DKSetStatistic* fifthLevelSpells;
@property (nonatomic, strong) DKSetStatistic* sixthLevelSpells;
@property (nonatomic, strong) DKSetStatistic* seventhLevelSpells;
@property (nonatomic, strong) DKSetStatistic* eighthLevelSpells;
@property (nonatomic, strong) DKSetStatistic* ninthLevelSpells;

+ (NSString*)statIDForSpellLevel:(NSInteger)spellLevel;

- (DKSetStatistic*)statForSpellLevel:(NSInteger)spellLevel;

@end
