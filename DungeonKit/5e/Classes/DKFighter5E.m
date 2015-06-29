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
#import "DKEquipment5E.h"
#import "DKWeapon5E.h"
#import "DKArmor5E.h"
#import "DKSkills5E.h"

@implementation DKFighter5E

@synthesize secondWindUsesCurrent = _secondWindUsesCurrent;
@synthesize secondWindUsesMax = _secondWindUsesMax;
@synthesize actionSurgeUsesCurrent = _actionSurgeUsesCurrent;
@synthesize actionSurgeUsesMax = _actionSurgeUsesMax;
@synthesize indomitableUsesCurrent = _indomitableUsesCurrent;
@synthesize indomitableUsesMax = _indomitableUsesMax;
@synthesize martialArchetype = _martialArchetype;

#pragma mark -

+ (DKModifierGroup*)fighterWithLevel:(DKNumericStatistic*)level
                           abilities:(DKAbilities5E*)abilities
                           equipment:(DKEquipment5E*)equipment {
    
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
    
    DKModifierGroup* fightingStyle = [DKFighter5E fightingStyle:kDKFightingStyle5E_Archery
                                                   fighterLevel:level
                                                       minLevel:@1
                                                      equipment:equipment];
    fightingStyle.explanation = @"Archery fighting style (default)";
    [class addSubgroup:fightingStyle];
    
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
    DKDependentModifier* offHandAttacksModifier = [extraAttacksModifier copy];
    [class addModifier:extraAttacksModifier forStatisticID:DKStatIDMainHandWeaponAttacksPerAction];
    [class addModifier:offHandAttacksModifier forStatisticID:DKStatIDOffHandWeaponAttacksPerAction];
    
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

+ (DKModifierGroup*)fightingStyle:(DKFightingStyle5E)fightingStyle
                     fighterLevel:(DKNumericStatistic*)fighterLevel
                         minLevel:(NSNumber*)minLevel
                        equipment:(DKEquipment5E*)equipment {
    
    DKModifierGroup* fightingStyleGroup = [[DKModifierGroup alloc] init];
    NSPredicate* levelPredicate = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:minLevel.integerValue];
    switch (fightingStyle) {
        case kDKFightingStyle5E_Archery:
        {
            fightingStyleGroup.explanation = @"Archery fighting style";
            
            NSPredicate* rangedPredicate = [DKDependentModifierBuilder enabledWhen:@"source" containsObject:@"Ranged"];
            NSPredicate* enabledPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[rangedPredicate, levelPredicate]];
            DKDependentModifier* mainHandModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"source" : equipment.mainHandWeaponAttributes,
                                                                                                         @"level" : fighterLevel }
                                                                                          value:[DKDependentModifierBuilder expressionForConstantInteger:2]
                                                                                        enabled:enabledPredicate
                                                                                       priority:kDKModifierPriority_Additive
                                                                                     expression:[DKModifierBuilder simpleAdditionModifierExpression]];
            mainHandModifier.explanation = @"Archery fighting style (fighter) attack bonus";
            [fightingStyleGroup addModifier:mainHandModifier forStatisticID:DKStatIDMainHandWeaponAttackBonus];
            
            DKDependentModifier* offHandModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"source" : equipment.offHandWeaponAttributes,
                                                                                                        @"level" : fighterLevel }
                                                                                         value:[DKDependentModifierBuilder expressionForConstantInteger:2]
                                                                                       enabled:[enabledPredicate copy]
                                                                                      priority:kDKModifierPriority_Additive
                                                                                    expression:[DKModifierBuilder simpleAdditionModifierExpression]];
            offHandModifier.explanation = @"Archery fighting style (fighter) attack bonus";
            [fightingStyleGroup addModifier:offHandModifier forStatisticID:DKStatIDOffHandWeaponAttackBonus];
            break;
        }
            
        case kDKFightingStyle5E_Defense:
        {
            fightingStyleGroup.explanation = @"Defense fighting style";
            NSPredicate* defensePredicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:1];
            NSPredicate* enabledPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[defensePredicate, levelPredicate]];
            DKDependentModifier* armorClassModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"source" : equipment.armorSlotOccupied,
                                                                                                           @"level" : fighterLevel }
                                                                                            value:[DKDependentModifierBuilder expressionForConstantInteger:1]
                                                                                          enabled:enabledPredicate
                                                                                         priority:kDKModifierPriority_Additive
                                                                                       expression:[DKModifierBuilder simpleAdditionModifierExpression]];
            armorClassModifier.explanation = @"Defense fighting style (fighter) armor class bonus";
            [fightingStyleGroup addModifier:armorClassModifier forStatisticID:DKStatIDArmorClass];
            break;
        }
            
        case kDKFightingStyle5E_Dueling: {
            fightingStyleGroup.explanation = @"Dueling fighting style";
            NSExpression* damageBonusExpression = [DKDependentModifierBuilder valueAsDiceCollectionFromExpression:
                                                   [NSExpression expressionForConstantValue:@2]];
            NSPredicate* meleeWeaponPredicate = [DKDependentModifierBuilder enabledWhen:@"mainHand" containsObject:@"Melee"];
            NSPredicate* offHandIsShieldPredicate = [DKDependentModifierBuilder enabledWhen:@"offHand" containsObject:@"Shield"];
            NSPredicate* offHandIsEmptyPredicate = [DKDependentModifierBuilder enabledWhen:@"offHandOccupied" isEqualToOrBetween:0 and:0];
            NSCompoundPredicate* offHandPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[offHandIsEmptyPredicate, offHandIsShieldPredicate]];
            NSCompoundPredicate* enabledPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[meleeWeaponPredicate, offHandPredicate, levelPredicate]];
            DKDependentModifier* damageModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"mainHand": equipment.mainHandWeaponAttributes,
                                                                                                       @"offHand": equipment.offHandWeaponAttributes,
                                                                                                       @"offHandOccupied": equipment.offHandOccupied,
                                                                                                       @"level" : fighterLevel }
                                                                                            value:damageBonusExpression
                                                                                          enabled:enabledPredicate
                                                                                         priority:kDKModifierPriority_Additive
                                                                                       expression:[DKModifierBuilder simpleAdditionModifierExpression]];
            damageModifier.explanation = @"Dueling fighting style (fighter) damage bonus";
            [fightingStyleGroup addModifier:damageModifier forStatisticID:DKStatIDMainHandWeaponDamage];
            break;
        }
            
        case kDKFightingStyle5E_GreatWeapon: {
            fightingStyleGroup.explanation = @"Great Weapon fighting style";
            NSPredicate* twoHandedPredicate = [DKDependentModifierBuilder enabledWhen:@"mainHand" containsObject:@"Two-handed"];
            NSPredicate* versatilePredicate = [DKDependentModifierBuilder enabledWhen:@"mainHand" containsObject:@"Versatile"];
            NSPredicate* offHandIsEmptyPredicate = [DKDependentModifierBuilder enabledWhen:@"offHandOccupied" isEqualToOrBetween:0 and:0];
            NSCompoundPredicate* versatileActivePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[versatilePredicate, offHandIsEmptyPredicate]];
            NSCompoundPredicate* usingTwoHandsPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[twoHandedPredicate, versatileActivePredicate]];
            NSCompoundPredicate* enabledPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[usingTwoHandsPredicate, levelPredicate]];
            DKDependentModifier* damageModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"mainHand": equipment.mainHandWeaponAttributes,
                                                                                                       @"offHandOccupied": equipment.offHandOccupied,
                                                                                                       @"level" : fighterLevel }
                                                                                              value:nil
                                                                                            enabled:enabledPredicate
                                                                                           priority:kDKModifierPriority_Informational
                                                                                         expression:nil];
            damageModifier.explanation = @"Great Weapon Fighting: When you roll a 1 or 2 on a damage die for an attack you make with a melee weapon that you are wielding with two hands, you can reroll the die and must use the new roll, even if the new roll is a 1 or a 2.";
            [fightingStyleGroup addModifier:damageModifier forStatisticID:DKStatIDMainHandWeaponDamage];
            break;
        }
            
        case kDKFightingStyle5E_Protection: {
            fightingStyleGroup.explanation = @"Protection fighting style";
            
            NSString* protectionExplanation = @"When a creature you can see attacks a target other than you that is within 5 feet of you, you can use your reaction to impose disadvantage on the attack roll.";
            NSPredicate* shieldPredicate = [DKDependentModifierBuilder enabledWhen:@"source" containsObject:@"Shield"];
            NSCompoundPredicate* enabledPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[shieldPredicate, levelPredicate]];
            DKDependentModifier* protectionModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"source": equipment.offHandWeaponAttributes,
                                                                                                           @"level" : fighterLevel }
                                                                                                  value:nil
                                                                                                enabled:enabledPredicate
                                                                                               priority:kDKModifierPriority_Informational
                                                                                             expression:nil];
            protectionModifier.explanation = protectionExplanation;
            [fightingStyleGroup addModifier:protectionModifier forStatisticID:DKStatIDFighterTraits];
            break;
        }
            
        case kDKFightingStyle5E_TwoWeapon: {
            fightingStyleGroup.explanation = @"Two-Weapon fighting style";
            DKModifier* twoWeaponModifier = [DKDependentModifierBuilder appendedModifierFromSource:fighterLevel
                                                                                     constantValue:@"Two-Weapon Fighting"
                                                                                           enabled:levelPredicate
                                                                                       explanation:@"Two-Weapon fighting style (fighter) offhand damage bonus"];
            [fightingStyleGroup addModifier:twoWeaponModifier forStatisticID:DKStatIDWeaponProficiencies];
        }
            
        default:
            break;
    }
    
    return fightingStyleGroup;
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

+ (DKModifierGroup*)championArchetypeWithFighterLevel:(DKNumericStatistic*)level
                                               skills:(DKSkills5E*)skills
                                            equipment:(DKEquipment5E*)equipment
                                     proficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    DKModifierGroup* championGroup = [[DKModifierGroup alloc] init];
    championGroup.explanation = @"Champion martial archetype";
    
    NSString* improvedCriticalExplanation = @"Your weapon attacks score a critical hit on a roll of 19 or 20.";
    DKDependentModifier* improvedCriticalAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                            constantValue:@"Improved Critical"
                                                                                                  enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                           isEqualToOrBetween:3 and:14]
                                                                                              explanation:improvedCriticalExplanation];
    [championGroup addModifier:improvedCriticalAbility forStatisticID:DKStatIDFighterTraits];
    
    DKModifierGroup* remarkableAthleteAbility = [DKFighter5E remarkableAthleteWithFighterLevel:level
                                                                                        skills:skills
                                                                              proficiencyBonus:proficiencyBonus];
    [championGroup addSubgroup:remarkableAthleteAbility];
    
    DKModifierGroup* bonusFightingStyle = [DKFighter5E fightingStyle:kDKFightingStyle5E_Defense
                                                        fighterLevel:level
                                                            minLevel:@10
                                                           equipment:equipment];
    bonusFightingStyle.explanation = @"Defense fighting style (default)";
    [championGroup addSubgroup:bonusFightingStyle];
    
    NSString* superiorCriticalExplanation = @"Your weapon attacks score a critical hit on a roll of 18, 19, or 20.";
    DKDependentModifier* superiorCriticalAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                            constantValue:@"Superior Critical"
                                                                                                  enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                           isGreaterThanOrEqualTo:15]
                                                                                              explanation:superiorCriticalExplanation];
    [championGroup addModifier:superiorCriticalAbility forStatisticID:DKStatIDFighterTraits];
    
    NSString* survivorExplanation = @"At the start of each of your turns, you regain hit points equal to 5 + your Constitution modifier if you have no more than half of your hit points left. You don’t gain this benefit if you have 0 hit points.";
    DKDependentModifier* survivorAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                    constantValue:@"Survivor"
                                                                                          enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                   isGreaterThanOrEqualTo:18]
                                                                                      explanation:survivorExplanation];
    [championGroup addModifier:survivorAbility forStatisticID:DKStatIDFighterTraits];
    
    return championGroup;
}

+ (DKModifierGroup*)remarkableAthleteWithFighterLevel:(DKNumericStatistic*)level
                                               skills:(DKSkills5E*)skills
                                     proficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    DKModifierGroup* remarkableAthleteGroup = [[DKModifierGroup alloc] init];
    remarkableAthleteGroup.explanation = @"Remarkable athlete ability";
    
    NSExpression* divExpression = [NSExpression expressionForFunction:@"divide:by:" arguments:@[[NSExpression expressionForVariable:@"proficiencyBonus"],
                                                                                                [NSExpression expressionForConstantValue:@(2.0)]]];
    NSExpression* valueExpression = [NSExpression expressionForFunction:@"ceiling:" arguments:@[ divExpression ]];
    
    NSPredicate* levelRequirement = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:7];
    NSPredicate* proficiencyRequirement = [DKDependentModifierBuilder enabledWhen:@"proficiencyLevel" isEqualToOrBetween:0 and:0];
    NSPredicate* enabled = [NSCompoundPredicate andPredicateWithSubpredicates:@[levelRequirement, proficiencyRequirement]];
    
    NSArray* skillsForBonus = @[ skills.acrobatics, skills.athletics, skills.sleightOfHand, skills.stealth ];
    NSArray* skillStatIDs = @[ DKStatIDSkillAcrobatics, DKStatIDSkillAthletics, DKStatIDSkillSleightOfHand, DKStatIDSkillStealth ];
    for (int i = 0; i < skillsForBonus.count; i++) {
        DKProficientStatistic* skill = skillsForBonus[i];
        NSString* statID = skillStatIDs[i];
        DKDependentModifier* skillBonus = [[DKDependentModifier alloc] initWithDependencies:@{ @"level": level,
                                                                                               @"proficiencyBonus": proficiencyBonus,
                                                                                               @"proficiencyLevel": skill.proficiencyLevel }
                                                                                      value:[valueExpression copy]
                                                                                    enabled:[enabled copy]
                                                                                   priority:kDKModifierPriority_Additive
                                                                                 expression:[DKModifierBuilder simpleAdditionModifierExpression]];
        skillBonus.explanation = @"Remarkable Athlete bonus";
        [remarkableAthleteGroup addModifier:skillBonus forStatisticID:statID];
    }
    
    NSString* remarkableAthleteExplanation = @"When you make a running long jump, the distance you can cover increases by a number of feet equal to your Strength modifier.";
    DKDependentModifier* remarkableAthleteAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                             constantValue:@"Remarkable Athlete"
                                                                                                   enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                            isGreaterThanOrEqualTo:7]
                                                                                               explanation:remarkableAthleteExplanation];
    [remarkableAthleteGroup addModifier:remarkableAthleteAbility forStatisticID:DKStatIDFighterTraits];
    
    return remarkableAthleteGroup;
}

#pragma mark -

- (id)initWithAbilities:(DKAbilities5E*)abilities
                 skills:(DKSkills5E*)skills
              equipment:(DKEquipment5E*)equipment
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    self = [super init];
    if (self) {
        
        self.secondWindUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        self.secondWindUsesMax = [DKNumericStatistic statisticWithInt:0];
        self.actionSurgeUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        self.actionSurgeUsesMax = [DKNumericStatistic statisticWithInt:0];
        self.indomitableUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        self.indomitableUsesMax = [DKNumericStatistic statisticWithInt:0];
        
        [_secondWindUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_secondWindUsesMax]];
        [_actionSurgeUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_actionSurgeUsesMax]];
        [_indomitableUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_indomitableUsesMax]];
        
        self.classModifiers = [DKFighter5E fighterWithLevel:self.classLevel
                                                  abilities:abilities
                                                  equipment:equipment];
        [self.classModifiers addModifier:[DKDependentModifierBuilder addedDiceModifierFromSource:self.classHitDice
                                                                                     explanation:@"Fighter hit dice"] forStatisticID:DKStatIDHitDiceMax];
        
        self.martialArchetype = [DKFighter5E championArchetypeWithFighterLevel:self.classLevel
                                                                        skills:skills
                                                                     equipment:equipment
                                                              proficiencyBonus:proficiencyBonus];
    }
    return self;
}

@end
