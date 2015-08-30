//
//  DKWizard5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 7/1/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKWizard5E.h"
#import "DKStatisticIDs5E.h"
#import "DKModifierGroup.h"
#import "DKModifierGroupTags5E.h"
#import "DKAbilities5E.h"
#import "DKModifierBuilder.h"
#import "DKWeapon5E.h"
#import "DKSpellbook5E.h"

@implementation DKWizard5E

@synthesize arcaneRecoveryUsesCurrent = _arcaneRecoveryUsesCurrent;
@synthesize arcaneRecoveryUsesMax = _arcaneRecoveryUsesMax;
@synthesize arcaneRecoverySpellSlots = _arcaneRecoverySpellSlots;
@synthesize spellMasterySpells = _spellMasterySpells;
@synthesize signatureSpellUsesCurrent = _signatureSpellUsesCurrent;
@synthesize signatureSpellUsesMax = _signatureSpellUsesMax;
@synthesize signatureSpells = _signatureSpells;

+ (DKModifierGroup*)wizardWithLevel:(DKNumericStatistic*)level
                          abilities:(DKAbilities5E*)abilities
                    signatureSpells:(DKSetStatistic*)signatureSpells {
    
    DKModifierGroup* class = [[DKModifierGroup alloc] init];
    [class addDependency:level forKey:@"level"];
    class.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:1];
    class.explanation = @"Wizard class modifiers";
    
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:level explanation:@"Wizard level"]
        forStatisticID:DKStatIDLevel];
    [class addModifier:[DKClass5E hitDiceModifierForSides:6 level:level] forStatisticID:DKStatIDWizardHitDice];
    
    [class addModifier:[abilities.intelligence modifierFromAbilityScoreWithExplanation:@"Wizard spellcasting ability: Intelligence"]
        forStatisticID:DKStatIDSpellSaveDC];
    [class addModifier:[abilities.intelligence modifierFromAbilityScoreWithExplanation:@"Wizard spellcasting ability: Intelligence"]
        forStatisticID:DKStatIDSpellAttackBonus];
    [class addModifier:[abilities.intelligence modifierFromAbilityScoreWithExplanation:@"Wizard spellcasting ability: Intelligence"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:level explanation:@"Wizard level"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKModifierBuilder modifierWithMinimum:1 explanation:@"Minimum of 1 prepared spell"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:@"Ritual Casting" explanation:@"You can cast a wizard spell as a ritual if that spell has the ritual tag and you have the spell prepared"]
        forStatisticID:DKStatIDWizardTraits];
    
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Wizard Saving Throw Proficiency: Wisdom"]
        forStatisticID:DKStatIDSavingThrowWisdomProficiency];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Wizard Saving Throw Proficiency: Intelligence"]
        forStatisticID:DKStatIDSavingThrowIntelligenceProficiency];
    
    NSArray* weaponProficiencies = @[ @(kDKWeaponType5E_Dagger),
                                      @(kDKWeaponType5E_Dart),
                                      @(kDKWeaponType5E_Sling),
                                      @(kDKWeaponType5E_Quarterstaff),
                                      @(kDKWeaponType5E_LightCrossbow) ];
    for (NSNumber* weaponProficiency in weaponProficiencies) {
        [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:weaponProficiency.integerValue]
                                                             explanation:@"Wizard Weapon Proficiencies"]
            forStatisticID:DKStatIDWeaponProficiencies];
    }
    
    NSArray* skillProficiencyStatIDs = @[ DKStatIDSkillArcanaProficiency,
                                          DKStatIDSkillHistoryProficiency,
                                          DKStatIDSkillInsightProficiency,
                                          DKStatIDSkillInvestigationProficiency,
                                          DKStatIDSkillMedicineProficiency,
                                          DKStatIDSkillReligionProficiency ];
    DKModifierGroup* skillProficiencyGroup = [DKClass5E skillProficienciesWithStatIDs:skillProficiencyStatIDs
                                                                       choiceGroupTag:DKChoiceWizardSkillProficiency];
    skillProficiencyGroup.explanation = @"Wizard Skill Proficiencies: Choose two from Arcana, History, Insight, Investigation, Medicine, and Religion";
    [class addSubgroup:skillProficiencyGroup];
    
    DKModifierGroup* cantripsGroup = [DKWizard5E cantripsWithLevel:level];
    [class addSubgroup:cantripsGroup];
    
    DKModifierGroup* spellSlotsGroup = [DKWizard5E spellSlotsWithLevel:level];
    [class addSubgroup:spellSlotsGroup];
    
    DKModifierGroup* arcaneRecoveryGroup = [DKWizard5E arcaneRecoveryWithWizardLevel:level];
    [class addSubgroup:arcaneRecoveryGroup];
    
    DKModifierGroup* spellMasteryGroup = [DKWizard5E spellMasteryWithWizardLevel:level];
    [class addSubgroup:spellMasteryGroup];
    
    DKModifierGroup* signatureSpellsGroup = [DKWizard5E signatureSpellsWithWizardLevel:level
                                                                       signatureSpells:signatureSpells];
    [class addSubgroup:signatureSpellsGroup];
    
    DKModifierGroup* arcaneTraditionGroup = [DKWizard5E arcaneTraditionChoiceWithWizardLevel:level];
    [class addSubgroup:arcaneTraditionGroup];
    
    NSArray* abilityScoreImprovementLevels = @[ @4, @8, @12, @16, @19];
    for (NSNumber* abilityScoreLevel in abilityScoreImprovementLevels) {
        DKModifierGroup* abilityScoreGroup = [DKClass5E abilityScoreImprovementForThreshold:abilityScoreLevel.integerValue level:level];
        [class addSubgroup:abilityScoreGroup];
    }
    
    [class addModifier:[DKModifierBuilder modifierWithAdditiveBonus:100 explanation:@"Wizard starting gold"] forStatisticID:DKStatIDCurrencyGold];
    
    return class;
}

+ (DKModifierGroup*)cantripsWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* cantripsGroup = [[DKModifierGroup alloc] init];
    cantripsGroup.explanation = @"Wizard cantrips";
    
    for (int i = 0; i < 3; i++) {
        [cantripsGroup addSubgroup:[DKWizardSpellBuilder5E cantripChoiceWithLevel:level
                                                                        threshold:1
                                                                      explanation:@"First level Wizard cantrip"]];
    }
    
    [cantripsGroup addSubgroup:[DKWizardSpellBuilder5E cantripChoiceWithLevel:level
                                                                    threshold:4
                                                                  explanation:@"Fourth level Wizard cantrip"]];
    
    [cantripsGroup addSubgroup:[DKWizardSpellBuilder5E cantripChoiceWithLevel:level
                                                                    threshold:10
                                                                  explanation:@"Tenth level Wizard cantrip"]];
    
    return cantripsGroup;
}

+ (DKModifierGroup*)spellSlotsWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* spellSlotsGroup = [[DKModifierGroup alloc] init];
    spellSlotsGroup.explanation = @"Wizard spell slots";
    
    NSExpression* firstLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:0] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:1 max:1] : @(2),
                                                 [DKDependentModifierBuilder rangeValueWithMin:2 max:2] : @(3),
                                                 [DKDependentModifierBuilder rangeValueWithMin:3 max:20] : @(4) }
                                                                                          usingDependency:@"source"];
    DKModifier* firstLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                    value:firstLevelSpellSlotsValue
                                                                 priority:kDKModifierPriority_Additive
                                                               expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:firstLevelSpellSlots forStatisticID:DKStatIDFirstLevelSpellSlotsMax];
    
    NSExpression* secondLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                               @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:2] : @(0),
                                                  [DKDependentModifierBuilder rangeValueWithMin:3 max:3] : @(2),
                                                  [DKDependentModifierBuilder rangeValueWithMin:4 max:20] : @(3) }
                                                                                           usingDependency:@"source"];
    DKModifier* secondLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                     value:secondLevelSpellSlotsValue
                                                                  priority:kDKModifierPriority_Additive
                                                                expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:secondLevelSpellSlots forStatisticID:DKStatIDSecondLevelSpellSlotsMax];
    
    NSExpression* thirdLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:4] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:5 max:5] : @(2),
                                                 [DKDependentModifierBuilder rangeValueWithMin:6 max:20] : @(3) }
                                                                                          usingDependency:@"source"];
    DKModifier* thirdLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                    value:thirdLevelSpellSlotsValue
                                                                 priority:kDKModifierPriority_Additive
                                                               expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:thirdLevelSpellSlots forStatisticID:DKStatIDThirdLevelSpellSlotsMax];
    
    NSExpression* fourthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                               @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:6] : @(0),
                                                  [DKDependentModifierBuilder rangeValueWithMin:7 max:7] : @(1),
                                                  [DKDependentModifierBuilder rangeValueWithMin:8 max:8] : @(2),
                                                  [DKDependentModifierBuilder rangeValueWithMin:9 max:20] : @(3) }
                                                                                           usingDependency:@"source"];
    DKModifier* fourthLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                     value:fourthLevelSpellSlotsValue
                                                                  priority:kDKModifierPriority_Additive
                                                                expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:fourthLevelSpellSlots forStatisticID:DKStatIDFourthLevelSpellSlotsMax];
    
    NSExpression* fifthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:8] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:9 max:9] : @(1),
                                                 [DKDependentModifierBuilder rangeValueWithMin:10 max:17] : @(2),
                                                 [DKDependentModifierBuilder rangeValueWithMin:18 max:20] : @(3) }
                                                                                          usingDependency:@"source"];
    DKModifier* fifthLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                    value:fifthLevelSpellSlotsValue
                                                                 priority:kDKModifierPriority_Additive
                                                               expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:fifthLevelSpellSlots forStatisticID:DKStatIDFifthLevelSpellSlotsMax];
    
    NSExpression* sixthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:10] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:11 max:18] : @(1),
                                                 [DKDependentModifierBuilder rangeValueWithMin:19 max:20] : @(2) }
                                                                                          usingDependency:@"source"];
    DKModifier* sixthLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                    value:sixthLevelSpellSlotsValue
                                                                 priority:kDKModifierPriority_Additive
                                                               expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:sixthLevelSpellSlots forStatisticID:DKStatIDSixthLevelSpellSlotsMax];
    
    NSExpression* seventhLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                                @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:12] : @(0),
                                                   [DKDependentModifierBuilder rangeValueWithMin:13 max:19] : @(1),
                                                   [DKDependentModifierBuilder rangeValueWithMin:20 max:20] : @(2) }
                                                                                            usingDependency:@"source"];
    DKModifier* seventhLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                      value:seventhLevelSpellSlotsValue
                                                                   priority:kDKModifierPriority_Additive
                                                                 expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:seventhLevelSpellSlots forStatisticID:DKStatIDSeventhLevelSpellSlotsMax];
    
    NSExpression* eighthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                               @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:14] : @(0),
                                                  [DKDependentModifierBuilder rangeValueWithMin:15 max:20] : @(1) }
                                                                                           usingDependency:@"source"];
    DKModifier* eighthLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                     value:eighthLevelSpellSlotsValue
                                                                  priority:kDKModifierPriority_Additive
                                                                expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:eighthLevelSpellSlots forStatisticID:DKStatIDEighthLevelSpellSlotsMax];
    
    NSExpression* ninthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:16] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:17 max:20] : @(1) }
                                                                                          usingDependency:@"source"];
    DKModifier* ninthLevelSpellSlots = [[DKModifier alloc] initWithSource:level
                                                                    value:ninthLevelSpellSlotsValue
                                                                 priority:kDKModifierPriority_Additive
                                                               expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:ninthLevelSpellSlots forStatisticID:DKStatIDNinthLevelSpellSlotsMax];
    
    return spellSlotsGroup;
}

+ (DKModifierGroup*)spellbookWithWizardLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* spellbookGroup = [[DKModifierGroup alloc] init];
    spellbookGroup.explanation = @"Wizard spellbook";
    
    DKSubgroupChoiceModifierGroup* initialSpells = [[DKSubgroupChoiceModifierGroup alloc] initWithTag:@"DKChoiceInitialWizardSpells"];
    initialSpells.explanation = @"Starting Wizard spells.";
    [spellbookGroup addSubgroup:initialSpells];
    
    for (NSInteger i = 2; i <= 20; i++) {
        DKChoiceModifierGroup* spellChoice = [[DKSingleChoiceModifierGroup alloc] initWithTag:@"DKChoiceWizardSpell"];
        spellChoice.explanation = [NSString stringWithFormat:@"Spell learned at Wizard level %li.", (long)i];
        [spellbookGroup addSubgroup:spellChoice];
    }
    
    return spellbookGroup;
}

+ (DKModifierGroup*)arcaneRecoveryWithWizardLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* arcaneRecoveryGroup = [[DKModifierGroup alloc] init];
    [arcaneRecoveryGroup addDependency:level forKey:@"level"];
    arcaneRecoveryGroup.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:1];
    arcaneRecoveryGroup.explanation = @"Arcane Recovery ability";
    
    NSString* arcaneRecoveryExplanation = @"Once per day when you finish a short rest, you can choose expended spell slots to recover. The spell slots cannot be 6th level or higher.  For example, if you’re a 4th-level wizard, you can recover up to two levels worth of spell slots. You can recover either a 2nd-level spell slot or two 1st-level spell slots.";
    DKModifier* arcaneRecoveryAbility = [DKModifierBuilder modifierWithAppendedString:@"Arcane Recovery"
                                                                          explanation:arcaneRecoveryExplanation];
    [arcaneRecoveryGroup addModifier:arcaneRecoveryAbility forStatisticID:DKStatIDWizardTraits];
    
    DKModifier* arcaneRecoveryUses = [DKDependentModifierBuilder addedNumberFromSource:level
                                                                         constantValue:@1
                                                                               enabled:nil
                                                                           explanation:@"Once per day when you finish a short rest, you can choose expended spell slots to recover."];
    [arcaneRecoveryGroup addModifier:arcaneRecoveryUses forStatisticID:DKStatIDArcaneRecoveryUsesMax];
    
    NSExpression* divisionExpression = [NSExpression expressionForFunction:@"divide:by:" arguments:@[[NSExpression expressionForVariable:@"source"], [NSExpression expressionForConstantValue:@(2.0)]]];
    NSExpression* roundUpExpression = [NSExpression expressionForFunction:@"ceiling:" arguments:@[divisionExpression]];
    DKModifier* arcaneRecoverySlots = [[DKModifier alloc] initWithSource:level
                                                                   value:roundUpExpression
                                                                priority:kDKModifierPriority_Additive
                                                              expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    arcaneRecoverySlots.explanation = @"The spell slots can have a combined level that is equal to or less than half your wizard level (rounded up).";
    [arcaneRecoveryGroup addModifier:arcaneRecoverySlots forStatisticID:DKStatIDArcaneRecoverySpellSlots];
    
    return arcaneRecoveryGroup;
}

+ (DKModifierGroup*)spellMasteryWithWizardLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* spellMasteryGroup = [[DKModifierGroup alloc] init];
    [spellMasteryGroup addDependency:level forKey:@"level"];
    spellMasteryGroup.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:18];
    spellMasteryGroup.explanation = @"Spell Mastery ability";
    
    NSString* spellMasteryExplanation = @"Choose a 1st-level wizard spell and a 2nd-level wizard spell that are in your spellbook. You can cast those spells at their lowest level without expending a spell slot when you have them prepared. If you want to cast either spell at a higher level, you must expend a spell slot as normal.  By spending 8 hours in study, you can exchange one or both of the spells you chose for different spells of the same levels.";
    DKModifier* spellMasteryAbility = [DKModifierBuilder modifierWithAppendedString:@"Spell Mastery"
                                                                        explanation:spellMasteryExplanation];
    [spellMasteryGroup addModifier:spellMasteryAbility forStatisticID:DKStatIDWizardTraits];
    
    DKChoiceModifierGroup* firstLevelSpellChoice = [[DKSingleChoiceModifierGroup alloc] initWithTag:DKChoiceWizardSpellMastery];
    firstLevelSpellChoice.explanation = @"Choose a 1st-level wizard spell that is in your spellbook.";
    NSArray* firstLevelSpells = @[ @"Burning Hands",
                                   @"Charm Person",
                                   @"Comprehend Languages",
                                   @"Disguise Self",
                                   @"Identify",
                                   @"Mage Armor",
                                   @"Magic Missile",
                                   @"Shield",
                                   @"Silent Image",
                                   @"Sleep",
                                   @"Thunderwave" ];
    for (NSString* spellName in firstLevelSpells) {
        
        DKModifier* firstLevelSpell = [DKModifierBuilder modifierWithAppendedString:spellName
                                                                        explanation:@"Wizard Spell Mastery"];
        [firstLevelSpellChoice addModifier:firstLevelSpell forStatisticID:DKStatIDSpellMasterySpells];
    }
    
    [spellMasteryGroup addSubgroup:firstLevelSpellChoice];
    
    DKChoiceModifierGroup* secondLevelSpellChoice = [[DKSingleChoiceModifierGroup alloc] initWithTag:DKChoiceWizardSpellMastery];
    secondLevelSpellChoice.explanation = @"Choose a 2nd-level wizard spell that is in your spellbook.";
    NSArray* secondLevelSpells = @[ @"Arcane Lock",
                                    @"Blur",
                                    @"Darkness",
                                    @"Flaming Sphere",
                                    @"Hold Person",
                                    @"Invisibility",
                                    @"Knock",
                                    @"Levitate",
                                    @"Magic Weapon",
                                    @"Misty Step",
                                    @"Shatter",
                                    @"Spider Climb",
                                    @"Suggestion",
                                    @"Web" ];
    for (NSString* spellName in secondLevelSpells) {
        
        DKModifier* secondLevelSpell = [DKModifierBuilder modifierWithAppendedString:spellName
                                                                         explanation:@"Wizard Spell Mastery"];
        [secondLevelSpellChoice addModifier:secondLevelSpell forStatisticID:DKStatIDSpellMasterySpells];
    }
    [spellMasteryGroup addSubgroup:secondLevelSpellChoice];
    
    return spellMasteryGroup;
}

+ (DKModifierGroup*)signatureSpellsWithWizardLevel:(DKNumericStatistic*)level
                                   signatureSpells:(DKSetStatistic*)signatureSpells {
    
    DKModifierGroup* signatureSpellsGroup = [[DKModifierGroup alloc] init];
    [signatureSpellsGroup addDependency:level forKey:@"level"];
    signatureSpellsGroup.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:20];
    signatureSpellsGroup.explanation = @"Signature Spells ability";
    
    NSString* signatureSpellsExplanation = @"Choose two 3rd-level wizard spells in your spellbook as your signature spells. You always have these spells prepared, they don’t count against the number of spells you have prepared, and you can cast each of them once at 3rd level without expending a spell slot. When you do so, you can’t do so again until you finish a short or long rest.  If you want to cast either spell at a higher level, you must expend a spell slot as normal.";
    DKModifier* signatureSpellsAbility = [DKModifierBuilder modifierWithAppendedString:@"Signature Spells"
                                                                           explanation:signatureSpellsExplanation];
    [signatureSpellsGroup addModifier:signatureSpellsAbility forStatisticID:DKStatIDWizardTraits];
    
    DKSingleChoiceModifierGroup* thirdLevelSpellChoice = [[DKSingleChoiceModifierGroup alloc] initWithTag:DKChoiceWizardSignatureSpell];
    thirdLevelSpellChoice.explanation = @"Choose a 3rd-level wizard spell in your spellbook as one of your signature spells.";
    
    DKSingleChoiceModifierGroup* otherThirdLevelSpellChoice = [[DKSingleChoiceModifierGroup alloc] initWithTag:DKChoiceWizardSignatureSpell];
    otherThirdLevelSpellChoice.explanation = @"Choose a 3rd-level wizard spell in your spellbook as one of your signature spells.";
    
    NSArray* thirdLevelSpells = @[ @"Counterspell",
                                   @"Dispel Magic",
                                   @"Fireball",
                                   @"Fly",
                                   @"Haste",
                                   @"Lightning Bolt",
                                   @"Major Image",
                                   @"Protection from Energy" ];
    DKModifierGroup* thirdLevelSpellGroup = [[DKModifierGroup alloc] init];
    for (NSString* spellName in thirdLevelSpells) {
        
        DKModifier* thirdLevelSpell = [DKModifierBuilder modifierWithAppendedString:spellName
                                                                        explanation:@"Wizard Signature Spell"];
        [thirdLevelSpellGroup addModifier:thirdLevelSpell forStatisticID:DKStatIDSignatureSpells];
    }
    
    thirdLevelSpellChoice.choicesSource = thirdLevelSpellGroup;
    otherThirdLevelSpellChoice.choicesSource = thirdLevelSpellGroup;
    [signatureSpellsGroup addSubgroup:thirdLevelSpellChoice];
    [signatureSpellsGroup addSubgroup:otherThirdLevelSpellChoice];
    
    DKModifier* preparedSpellsBonus = [DKModifierBuilder modifierWithAdditiveBonus:2];
    preparedSpellsBonus.explanation = @"Signature spells don’t count against the number of spells you have prepared";;
    [signatureSpellsGroup addModifier:preparedSpellsBonus forStatisticID:DKStatIDPreparedSpellsMax];
    
    NSString* preparedSpellsExplanation = @"Wizard's Signature Spells are always prepared.";
    DKModifier* preparedSpellsModifier = [[DKModifier alloc] initWithSource:signatureSpells
                                                                      value:[DKDependentModifierBuilder valueFromDependency:@"source"]
                                                                   priority:kDKModifierPriority_Additive
                                                                 expression:[DKModifierBuilder simpleAppendSetModifierExpression]];
    preparedSpellsModifier.explanation = preparedSpellsExplanation;
    [signatureSpellsGroup addModifier:preparedSpellsModifier forStatisticID:DKStatIDPreparedSpells];
    
    NSString* signatureSpellRecharge = @"Once you cast a signature spell using this feature, you can’t use it again without a spell slot "
        "until you finish a short or long rest.";
    DKModifier* signatureSpellUsesModifier = [DKModifierBuilder modifierWithAdditiveBonus:2
                                                                              explanation:signatureSpellRecharge];
    [signatureSpellsGroup addModifier:signatureSpellUsesModifier forStatisticID:DKStatIDSignatureSpellUsesMax];
    
    return signatureSpellsGroup;
}

#pragma mark -

+ (DKChoiceModifierGroup*)arcaneTraditionChoiceWithWizardLevel:(DKNumericStatistic*)level {
    
    DKSubgroupChoiceModifierGroup* arcaneTraditionGroup = [[DKSubgroupChoiceModifierGroup alloc] initWithTag:DKChoiceWizardArcaneTradition];
    arcaneTraditionGroup.explanation = @"Wizard arcane archetype";
    [arcaneTraditionGroup addDependency:level forKey:@"level"];
    arcaneTraditionGroup.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:2];
    
    [arcaneTraditionGroup addSubgroup:[DKWizard5E evocationArcaneTraditionWithLevel:level]];
    
    return arcaneTraditionGroup;
}

+ (DKModifierGroup*)evocationArcaneTraditionWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* evocationGroup = [[DKModifierGroup alloc] init];
    evocationGroup.explanation = @"Evocation Arcane Tradition";
    
    //Evocation Savant
    NSString* evocationSavantExplanation = @"No attack roll has advantage against you while you aren’t incapacitated.";
    DKModifier* evocationSavantModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                   constantValue:@"Evocation Savant"
                                                                                         enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                  isGreaterThanOrEqualTo:2]
                                                                                     explanation:evocationSavantExplanation];
    [evocationGroup addModifier:evocationSavantModifier forStatisticID:DKStatIDWizardTraits];
    
    //Sculpt Spells
    NSString* sculptSpellsExplanation = @"When you cast an evocation spell that affects other creatures that you can see, you can choose a number of them equal to 1 + the spell’s level. The chosen creatures automatically succeed on their saving throws against the spell, and they take no damage if they would normally take half damage on a successful save.";
    DKModifier* sculptSpellsModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                constantValue:@"Sculpt Spells"
                                                                                      enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                               isGreaterThanOrEqualTo:2]
                                                                                  explanation:sculptSpellsExplanation];
    [evocationGroup addModifier:sculptSpellsModifier forStatisticID:DKStatIDWizardTraits];
    
    //Potent Cantrip
    NSString* potentCantripExplanation = @"When a creature succeeds on a saving throw against your cantrip, the creature takes half the cantrip’s damage (if any) but suffers no additional effect from the cantrip.";
    DKModifier* potentCantripModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                 constantValue:@"Potent Cantrip"
                                                                                       enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                isGreaterThanOrEqualTo:6]
                                                                                   explanation:potentCantripExplanation];
    [evocationGroup addModifier:potentCantripModifier forStatisticID:DKStatIDWizardTraits];
    
    //Empowered Evocation
    NSString* empoweredEvocationExplanation = @"You can add your Intelligence modifier to one damage roll of any wizard evocation spell you cast.";
    DKModifier* empoweredEvocationModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                      constantValue:@"Empowered Evocation"
                                                                                            enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                     isGreaterThanOrEqualTo:10]
                                                                                        explanation:empoweredEvocationExplanation];
    [evocationGroup addModifier:empoweredEvocationModifier forStatisticID:DKStatIDWizardTraits];
    
    //Overchannel
    NSString* overchannelExplanation = @"When you cast a wizard spell of 1st through 5th level that deals damage, you can deal maximum damage with that spell.  The first time you do so, you suffer no adverse effect. If you use this feature again before you finish a long rest, you take 2d12 necrotic damage for each level of the spell, immediately after you cast it. Each time you use this feature again before finishing a long rest, the necrotic damage per spell level increases by 1d12. This damage ignores resistance and immunity.";
    DKModifier* overchannelModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                               constantValue:@"Overchannel"
                                                                                     enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                              isGreaterThanOrEqualTo:14]
                                                                                 explanation:overchannelExplanation];
    [evocationGroup addModifier:overchannelModifier forStatisticID:DKStatIDWizardTraits];
    
    return evocationGroup;
}

- (id)initWithAbilities:(DKAbilities5E*)abilities {
    self = [super init];
    if (self) {
        
        self.classModifiers = [DKWizard5E wizardWithLevel:self.classLevel
                                                abilities:abilities
                                          signatureSpells:_signatureSpells];
        [self.classModifiers addModifier:[DKDependentModifierBuilder addedDiceModifierFromSource:self.classHitDice
                                                                                     explanation:@"Wizard hit dice"] forStatisticID:DKStatIDHitDiceMax];
    }
    return self;
}

- (NSDictionary*) statisticKeyPaths {
    return @{
             DKStatIDWizardLevel: @"classLevel",
             DKStatIDWizardTraits: @"classTraits",
             DKStatIDWizardHitDice: @"classHitDice",
             DKStatIDArcaneRecoveryUsesCurrent: @"arcaneRecoveryUsesCurrent",
             DKStatIDArcaneRecoveryUsesMax: @"arcaneRecoveryUsesMax",
             DKStatIDArcaneRecoverySpellSlots: @"arcaneRecoverySpellSlots",
             DKStatIDSpellMasterySpells: @"spellMasterySpells",
             DKStatIDSignatureSpellUsesCurrent: @"signatureSpellUsesCurrent",
             DKStatIDSignatureSpellUsesMax: @"signatureSpellUsesMax",
             DKStatIDSignatureSpells: @"signatureSpells",
             };
}

- (void)loadStatistics {
    
    [super loadStatistics];
    self.arcaneRecoveryUsesCurrent = [DKNumericStatistic statisticWithInt:0];
    self.arcaneRecoveryUsesMax = [DKNumericStatistic statisticWithInt:0];
    self.arcaneRecoverySpellSlots = [DKNumericStatistic statisticWithInt:0];
    self.spellMasterySpells = [DKSetStatistic statisticWithEmptySet];
    self.signatureSpellUsesCurrent = [DKNumericStatistic statisticWithInt:0];
    self.signatureSpellUsesMax = [DKNumericStatistic statisticWithInt:0];
    self.signatureSpells = [DKSetStatistic statisticWithEmptySet];
}

- (void)loadModifiers {
    
    [super loadModifiers];
    [_arcaneRecoveryUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_arcaneRecoveryUsesMax]];
    [_signatureSpellUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_signatureSpellUsesMax]];
}

@end


@implementation DKWizardSpellBuilder5E

+ (DKChoiceModifierGroup*)cantripChoiceWithExplanation:(NSString*)explanation {
    
    return [DKWizardSpellBuilder5E cantripChoiceWithLevel:nil threshold:0 explanation:explanation];
}

+ (DKChoiceModifierGroup*)cantripChoiceWithLevel:(DKNumericStatistic*)level
                                       threshold:(NSInteger)threshold
                                     explanation:(NSString*)explanation {
    
    DKChoiceModifierGroup* cantripGroup = [[DKSingleChoiceModifierGroup alloc] initWithTag:DKChoiceWizardCantrip];
    if (level && threshold > 0) {
        [cantripGroup addDependency:level forKey:@"level"];
        cantripGroup.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"level" isGreaterThanOrEqualTo:threshold];
    }
    
    NSArray* spellNames = @[ @"Acid Splash",
                             @"Dancing Lights",
                             @"Fire Bolt",
                             @"Light",
                             @"Mage Hand",
                             @"Minor Illusion",
                             @"Poison Spray",
                             @"Prestidigitation",
                             @"Ray of Frost",
                             @"Shocking Grasp" ];
    for (NSString* spell in spellNames) {
        
        DKModifier* modifier = [DKModifierBuilder modifierWithAppendedString:spell
                                                                 explanation:explanation];
        [cantripGroup addModifier:modifier forStatisticID:DKStatIDCantrips];
    }
    
    return cantripGroup;
}

@end

