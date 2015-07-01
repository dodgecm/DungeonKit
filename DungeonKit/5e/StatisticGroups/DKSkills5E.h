//
//  DKSkills5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/16/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatisticGroup5E.h"
#import "DKProficientStatistic.h"
#import "DKAbilities5E.h"

@interface DKSkills5E : DKStatisticGroup5E

@property (nonatomic, strong) DKProficientStatistic* acrobatics;
@property (nonatomic, strong) DKProficientStatistic* animalHandling;
@property (nonatomic, strong) DKProficientStatistic* arcana;
@property (nonatomic, strong) DKProficientStatistic* athletics;
@property (nonatomic, strong) DKProficientStatistic* deception;
@property (nonatomic, strong) DKProficientStatistic* history;
@property (nonatomic, strong) DKProficientStatistic* insight;
@property (nonatomic, strong) DKProficientStatistic* intimidation;
@property (nonatomic, strong) DKProficientStatistic* investigation;
@property (nonatomic, strong) DKProficientStatistic* medicine;
@property (nonatomic, strong) DKProficientStatistic* nature;
@property (nonatomic, strong) DKProficientStatistic* perception;
@property (nonatomic, strong) DKProficientStatistic* performance;
@property (nonatomic, strong) DKProficientStatistic* persuasion;
@property (nonatomic, strong) DKProficientStatistic* religion;
@property (nonatomic, strong) DKProficientStatistic* sleightOfHand;
@property (nonatomic, strong) DKProficientStatistic* stealth;
@property (nonatomic, strong) DKProficientStatistic* survival;

@property (nonatomic, strong) DKNumericStatistic* passivePerception;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities proficiencyBonus:(DKNumericStatistic*)proficiencyBonus;

@end
