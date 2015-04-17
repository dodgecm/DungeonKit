//
//  DKSavingThrows5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/6/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKProficientStatistic.h"
#import "DKAbilities5E.h"

@interface DKSavingThrows5E : NSObject

@property (nonatomic, strong) DKProficientStatistic* strength;
@property (nonatomic, strong) DKProficientStatistic* dexterity;
@property (nonatomic, strong) DKProficientStatistic* constitution;
@property (nonatomic, strong) DKProficientStatistic* intelligence;
@property (nonatomic, strong) DKProficientStatistic* wisdom;
@property (nonatomic, strong) DKProficientStatistic* charisma;
/** Covers bonuses to saving throws for misc. effects, such as blindness, charm, petrification, etc */
@property (nonatomic, strong) DKStatistic* other;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities proficiencyBonus:(DKStatistic*)proficiencyBonus;

@end
