//
//  DKProficientStatistic.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/16/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"

@class DKCharacter5E;

@interface DKProficientStatistic : DKNumericStatistic

/** The proficiency level of this statistic.  A standard proficiency level value is 1.  A value of 2 corresponds with a double proficiency. 
 The character's proficiency bonus will be added to this statistic once for each proficiency level. */
@property (nonatomic, strong, readonly) DKNumericStatistic* proficiencyLevel;

+ (id)statisticWithBase:(int)base __unavailable;
+ (id)statisticWithBase:(int)base proficiencyBonus:(DKNumericStatistic*)proficiencyBonus;
- (id)initWithBase:(int)base __unavailable;
- (id)initWithBase:(int)base proficiencyBonus:(DKNumericStatistic*)proficiencyBonus;

@end
