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

@property (nonatomic, strong) DKNumericStatistic* cantrips;
@property (nonatomic, strong) DKNumericStatistic* firstLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* secondLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* thirdLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* fourthLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* fifthLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* sixthLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* seventhLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* eighthLevelSpells;
@property (nonatomic, strong) DKNumericStatistic* ninthLevelSpells;

- (id)init;

@end
