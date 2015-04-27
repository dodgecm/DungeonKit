//
//  DKCleric5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/27/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKClass5E.h"
#import "DKStatistic.h"

@class DKAbilities5E;

@compatibility_alias DKCleric5E DKClass5E;

@interface DKCleric5EBuilder : NSObject

+ (DKCleric5E*)clericWithLevel:(DKStatistic*)level Abilities:(DKAbilities5E*)abilities;

@end
