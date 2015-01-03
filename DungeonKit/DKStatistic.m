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
@synthesize value = _value;
@synthesize modifiers = _modifiers;

+ (id)statisticWithBase:(int)base {
    DKStatistic* newStat = [[[self class] alloc] initWithBase:base];
    return newStat;
}

-(void)dealloc {
    for (DKModifier* modifier in _modifiers) {
        [modifier removeObserver:self forKeyPath:@"value"];
    }
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
    [self recalculateValue];
}

- (void)applyModifier:(DKModifier*)modifier {
    
    if (!modifier) { return; }
    
    [_modifiers addObject:modifier];
    [modifier wasAppliedToStatistic:self];
    [modifier addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    [self recalculateValue];
}

- (void)removeModifier:(DKModifier*)modifier {
    
    //Need to verify that modifier is applied before removing it due to KVO exception
    if (![_modifiers containsObject:modifier]) { return; }
    
    [modifier removeObserver:self forKeyPath:@"value"];
    [_modifiers removeObject:modifier];
    [self recalculateValue];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //The value of one of our modifiers has changed, so we need to recalculate the score
    [self recalculateValue];
}

- (void)recalculateValue {
    
    //Sort modifiers
    
    int newScore = _base;
    //Apply modifiers
    for (DKModifier* modifier in _modifiers) {
        newScore = [modifier modifyStatistic:newScore];
    }
    
    _value = newScore;
}

@end
