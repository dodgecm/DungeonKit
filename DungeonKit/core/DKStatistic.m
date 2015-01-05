//
//  DKStatistic.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKStatistic.h"

@interface DKStatistic()
@property (nonatomic, readwrite) int value;
@end

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
    
    if ([modifier isKindOfClass:[DKDependentModifier class]]) {
        //If this is a dependent modifier, we need to do some special checks to make sure we don't have a modifier infinite cycle going on.
        DKDependentModifier* dependentModifier = (DKDependentModifier*) modifier;
        if (dependentModifier.source == self) {
            NSLog(@"DungeonKit: WARNING!  Attempted to apply dependent modifier %@ directly to that modifier's source statistic %@", modifier, self);
            return;
        }
    }
    
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
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
    [_modifiers sortUsingDescriptors:@[sortDescriptor]];
    
    int newScore = _base;
    //Apply modifiers
    for (DKModifier* modifier in _modifiers) {
        newScore = [modifier modifyStatistic:newScore];
    }
    
    self.value = newScore;
}

@end
