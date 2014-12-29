//
//  DKStatistic.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"

@interface DKStatistic : NSObject <DKModifierOwner>

/** The value of the statistic without any modifiers. */
@property (nonatomic, assign) int base;
/** The value of the statistic after modifiers have been applied. */
@property (nonatomic, readonly) int score;
/** An array of modifiers that are currently applied to this statistic. */
@property (nonatomic, strong, readonly) NSArray* modifiers;

+ (id)statisticWithBase:(int)base;
- (id)initWithBase:(int)base;

- (void)applyModifier:(DKModifier*)modifier;

- (void)recalculateScore;

@end