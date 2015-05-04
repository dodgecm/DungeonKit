//
//  DKDice.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"

@interface DKDice : DKNumericStatistic

/** The quantity of dice.  Ex: for 3d6, the quantity would be 3 */
@property (nonatomic, strong, readonly) DKNumericStatistic* quantity;

/** The number of sides on the dice.  Ex: for 3d6, the sides would be 6 */
@property (nonatomic, strong, readonly) DKNumericStatistic* sides;

+ (id)statisticWithInt:(int)base __unavailable;
- (id)initWithInt:(int)base __unavailable;

+ (id)diceWithQuantity:(int)quantity sides:(int)sides;
- (id)initWithQuantity:(int)quantity sides:(int)sides;

/** Rolls the dice.  The result will be stored as the new base for this statistic. */
- (int)roll;

@end
