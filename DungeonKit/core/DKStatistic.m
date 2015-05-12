//
//  DKStatistic.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKStatistic.h"

@interface DKStatistic()
@property (nonatomic, readwrite) id<NSObject> base;
@property (nonatomic, readwrite) id<NSObject> value;
@end

@implementation DKStatistic {
    NSMutableArray* _modifiers;
}

@synthesize base = _base;
@synthesize value = _value;
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

+ (id)statisticWithBase:(id<NSObject>)base {
    DKStatistic* newStat = [[[self class] alloc] initWithBase:base];
    return newStat;
}
- (id)initWithBase:(id<NSObject>)base {
    
    self = [super init];
    if (self) {
        self.base = base;
        _modifiers = [NSMutableArray array];
    }
    return self;
}

- (void)setBase:(id<NSObject>)base {
    _base = base;
    [self recalculateValue];
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


- (void)recalculateValue {
    
    id<NSObject> newValue = self.base;
    //Apply modifiers
    for (DKModifier* modifier in self.modifiers) {
        newValue = [modifier modifyStatistic:newValue];
    }
    
    self.value = newValue;
}

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

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.base forKey:@"base"];
    [aCoder encodeObject:self.value forKey:@"value"];
    [aCoder encodeObject:self.modifiers forKey:@"modifiers"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _base = [aDecoder decodeObjectForKey:@"base"];
        _value = [aDecoder decodeObjectForKey:@"value"];
        
        _modifiers = [NSMutableArray array];
        NSArray* decodedModifiers = [aDecoder decodeObjectForKey:@"modifiers"];
        for (DKModifier* modifier in decodedModifiers) {
            [self applyModifier:modifier];
        }
    }
    
    return self;
}

@end

#pragma mark -
@interface DKNumericStatistic()
@property (nonatomic, readwrite) NSNumber* value;
@end

@implementation DKNumericStatistic

@dynamic base;
@dynamic value;

+ (id)statisticWithInt:(int)integer {
    DKNumericStatistic* newStat = [[[self class] alloc] initWithInt:integer];
    return newStat;
}

- (id)initWithInt:(int)integer {
    
    self = [super initWithBase:@(integer)];
    return self;
}

- (int)intValue {
    return self.value.intValue;
}

@end

#pragma mark -
@interface DKSetStatistic()
@property (nonatomic, readwrite) NSSet* value;
@end

@implementation DKSetStatistic

@dynamic base;
@dynamic value;


+ (id)statisticWithEmptySet {
    return [[self class] statisticWithSet:[NSSet set]];
}

+ (id)statisticWithSet:(NSSet*)set {
    DKSetStatistic* newStat = [[[self class] alloc] initWithSet:set];
    return newStat;
}

- (id)initWithSet:(NSSet*)set {
    
    self = [super initWithBase:set];
    return self;
}

@end

#pragma mark -
@interface DKDiceStatistic()
@property (nonatomic, readwrite) DKDiceCollection* value;
@end

@implementation DKDiceStatistic

@dynamic base;
@dynamic value;


+ (id)statisticWithNoDice {
    return [[self class] statisticWithDice: [DKDiceCollection diceCollection] ];
}

+ (id)statisticWithDice:(DKDiceCollection *)dice {
    DKDiceStatistic* newStat = [[[self class] alloc] initWithDice:dice];
    return newStat;
}

- (id)initWithDice:(DKDiceCollection *)dice {
    
    self = [super initWithBase:dice];
    return self;
}

- (NSString*)description {
    return self.value.stringValue;
}

@end