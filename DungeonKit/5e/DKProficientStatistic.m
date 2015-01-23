//
//  DKProficientStatistic.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/16/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKProficientStatistic.h"
#import "DKCharacter5E.h"

@implementation DKProficientStatistic

@synthesize proficiencyLevel = _proficiencyLevel;

- (void)dealloc {
    [_proficiencyLevel removeObserver:self forKeyPath:@"value"];
}

+ (id)statisticWithBase:(int)base proficiencyBonus:(DKStatistic*)proficiencyBonus {
    
    DKProficientStatistic* newStat = [[[self class] alloc] initWithBase:base proficiencyBonus:proficiencyBonus];
    return newStat;
}

- (id)initWithBase:(int)base proficiencyBonus:(DKStatistic*)proficiencyBonus {
    
    self = [super initWithBase:base];
    if (self) {
        _proficiencyLevel = [DKStatistic statisticWithBase:0];
        [_proficiencyLevel addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
        __weak DKProficientStatistic* weakSelf = self;
        DKDependentModifier* proficiencyModifier = [[DKDependentModifier alloc] initWithSource:proficiencyBonus
                                                                                         value:[DKDependentModifierBuilder simpleValueBlock]
                                                                                      priority:kDKModifierPriority_Additive
                                                                                         block:^int(int modifierValue, int valueToModify) {
                                                                                             return (weakSelf.proficiencyLevel.value * modifierValue) + valueToModify;
                                                                                         }];
        [self applyModifier:proficiencyModifier];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //If the proficiency level value gets changed, we want to recalculate our value
    [self recalculateValue];
}

@end
