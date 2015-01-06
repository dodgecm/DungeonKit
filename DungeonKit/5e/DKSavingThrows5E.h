//
//  DKSavingThrows5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/6/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKAbilities5E.h"

@interface DKSavingThrows5E : NSObject

@property (nonatomic, strong) DKStatistic* strength;
@property (nonatomic, strong) DKStatistic* dexterity;
@property (nonatomic, strong) DKStatistic* constitution;
@property (nonatomic, strong) DKStatistic* intelligence;
@property (nonatomic, strong) DKStatistic* wisdom;
@property (nonatomic, strong) DKStatistic* charisma;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities;

@end
