//
//  DKClass5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatisticGroup5E.h"
#import "DKStatistic.h"
#import "DKModifierGroup.h"
#import "DKDiceCollection.h"

@class DKCharacter5E;

@interface DKClass5E : DKStatisticGroup5E

@property (nonatomic, strong) DKNumericStatistic* classLevel;
@property (nonatomic, strong) DKSetStatistic* classTraits;
@property (nonatomic, strong) DKModifierGroup* classModifiers;
@property (nonatomic, strong) DKDiceStatistic* classHitDice;

+ (DKModifierGroup*)abilityScoreImprovementForThreshold:(NSInteger)threshold level:(DKNumericStatistic*)classLevel;
+ (DKModifierGroup*)skillProficienciesWithStatIDs:(NSArray*)statIDs choiceGroupTag:(NSString*)tag;
+ (DKModifier*)hitDiceModifierForSides:(NSInteger)sides level:(DKNumericStatistic*)classLevel;

- (void)loadClassModifiersForCharacter:(DKCharacter5E*)character;

@end