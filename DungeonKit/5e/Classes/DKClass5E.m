//
//  DKClass5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKClass5E.h"
#import "DKStatisticIDs5E.h"
#import "DKModifierBuilder.h"

@implementation DKClass5E

@synthesize classLevel = _classLevel;
@synthesize classTraits = _classTraits;
@synthesize classModifiers = _classModifiers;

#pragma mark -

+ (DKModifierGroup*)abilityScoreImprovementForThreshold:(int)threshold level:(DKNumericStatistic*)classLevel {
    
    DKModifierGroup* abilityScoreSubgroup = [[DKModifierGroup alloc] init];
    abilityScoreSubgroup.explanation = [NSString stringWithFormat:@"Ability score improvements for level %i", threshold];
    
    DKDependentModifier* strModifier = [[DKDependentModifier alloc] initWithSource:classLevel
                                                                          value:[NSExpression expressionForConstantValue:@(1)]
                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                    isGreaterThanOrEqualTo:threshold]
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    strModifier.explanation = [NSString stringWithFormat:@"Ability score improvement for level %i (default)", threshold];
    [abilityScoreSubgroup addModifier:strModifier forStatisticID:DKStatIDStrength];
    
    DKDependentModifier* dexModifier = [[DKDependentModifier alloc] initWithSource:classLevel
                                                                             value:[NSExpression expressionForConstantValue:@(1)]
                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                    isGreaterThanOrEqualTo:threshold]
                                                                          priority:kDKModifierPriority_Additive
                                                                        expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    dexModifier.explanation = [NSString stringWithFormat:@"Ability score improvement for level %i (default)", threshold];
    [abilityScoreSubgroup addModifier:dexModifier forStatisticID:DKStatIDDexterity];
    
    return abilityScoreSubgroup;
}

#pragma mark -

- (id)init {
    
    self = [super init];
    if (self) {
        self.classLevel = [DKNumericStatistic statisticWithBase:0];
        self.classTraits = [DKNumericStatistic statisticWithBase:0];
    }
    
    return self;
}

@end