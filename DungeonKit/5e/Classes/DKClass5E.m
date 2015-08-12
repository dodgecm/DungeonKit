//
//  DKClass5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKClass5E.h"
#import "DKStatisticIDs5E.h"
#import "DKModifierGroupTags5E.h"
#import "DKModifierBuilder.h"
#import "DKChoiceModifierGroup.h"

@implementation DKClass5E

@synthesize classLevel = _classLevel;
@synthesize classTraits = _classTraits;
@synthesize classModifiers = _classModifiers;
@synthesize classHitDice = _classHitDice;

#pragma mark -

+ (DKModifierGroup*)abilityScoreImprovementForThreshold:(NSInteger)threshold level:(DKNumericStatistic*)classLevel {
    
    DKChoiceModifierGroup* firstAbilityScoreChoice = [[DKChoiceModifierGroup alloc] initWithTag:DKChoiceAbilityScoreImprovement];
    firstAbilityScoreChoice.explanation = [NSString stringWithFormat:@"Ability score improvement choice for level %li", (long)threshold];
    
    DKChoiceModifierGroup* secondAbilityScoreChoice = [[DKChoiceModifierGroup alloc] initWithTag:DKChoiceAbilityScoreImprovement];
    secondAbilityScoreChoice.explanation = [NSString stringWithFormat:@"Ability score improvement choice for level %li", (long)threshold];
    
    DKModifierGroup* abilityScoreGroup = [[DKModifierGroup alloc] init];
    abilityScoreGroup.explanation = [NSString stringWithFormat:@"Ability score improvements for level %li", (long)threshold];
    
    [abilityScoreGroup addSubgroup:firstAbilityScoreChoice];
    [abilityScoreGroup addSubgroup:secondAbilityScoreChoice];
    
    return abilityScoreGroup;
}

+ (DKModifierGroup*)skillProficienciesWithStatIDs:(NSArray*)statIDs
                                   choiceGroupTag:(NSString*)tag {
    
    DKChoiceModifierGroup* firstSkillProficiencyChoice = [[DKChoiceModifierGroup alloc] initWithTag:tag];
    firstSkillProficiencyChoice.explanation = @"Class skill proficiency choice";
    DKChoiceModifierGroup* secondSkillProficiencyChoice = [[DKChoiceModifierGroup alloc] initWithTag:tag];
    secondSkillProficiencyChoice.explanation = @"Class skill proficiency choice";
    for (NSString* statID in statIDs) {
        DKModifier* modifier = [DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Class skill proficiency"];
        [firstSkillProficiencyChoice addModifier:modifier forStatisticID:statID];
        [secondSkillProficiencyChoice addModifier:[modifier copy] forStatisticID:statID];
    }
    
    DKModifierGroup* skillProficiencyGroup = [[DKModifierGroup alloc] init];
    [skillProficiencyGroup addSubgroup:firstSkillProficiencyChoice];
    [skillProficiencyGroup addSubgroup:secondSkillProficiencyChoice];
    
    return skillProficiencyGroup;
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

- (void)loadStatistics {
    
    self.classLevel = [DKNumericStatistic statisticWithInt:0];
    self.classTraits = [DKSetStatistic statisticWithEmptySet];
    self.classHitDice = [DKDiceStatistic statisticWithNoDice];
}

@end