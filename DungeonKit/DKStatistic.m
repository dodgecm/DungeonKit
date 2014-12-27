//
//  DKStatistic.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKStatistic.h"

@implementation DKStatistic

@synthesize base = _base;
@synthesize score = _score;
@synthesize modifiers = _modifiers;

+ (id)statisticWithBase:(int)base {
    DKStatistic* newStat = [[[self class] alloc] initWithBase:base];
    return newStat;
}

- (id)initWithBase:(int)base {
    self = [super init];
    if (self) {
        self.base = base;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DKStatistic* newStatistic = [[self class] allocWithZone:zone];
    newStatistic.base = self.base;
    return newStatistic;
}

- (void)setBase:(int)base {
    _base = base;
    [self recalculateScore];
}

- (void)recalculateScore {
    _score = _base;
}

@end
