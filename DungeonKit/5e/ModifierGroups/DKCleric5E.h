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

@class DKAbilities5E;

@interface DKCleric5E : NSObject

@property (nonatomic, strong) DKStatistic* clericLevel;
@property (nonatomic, strong) DKStatistic* channelDivinityUsesCurrent;
@property (nonatomic, strong) DKStatistic* channelDivinityUsesMax;
@property (nonatomic, strong) DKModifierGroup* clericModifiers;
@property (nonatomic, strong) DKModifierGroup* divineDomain;

@end

@interface DKCleric5EBuilder : NSObject

+ (DKModifierGroup*)clericWithLevel:(DKStatistic*)level abilities:(DKAbilities5E*)abilities;

@end
