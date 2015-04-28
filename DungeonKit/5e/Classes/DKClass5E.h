//
//  DKClass5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKModifierGroup.h"

@interface DKClass5E : NSObject

@property (nonatomic, strong) DKStatistic* classLevel;
@property (nonatomic, strong) DKModifierGroup* classModifiers;

@end