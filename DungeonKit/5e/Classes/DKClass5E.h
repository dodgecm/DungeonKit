//
//  DKClass5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKModifierGroup.h"
#import "DKDiceCollection.h"

@interface DKClass5E : NSObject

@property (nonatomic, strong) DKNumericStatistic* classLevel;
@property (nonatomic, strong) DKSetStatistic* classTraits;
@property (nonatomic, strong) DKModifierGroup* classModifiers;
@property (nonatomic, strong) DKDiceStatistic* classHitDice;

+ (DKModifierGroup*)abilityScoreImprovementForThreshold:(int)threshold level:(DKNumericStatistic*)classLevel;
+ (DKModifier*)hitDiceModifierForSides:(int)sides level:(DKNumericStatistic*)classLevel;

@end