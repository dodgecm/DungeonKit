//
//  DKSpells5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"

@interface DKSpells5E : NSObject

@property (nonatomic, strong) DKStatistic* other;

- (id)init __unavailable;
- (id)initWithProficiencyBonus:(DKStatistic*)proficiencyBonus;

@end
