//
//  DKCleric5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/27/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKModifierGroup.h"
#import "DKClass5E.h"

@class DKAbilities5E;

@interface DKCleric5E : DKClass5E

@property (nonatomic, strong) DKStatistic* channelDivinityUsesCurrent;
@property (nonatomic, strong) DKStatistic* channelDivinityUsesMax;
@property (nonatomic, strong) DKStatistic* turnUndead;
@property (nonatomic, strong) DKStatistic* divineIntervention;
@property (nonatomic, strong) DKModifierGroup* divineDomain;

- (id)initWithAbilities:(DKAbilities5E*)abilities;

@end
