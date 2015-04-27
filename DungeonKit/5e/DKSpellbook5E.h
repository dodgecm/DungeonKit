//
//  DKSpellbook5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"

@interface DKSpellbook5E : NSObject

@property (nonatomic, strong) DKStatistic* cantrips;
@property (nonatomic, strong) DKStatistic* firstLevelSpells;
@property (nonatomic, strong) DKStatistic* secondLevelSpells;
@property (nonatomic, strong) DKStatistic* thirdLevelSpells;
@property (nonatomic, strong) DKStatistic* fourthLevelSpells;
@property (nonatomic, strong) DKStatistic* fifthLevelSpells;
@property (nonatomic, strong) DKStatistic* sixthLevelSpells;
@property (nonatomic, strong) DKStatistic* seventhLevelSpells;
@property (nonatomic, strong) DKStatistic* eighthLevelSpells;
@property (nonatomic, strong) DKStatistic* ninthLevelSpells;

- (id)init;

@end
