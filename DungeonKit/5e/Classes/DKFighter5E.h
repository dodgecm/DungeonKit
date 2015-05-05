//
//  DKFighter5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 5/5/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKClass5E.h"

@class DKAbilities5E;

@interface DKFighter5E : DKClass5E

@property (nonatomic, strong) DKNumericStatistic* secondWindUsesCurrent;
@property (nonatomic, strong) DKNumericStatistic* secondWindUsesMax;
@property (nonatomic, strong) DKNumericStatistic* actionSurgeUsesCurrent;
@property (nonatomic, strong) DKNumericStatistic* actionSurgeUsesMax;
@property (nonatomic, strong) DKNumericStatistic* extraAttacks;
@property (nonatomic, strong) DKNumericStatistic* indomitableUsesCurrent;
@property (nonatomic, strong) DKNumericStatistic* indomitableUsesMax;
@property (nonatomic, strong) DKModifierGroup* martialArchetype;

- (id)initWithAbilities:(DKAbilities5E*)abilities;

@end
