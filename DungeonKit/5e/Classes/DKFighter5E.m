//
//  DKFighter5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 5/5/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKFighter5E.h"
#import "DKAbilities5E.h"
#import "DKModifierBuilder.h"
#import "DKStatisticIDs5E.h"
#import "DKWeapon5E.h"
#import "DKArmor5E.h"

@implementation DKFighter5E

@synthesize secondWindUsesCurrent = _secondWindUsesCurrent;
@synthesize secondWindUsesMax = _secondWindUsesMax;
@synthesize actionSurgeUsesCurrent = _actionSurgeUsesCurrent;
@synthesize actionSurgeUsesMax = _actionSurgeUsesMax;
@synthesize extraAttacks = _extraAttacks;
@synthesize indomitableUsesCurrent = _indomitableUsesCurrent;
@synthesize indomitableUsesMax = _indomitableUsesMax;
@synthesize martialArchetype = _martialArchetype;

#pragma mark -

+ (DKModifierGroup*)fighterWithLevel:(DKNumericStatistic*)level abilities:(DKAbilities5E*)abilities {
    
    DKModifierGroup* class = [[DKModifierGroup alloc] init];
    class.explanation = @"Fighter class modifiers";
    
    [class addModifier:[DKClass5E hitDiceModifierForSides:10 level:level] forStatisticID:DKStatIDFighterHitDice];
    
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Fighter Saving Throw Proficiency: Strength"]
        forStatisticID:DKStatIDSavingThrowStrengthProficiency];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Fighter Saving Throw Proficiency: Constitution"]
        forStatisticID:DKStatIDSavingThrowConstitutionProficiency];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeaponCategory:kDKWeaponCategory5E_Simple]
                                                         explanation:@"Fighter Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeaponCategory:kDKWeaponCategory5E_Martial]
                                                         explanation:@"Fighter Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Light]
                                                         explanation:@"Fighter Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Medium]
                                                         explanation:@"Fighter Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Heavy]
                                                         explanation:@"Fighter Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Shield]
                                                         explanation:@"Fighter Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    
    DKModifierGroup* skillSubgroup = [[DKModifierGroup alloc] init];
    skillSubgroup.explanation = @"Fighter Skill Proficiencies: Choose two from Acrobatics, Animal Handling, Athletics, History, Insight, Intimidation, Perception, and Survival";
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Fighter Skill Proficiency: Athletics (default)"]
                forStatisticID:DKStatIDSkillAthleticsProficiency];
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Fighter Skill Proficiency: Survival (default)"]
                forStatisticID:DKStatIDSkillSurvivalProficiency];
    [class addSubgroup:skillSubgroup];
    
    DKModifierGroup* secondWindGroup = [DKFighter5E secondWindGroupWithFighterLevel:level];
    [class addSubgroup:secondWindGroup];
    
    DKModifierGroup* actionSurgeGroup = [DKFighter5E actionSurgeGroupWithFighterLevel:level];
    [class addSubgroup:actionSurgeGroup];
    
    NSExpression* extraAttacksValue = [DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                             @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:4] : @(0),
                                                [DKDependentModifierBuilder rangeValueWithMin:5 max:10] : @(1),
                                                [DKDependentModifierBuilder rangeValueWithMin:11 max:19] : @(2),
                                                [DKDependentModifierBuilder rangeValueWithMin:20 max:20] : @(3) }
                                                                                         usingDependency:@"source"];
    DKDependentModifier* extraAttacksModifier = [[DKDependentModifier alloc] initWithSource:level
                                                                                            value:extraAttacksValue
                                                                                          enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                   isGreaterThanOrEqualTo:5]
                                                                                         priority:kDKModifierPriority_Additive
                                                                                       expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [class addModifier:extraAttacksModifier forStatisticID:DKStatIDExtraAttacks];
    
    DKModifierGroup* indomitableGroup = [DKFighter5E indomitableGroupWithFighterLevel:level];
    [class addSubgroup:indomitableGroup];
    
    DKModifierGroup* fourthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:4 level:level];
    [class addSubgroup:fourthLevelAbilityScore];
    DKModifierGroup* sixthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:6 level:level];
    [class addSubgroup:sixthLevelAbilityScore];
    DKModifierGroup* eighthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:8 level:level];
    [class addSubgroup:eighthLevelAbilityScore];
    DKModifierGroup* twelfthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:12 level:level];
    [class addSubgroup:twelfthLevelAbilityScore];
    DKModifierGroup* fourteenthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:14 level:level];
    [class addSubgroup:fourteenthLevelAbilityScore];
    DKModifierGroup* sixteenthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:16 level:level];
    [class addSubgroup:sixteenthLevelAbilityScore];
    DKModifierGroup* nineteenthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:19 level:level];
    [class addSubgroup:nineteenthLevelAbilityScore];
    
    return class;
}

+ (DKModifierGroup*)secondWindGroupWithFighterLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* secondWindGroup = [[DKModifierGroup alloc] init];
    DKModifier* secondWindExplanationModifier = [DKModifierBuilder modifierWithExplanation:@"You have a limited well of stamina that you can draw on to protect yourself from harm. On your turn, you can use a bonus action to regain hit points equal to 1d10 + your fighter level."];
    [secondWindGroup addModifier:secondWindExplanationModifier forStatisticID:DKStatIDSecondWindUsesMax];
    
    DKModifier* secondWindChargesModifier = [DKModifierBuilder modifierWithAdditiveBonus:1
                                                                            explanation:@"Once you use this feature, you must finish a short or long rest before you can use it again."];
    [secondWindGroup addModifier:secondWindChargesModifier forStatisticID:DKStatIDSecondWindUsesMax];

    return secondWindGroup;
}

+ (DKModifierGroup*)actionSurgeGroupWithFighterLevel:(DKNumericStatistic*)level {

    DKModifierGroup* actionSurgeGroup = [[DKModifierGroup alloc] init];
    
    DKModifier* actionSurgeExplanationModifier = [DKModifierBuilder modifierWithExplanation:@"You can push yourself beyond your normal limits for a moment. On your turn, you can take one additional action on top of your regular action and a possible bonus action.  This feature may only be used only once per turn."];
    [actionSurgeGroup addModifier:actionSurgeExplanationModifier forStatisticID:DKStatIDActionSurgeUsesMax];
    
    NSExpression* actionSurgeChargesValue = [DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                             @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:1] : @(0),
                                                [DKDependentModifierBuilder rangeValueWithMin:2 max:16] : @(1),
                                                [DKDependentModifierBuilder rangeValueWithMin:17 max:20] : @(2) }
                                                                                          usingDependency:@"source"];
    DKDependentModifier* actionSurgeChargesModifier = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:actionSurgeChargesValue
                                                                                    enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                             isGreaterThanOrEqualTo:2]
                                                                                   priority:kDKModifierPriority_Additive
                                                                                 expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    actionSurgeChargesModifier.explanation = @"You must finish a short or long rest before you regain your uses of this feature.";
    [actionSurgeGroup addModifier:actionSurgeChargesModifier forStatisticID:DKStatIDActionSurgeUsesMax];
    
    return actionSurgeGroup;
}

+ (DKModifierGroup*)indomitableGroupWithFighterLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* indomitableGroup = [[DKModifierGroup alloc] init];
    
    DKModifier* indomitableExplanationModifier = [DKModifierBuilder modifierWithExplanation:@"You can reroll a saving throw that you fail. "
                                                  "If you do so, you must use the new roll."];
    [indomitableGroup addModifier:indomitableExplanationModifier forStatisticID:DKStatIDIndomitableUsesMax];
    
    NSExpression* indomitableChargesValue = [DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                             @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:8] : @(0),
                                                [DKDependentModifierBuilder rangeValueWithMin:9 max:12] : @(1),
                                                [DKDependentModifierBuilder rangeValueWithMin:13 max:16] : @(2),
                                                [DKDependentModifierBuilder rangeValueWithMin:17 max:20] : @(3) }
                                                                                         usingDependency:@"source"];
    DKDependentModifier* indomitableChargesModifier = [[DKDependentModifier alloc] initWithSource:level
                                                                                            value:indomitableChargesValue
                                                                                          enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                   isGreaterThanOrEqualTo:9]
                                                                                         priority:kDKModifierPriority_Additive
                                                                                       expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    indomitableChargesModifier.explanation = @"You must finish a short or long rest before you regain your uses of this feature.";
    [indomitableGroup addModifier:indomitableChargesModifier forStatisticID:DKStatIDIndomitableUsesMax];
    
    return indomitableGroup;
}

#pragma mark -

+ (DKModifierGroup*)championArchetypeWithFighterLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* championGroup = [[DKModifierGroup alloc] init];
    
    NSString* improvedCriticalExplanation = @"Your weapon attacks score a critical hit on a roll of 19 or 20.";
    DKDependentModifier* improvedCriticalAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                            constantValue:@"Improved Critical"
                                                                                                  enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                           isGreaterThanOrEqualTo:2]
                                                                                              explanation:improvedCriticalExplanation];
    [championGroup addModifier:improvedCriticalAbility forStatisticID:DKStatIDFighterTraits];
    
    NSString* remarkableAthleteExplanation = @"You can add half your proficiency bonus (round up) to any Strength, Dexterity, or Constitution check you make that doesn’t already use your proficiency bonus.  In addition, when you make a running long jump, the distance you can cover increases by a number of feet equal to your Strength modifier.";
    DKDependentModifier* remarkableAthleteAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                            constantValue:@"Remarkable Athlete"
                                                                                                  enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                           isGreaterThanOrEqualTo:7]
                                                                                              explanation:remarkableAthleteExplanation];
    [championGroup addModifier:remarkableAthleteAbility forStatisticID:DKStatIDFighterTraits];
    
    return championGroup;
}

#pragma mark -

- (id)initWithAbilities:(DKAbilities5E*)abilities {
    
    self = [super init];
    if (self) {
        
        self.secondWindUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        self.secondWindUsesMax = [DKNumericStatistic statisticWithInt:0];
        self.actionSurgeUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        self.actionSurgeUsesMax = [DKNumericStatistic statisticWithInt:0];
        self.extraAttacks = [DKNumericStatistic statisticWithInt:0];
        self.indomitableUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        self.indomitableUsesMax = [DKNumericStatistic statisticWithInt:0];
        
        [_secondWindUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_secondWindUsesMax]];
        [_actionSurgeUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_actionSurgeUsesMax]];
        [_indomitableUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_indomitableUsesMax]];
        
        self.classModifiers = [DKFighter5E fighterWithLevel:self.classLevel abilities:abilities];
        [self.classModifiers addModifier:[DKDependentModifierBuilder addedDiceModifierFromSource:self.classHitDice
                                                                                     explanation:@"Fighter hit dice"] forStatisticID:DKStatIDHitDiceMax];
        
        /*self.channelDivinityUsesMax = [DKNumericStatistic statisticWithInt:0];
        self.channelDivinityUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        [_channelDivinityUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_channelDivinityUsesMax]];
        
        self.turnUndead = [DKNumericStatistic statisticWithInt:0];
        self.divineIntervention = [DKNumericStatistic statisticWithInt:0];
        
        self.classModifiers = [DKCleric5E clericWithLevel:self.classLevel abilities:abilities];
        self.divineDomain = [DKCleric5E lifeDomainWithLevel:self.classLevel];*/
    }
    return self;
}

@end
