//
//  DKStatistic.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKStatistic.h"

@interface DKStatistic()
@end

@implementation DKStatistic {
    NSMutableArray* _modifiers;
}

@dynamic base;
@dynamic value;
@synthesize modifiers = _modifiers;

- (void)dealloc {
    for (DKModifier* modifier in _modifiers) {
        [modifier removeObserver:self forKeyPath:@"value"];
        [modifier removeObserver:self forKeyPath:@"enabled"];
    }
}

- (id) init {
    
    self = [super init];
    if (self) {
        _modifiers = [NSMutableArray array];
    }
    return self;
}

- (NSArray*)enabledModifiers {
    return [_modifiers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"enabled == true"]];
}

- (NSArray*)disabledModifiers {
    return [_modifiers filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"enabled == false"]];
}

- (void)applyModifier:(DKModifier*)modifier {
    
    if (!modifier) { return; }
    
    //Removes the modifier from a statistic if it's currently applied to one
    [modifier removeFromStatistic];
    
    [_modifiers addObject:modifier];
    [modifier wasAppliedToStatistic:self];
    [modifier addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    [modifier addObserver:self forKeyPath:@"enabled" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([modifier isKindOfClass:[DKDependentModifier class]]) {
        //If this is a dependent modifier, we need to do some special checks to make sure we don't have a modifier infinite cycle going on.
        DKDependentModifier* dependentModifier = (DKDependentModifier*) modifier;
        if ([dependentModifier.dependencies.allValues containsObject:self] || [self modifierCycleExists]) {
            
            [modifier removeFromStatistic];
            NSLog(@"DKStatistic: WARNING!  Attempted to apply dependent modifier %@ that will create a cycle to that modifier's source statistic %@.  The modifier will not be applied.", modifier, self);
            return;
        }
    }
    
    //Sort modifiers since array has changed
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"priority" ascending:YES];
    [_modifiers sortUsingDescriptors:@[sortDescriptor]];
    
    [self recalculateValue];
}

- (void)removeModifier:(DKModifier*)modifier {
    
    //Need to verify that modifier is applied before removing it due to KVO exception
    if (![_modifiers containsObject:modifier]) { return; }
    
    [modifier removeObserver:self forKeyPath:@"value"];
    [modifier removeObserver:self forKeyPath:@"enabled"];
    [_modifiers removeObject:modifier];
    [self recalculateValue];
}

- (void)willBecomeSourceForModifier:(DKDependentModifier*)modifier {
    
    if ([self modifierCycleExists]) {
        
        NSLog(@"DKStatistic: WARNING!  Attempted to change statistic %@ which will create a modifier cycle.  All modifiers for this statistic will be removed.", self);
        for (DKModifier* modifier in _modifiers) {
            [modifier removeFromStatistic];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
        
    //The value of one of our modifiers has changed, so we need to recalculate the score
    [self recalculateValue];
}

- (void)recalculateValue { }

- (BOOL) modifierCycleExists {
    return !isNodeAcyclic(self, [NSMutableSet set]);
}

BOOL isNodeAcyclic(NSObject<DKModifierOwner>* statistic, NSMutableSet* visitedStats) {
    
    //Basically we're checking for a cycle in a directed graph, where nodes are statistics and modifiers are edges
    NSMutableSet* childStats = [NSMutableSet set];
    for (DKModifier* modifier in [statistic modifiers]) {
        if (![modifier isKindOfClass:[DKDependentModifier class]]) { continue; }
        
        DKDependentModifier* dependentModifier = (DKDependentModifier*) modifier;
        for (NSObject<DKModifierOwner>* statistic in dependentModifier.dependencies.allValues) {
            [childStats addObject:statistic];
        }
    }
    
    if ([visitedStats intersectsSet: childStats]) { return NO; }
    for (NSObject<DKModifierOwner>* childStat in childStats) {

        [visitedStats addObject:childStat];
        BOOL isChildAcyclic = isNodeAcyclic(childStat, visitedStats);
        [visitedStats removeObject:childStat];
        if (isChildAcyclic == NO) { return NO; }
    }
    
    return YES;
}

@end


@interface DKNumericStatistic()
@property (nonatomic, readwrite) NSNumber* value;
@end

@implementation DKNumericStatistic

@synthesize base = _base;
@synthesize value = _value;

+ (id)statisticWithBase:(int)base {
    DKNumericStatistic* newStat = [[[self class] alloc] initWithBase:base];
    return newStat;
}

- (id)initWithBase:(int)base {
    
    self = [super init];
    if (self) {
        self.base = @(base);
    }
    return self;
}

- (void)setBase:(NSNumber*)base {
    _base = base;
    [self recalculateValue];
}

- (void)recalculateValue {
    
    NSNumber* newScore = _base;
    //Apply modifiers
    for (DKModifier* modifier in self.modifiers) {
        newScore = [modifier modifyStatistic:newScore];
    }
    
    self.value = newScore;
}

- (int)intValue {
    return _value.intValue;
}

@end
