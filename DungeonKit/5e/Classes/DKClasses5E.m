//
//  DKClasses5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/28/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKClasses5E.h"
#import "DKStatisticGroupIDs5E.h"

@implementation DKClasses5E

@synthesize cleric = _cleric;
@synthesize fighter = _fighter;
@synthesize rogue = _rogue;
@synthesize wizard = _wizard;

- (NSDictionary*) statisticGroupKeyPaths {
    return @{
             DKStatisticGroupIDCleric: @"cleric",
             DKStatisticGroupIDFighter: @"fighter",
             DKStatisticGroupIDRogue: @"rogue",
             DKStatisticGroupIDWizard: @"wizard",
             };
}

@end