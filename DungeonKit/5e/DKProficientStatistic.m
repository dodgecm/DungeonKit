//
//  DKProficientStatistic.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/16/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKProficientStatistic.h"
#import "DKCharacter5E.h"
#import "DKModifierBuilder.h"

@implementation DKProficientStatistic

@synthesize proficiencyLevel = _proficiencyLevel;

+ (id)statisticWithBase:(int)base proficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    DKProficientStatistic* newStat = [[[self class] alloc] initWithBase:base proficiencyBonus:proficiencyBonus];
    return newStat;
}

- (id)initWithBase:(int)base proficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    self = [super initWithBase:base];
    if (self) {
        _proficiencyLevel = [DKNumericStatistic statisticWithBase:0];
        DKDependentModifier* proficiencyModifier = [[DKDependentModifier alloc] initWithDependencies: @{ @"bonus": proficiencyBonus,
                                                                                                         @"level": _proficiencyLevel }
                                                                                               value:[NSExpression expressionWithFormat:@"$bonus*$level"]
                                                                                             enabled:nil
                                                                                            priority:kDKModifierPriority_Additive
                                                                                          expression:[DKModifierBuilder simpleAdditionModifierExpression]];
        [self applyModifier:proficiencyModifier];
    }
    return self;
}

@end
