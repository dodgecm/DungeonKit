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
@synthesize classHitDice = _classHitDice;

#pragma mark -

+ (DKModifierGroup*)abilityScoreImprovementForThreshold:(NSInteger)threshold level:(DKNumericStatistic*)classLevel {
    
    DKModifierGroup* abilityScoreSubgroup = [[DKModifierGroup alloc] init];
    abilityScoreSubgroup.explanation = [NSString stringWithFormat:@"Ability score improvements for level %li", (long)threshold];
    
    DKDependentModifier* strModifier = [[DKDependentModifier alloc] initWithSource:classLevel
                                                                          value:[NSExpression expressionForConstantValue:@(1)]
                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                    isGreaterThanOrEqualTo:threshold]
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    strModifier.explanation = [NSString stringWithFormat:@"Ability score improvement for level %li (default)", (long)threshold];
    [abilityScoreSubgroup addModifier:strModifier forStatisticID:DKStatIDStrength];
    
    DKDependentModifier* dexModifier = [[DKDependentModifier alloc] initWithSource:classLevel
                                                                             value:[NSExpression expressionForConstantValue:@(1)]
                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                    isGreaterThanOrEqualTo:threshold]
                                                                          priority:kDKModifierPriority_Additive
                                                                        expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    dexModifier.explanation = [NSString stringWithFormat:@"Ability score improvement for level %li (default)", (long)threshold];
    [abilityScoreSubgroup addModifier:dexModifier forStatisticID:DKStatIDDexterity];
    
    return abilityScoreSubgroup;
}

+ (DKModifier*)hitDiceModifierForSides:(NSInteger)sides level:(DKNumericStatistic*)classLevel {
    
    NSExpression* value = [NSExpression expressionForFunction:[NSExpression expressionForConstantValue: [DKDiceCollection diceCollection]]
                                                 selectorName:@"diceByAddingQuantity:sides:"
                                                    arguments:@[ [NSExpression expressionForVariable:@"source"],
                                                                 [NSExpression expressionForConstantValue:@(sides)] ] ];
    
    return [DKDependentModifierBuilder addedDiceModifierFromSource:classLevel
                                                             value:value
                                                           enabled:nil
                                                       explanation:@"Class hit die"];
}

#pragma mark -

- (id)init {
    
    self = [super init];
    if (self) {
        self.classLevel = [DKNumericStatistic statisticWithInt:0];
        self.classTraits = [DKSetStatistic statisticWithEmptySet];
        self.classHitDice = [DKDiceStatistic statisticWithNoDice];
    }
    
    return self;
}

@end