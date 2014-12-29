//
//  DKStatistic.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKStatistic.h"

@implementation DKStatistic {
    NSMutableArray* _modifiers;
}

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
        _modifiers = [NSMutableArray array];
    }
    return self;
}

- (void)setBase:(int)base {
    _base = base;
    [self recalculateScore];
}

- (void)applyModifier:(DKModifier*)modifier {
    [_modifiers addObject:modifier];
    [modifier wasAppliedToStatistic:self];
    [self recalculateScore];
}

- (void)removeModifier:(DKModifier*)modifier {
    [_modifiers removeObject:modifier];
    [self recalculateScore];
}

- (void)recalculateScore {
    
    //Sort modifiers
    
    int newScore = _base;
    //Apply modifiers
    for (DKModifier* modifier in _modifiers) {
        newScore = [modifier modifyStatistic:newScore];
    }
    
    _score = newScore;
}

@end
