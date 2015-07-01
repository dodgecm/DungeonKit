//
//  DKStatisticGroup5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 7/1/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatisticGroup.h"

@interface DKStatisticGroup5E : DKStatisticGroup

- (NSDictionary*) statisticKeyPaths;
- (NSDictionary*) statisticGroupKeyPaths;
- (NSDictionary*) modifierGroupKeyPaths;

- (void)loadStatistics;
- (void)loadStatisticGroups;
- (void)loadModifiers;

@end
