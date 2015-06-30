//
//  DKCleric5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/27/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCleric5E.h"
#import "DKModifierBuilder.h"
#import "DKStatisticIDs5E.h"
#import "DKAbilities5E.h"
#import "DKWeapon5E.h"
#import "DKArmor5E.h"

@implementation DKCleric5E

@synthesize channelDivinityUsesCurrent = _channelDivinityUsesCurrent;
@synthesize channelDivinityUsesMax = _channelDivinityUsesMax;
@synthesize turnUndead = _turnUndead;
@synthesize divineIntervention = _divineIntervention;
@synthesize divineDomain = _divineDomain;

#pragma mark -

+ (DKModifierGroup*)clericWithLevel:(DKNumericStatistic*)level abilities:(DKAbilities5E*)abilities {
    
    DKModifierGroup* class = [[DKModifierGroup alloc] init];
    class.explanation = @"Cleric class modifiers";
    
    [class addModifier:[DKClass5E hitDiceModifierForSides:8 level:level] forStatisticID:DKStatIDClericHitDice];
    
    [class addModifier:[abilities.wisdom modifierFromAbilityScoreWithExplanation:@"Cleric spellcasting ability: Wisdom"]
        forStatisticID:DKStatIDSpellSaveDC];
    [class addModifier:[abilities.wisdom modifierFromAbilityScoreWithExplanation:@"Cleric spellcasting ability: Wisdom"]
        forStatisticID:DKStatIDSpellAttackBonus];
    [class addModifier:[abilities.wisdom modifierFromAbilityScoreWithExplanation:@"Cleric spellcasting ability: Wisdom"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:level explanation:@"Cleric level"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKModifierBuilder modifierWithMinimum:1 explanation:@"Minimum of 1 prepared spell"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:@"Channel Divinity" explanation:@"You have the ability to channel divine energy directly from your deity, using that energy to fuel magical effects.  When you use your Channel Divinity, you choose which effect to create.  You must then finish a short or long rest to use your Channel Divinity again."]
        forStatisticID:DKStatIDClericTraits];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:@"Ritual Casting" explanation:@"You can cast a cleric spell as a ritual if that spell has the ritual tag and you have the spell prepared"]
        forStatisticID:DKStatIDClericTraits];
    
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Saving Throw Proficiency: Wisdom"]
        forStatisticID:DKStatIDSavingThrowWisdomProficiency];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Saving Throw Proficiency: Charisma"]
        forStatisticID:DKStatIDSavingThrowCharismaProficiency];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeaponCategory:kDKWeaponCategory5E_Simple]
                                                         explanation:@"Cleric Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Light]
                                                         explanation:@"Cleric Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Medium]
                                                         explanation:@"Cleric Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Shield]
                                                         explanation:@"Cleric Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    
    NSExpression* channelDivinityValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                         @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:1] : @(0),
                                            [DKDependentModifierBuilder rangeValueWithMin:2 max:5] : @(1),
                                            [DKDependentModifierBuilder rangeValueWithMin:6 max:17] : @(2),
                                            [DKDependentModifierBuilder rangeValueWithMin:18 max:20] : @(3) }
                                                                               usingDependency:@"source"];
    DKDependentModifier* channelDivinityUses = [[DKDependentModifier alloc] initWithSource:level
                                                                                     value:channelDivinityValue
                                                                                  priority:kDKModifierPriority_Additive
                                                                                expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [class addModifier:channelDivinityUses forStatisticID:DKStatIDChannelDivinityUsesMax];
    
    DKModifierGroup* turnUndeadGroup = [DKCleric5E turnUndeadWithLevel:level];
    [class addSubgroup:turnUndeadGroup];
    
    DKModifierGroup* divineInterventionGroup = [DKCleric5E divineInterventionWithLevel:level];
    [class addSubgroup:divineInterventionGroup];
    
    DKModifierGroup* skillSubgroup = [[DKModifierGroup alloc] init];
    skillSubgroup.explanation = @"Cleric Skill Proficiencies: Choose two from History, Insight, Medicine, Persuasion, and Religion";
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Skill Proficiency: History (default)"]
                forStatisticID:DKStatIDSkillHistoryProficiency];
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Skill Proficiency: Religion (default)"]
                forStatisticID:DKStatIDSkillReligionProficiency];
    [class addSubgroup:skillSubgroup];
    
    DKModifierGroup* cantripsGroup = [DKCleric5E cantripsWithLevel:level];
    [class addSubgroup:cantripsGroup];
    
    DKModifierGroup* spellSlotsGroup = [DKCleric5E spellSlotsWithLevel:level];
    [class addSubgroup:spellSlotsGroup];
    
    NSArray* abilityScoreImprovementLevels = @[ @4, @8, @12, @16, @19];
    for (NSNumber* abilityScoreLevel in abilityScoreImprovementLevels) {
        DKModifierGroup* abilityScoreGroup = [DKClass5E abilityScoreImprovementForThreshold:abilityScoreLevel.integerValue level:level];
        [class addSubgroup:abilityScoreGroup];
    }
    
    return class;
}

+ (DKModifierGroup*)cantripsWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* cantripsGroup = [[DKModifierGroup alloc] init];
    cantripsGroup.explanation = @"Cleric cantrips";
    DKModifierGroup* cantripStartingGroup = [[DKModifierGroup alloc] init];
    cantripStartingGroup.explanation = @"Clerics are granted three cantrips at first level";
    [cantripsGroup addSubgroup:cantripStartingGroup];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithAppendedString:@"Light" explanation:@"First level Cleric cantrip (default)"] forStatisticID:DKStatIDCantrips];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithAppendedString:@"Sacred Flame" explanation:@"First level Cleric cantrip (default)"] forStatisticID:DKStatIDCantrips];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithAppendedString:@"Thaumaturgy" explanation:@"First level Cleric cantrip (default)"] forStatisticID:DKStatIDCantrips];
    
    DKModifierGroup* cantripSecondGroup = [[DKModifierGroup alloc] init];
    cantripSecondGroup.explanation = @"Clerics are granted one additional cantrip at fourth level";
    [cantripsGroup addSubgroup:cantripSecondGroup];
    [cantripSecondGroup addModifier:[DKDependentModifierBuilder appendedModifierFromSource:level
                                                     value:[DKDependentModifierBuilder expressionForConstantValue:@"Spare the Dying"]
                                                   enabled:[DKDependentModifierBuilder
                                                            enabledWhen:@"source" isGreaterThanOrEqualTo:4]
                                               explanation:@"Fourth level Cleric cantrip (default)"]
                     forStatisticID:DKStatIDCantrips];
    
    DKModifierGroup* cantripThirdGroup = [[DKModifierGroup alloc] init];
    cantripThirdGroup.explanation = @"Clerics are granted one additional cantrip at tenth level";
    [cantripsGroup addSubgroup:cantripThirdGroup];
    [cantripThirdGroup addModifier:[DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                     value:[DKDependentModifierBuilder expressionForConstantValue:@"Guidance"]
                                                                                   enabled:[DKDependentModifierBuilder
                                                                                            enabledWhen:@"source" isGreaterThanOrEqualTo:10]
                                                                               explanation:@"Tenth level Cleric cantrip (default)"]
                     forStatisticID:DKStatIDCantrips];
    
    return cantripsGroup;
}

+ (DKModifierGroup*)spellSlotsWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* spellSlotsGroup = [[DKModifierGroup alloc] init];
    spellSlotsGroup.explanation = @"Cleric spell slots";
    
    NSExpression* firstLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:0] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:1 max:1] : @(2),
                                                 [DKDependentModifierBuilder rangeValueWithMin:2 max:2] : @(3),
                                                 [DKDependentModifierBuilder rangeValueWithMin:3 max:20] : @(4) }
                                                                                          usingDependency:@"source"];
    DKDependentModifier* firstLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                     value:firstLevelSpellSlotsValue
                                                                                  priority:kDKModifierPriority_Additive
                                                                                expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:firstLevelSpellSlots forStatisticID:DKStatIDFirstLevelSpellSlotsMax];
    
    NSExpression* secondLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:2] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:3 max:3] : @(2),
                                                 [DKDependentModifierBuilder rangeValueWithMin:4 max:20] : @(3) }
                                                                                          usingDependency:@"source"];
    DKDependentModifier* secondLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:secondLevelSpellSlotsValue
                                                                                   priority:kDKModifierPriority_Additive
                                                                                 expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:secondLevelSpellSlots forStatisticID:DKStatIDSecondLevelSpellSlotsMax];
    
    NSExpression* thirdLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                               @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:4] : @(0),
                                                  [DKDependentModifierBuilder rangeValueWithMin:5 max:5] : @(2),
                                                  [DKDependentModifierBuilder rangeValueWithMin:6 max:20] : @(3) }
                                                                                           usingDependency:@"source"];
    DKDependentModifier* thirdLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
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
    DKDependentModifier* fourthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
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
    DKDependentModifier* fifthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                       value:fifthLevelSpellSlotsValue
                                                                                    priority:kDKModifierPriority_Additive
                                                                                  expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:fifthLevelSpellSlots forStatisticID:DKStatIDFifthLevelSpellSlotsMax];
    
    NSExpression* sixthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:10] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:11 max:18] : @(1),
                                                 [DKDependentModifierBuilder rangeValueWithMin:19 max:20] : @(2) }
                                                                                          usingDependency:@"source"];
    DKDependentModifier* sixthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:sixthLevelSpellSlotsValue
                                                                                   priority:kDKModifierPriority_Additive
                                                                                 expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:sixthLevelSpellSlots forStatisticID:DKStatIDSixthLevelSpellSlotsMax];
    
    NSExpression* seventhLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                              @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:12] : @(0),
                                                 [DKDependentModifierBuilder rangeValueWithMin:13 max:19] : @(1),
                                                 [DKDependentModifierBuilder rangeValueWithMin:20 max:20] : @(2) }
                                                                                          usingDependency:@"source"];
    DKDependentModifier* seventhLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:seventhLevelSpellSlotsValue
                                                                                   priority:kDKModifierPriority_Additive
                                                                                 expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:seventhLevelSpellSlots forStatisticID:DKStatIDSeventhLevelSpellSlotsMax];
    
    NSExpression* eighthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                                @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:14] : @(0),
                                                   [DKDependentModifierBuilder rangeValueWithMin:15 max:20] : @(1) }
                                                                                            usingDependency:@"source"];
    DKDependentModifier* eighthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                        value:eighthLevelSpellSlotsValue
                                                                                     priority:kDKModifierPriority_Additive
                                                                                   expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:eighthLevelSpellSlots forStatisticID:DKStatIDEighthLevelSpellSlotsMax];
    
    NSExpression* ninthLevelSpellSlotsValue =[DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:
                                               @{ [DKDependentModifierBuilder rangeValueWithMin:0 max:16] : @(0),
                                                  [DKDependentModifierBuilder rangeValueWithMin:17 max:20] : @(1) }
                                                                                           usingDependency:@"source"];
    DKDependentModifier* ninthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                       value:ninthLevelSpellSlotsValue
                                                                                    priority:kDKModifierPriority_Additive
                                                                                  expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [spellSlotsGroup addModifier:ninthLevelSpellSlots forStatisticID:DKStatIDNinthLevelSpellSlotsMax];
    
    return spellSlotsGroup;
}

+ (DKModifierGroup*)turnUndeadWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* turnUndeadGroup = [[DKModifierGroup alloc] init];
    DKDependentModifier* turnUndeadAbility = [[DKDependentModifier alloc] initWithSource:level
                                                                                   value:[DKDependentModifierBuilder expressionForConstantInteger:1]
                                                                                 enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                          isGreaterThanOrEqualTo:2]
                                                                                priority:kDKModifierPriority_Additive
                                                                              expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    turnUndeadAbility.explanation = @"Channel Divinity - Turn Undead: As an action, you present your holy symbol and speak a prayer censuring the undead.  "  "Each undead that can see or hear you within 30 feet of you must make a Wisdom saving throw.  If the creature fails its saving throw, "
        "it is turned for 1 minute or until it takes any damage.";
    [turnUndeadGroup addModifier:turnUndeadAbility forStatisticID:DKStatIDTurnUndead];
    
    NSString* destroyUndeadExplanation = @"Destroy Undead: When an undead fails its saving throw against your Turn Undead feature, "
    "the creature is instantly destroyed if its challenge rating is at or below a certain threshold.";
    DKDependentModifier* destroyUndeadAbility = [DKDependentModifierBuilder informationalModifierFromSource:level
                                                                                                    enabled:[DKDependentModifierBuilder
                                                                                                             enabledWhen:@"source" isGreaterThanOrEqualTo:5]
                                                                                                explanation:destroyUndeadExplanation];
    [turnUndeadGroup addModifier:destroyUndeadAbility forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* firstCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                  value:nil
                                                                                enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                             isEqualToOrBetween:5 and:7]
                                                                               priority:kDKModifierPriority_Informational
                                                                             expression:nil];
    firstCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 1/2 or lower.";
    [turnUndeadGroup addModifier:firstCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* secondCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                   value:nil
                                                                                 enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                              isEqualToOrBetween:8 and:10]
                                                                                priority:kDKModifierPriority_Informational
                                                                              expression:nil];
    secondCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 1 or lower.";
    [turnUndeadGroup addModifier:secondCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* thirdCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                  value:nil
                                                                                enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                             isEqualToOrBetween:11 and:13]
                                                                               priority:kDKModifierPriority_Informational
                                                                             expression:nil];
    
    thirdCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 2 or lower.";
    [turnUndeadGroup addModifier:thirdCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* fourthCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                   value:nil
                                                                                 enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                              isEqualToOrBetween:14 and:16]
                                                                                priority:kDKModifierPriority_Informational
                                                                              expression:nil];
    
    fourthCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 3 or lower.";
    [turnUndeadGroup addModifier:fourthCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* fifthCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                  value:nil
                                                                                enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                         isGreaterThanOrEqualTo:17]
                                                                               priority:kDKModifierPriority_Informational
                                                                             expression:nil];
    fifthCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 4 or lower.";
    [turnUndeadGroup addModifier:fifthCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    return turnUndeadGroup;
}

+ (DKModifierGroup*)divineInterventionWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* divineInterventionGroup = [[DKModifierGroup alloc] init];
    
    NSString* divineInterventionExplanation = @"Divine Intervention: You can call on your deity to intervene on your behalf when your need is great.  "
    "Imploring your deity's aid requires you to use your action.  Describe the assistance you seek, and roll percentile dice.  If you roll a number "
    "equal to or lower than your cleric level, your deity intervenes.  If your deity intervenes, you can't use this feature again for 7 days.  Otherwise, "
    "you can use it again after you finish a long rest.";
    DKDependentModifier* divineInterventionAbility = [[DKDependentModifier alloc] initWithSource:level
                                                                                           value:[DKDependentModifierBuilder expressionForConstantInteger:1]
                                                                                         enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                  isGreaterThanOrEqualTo:10]
                                                                                        priority:kDKModifierPriority_Additive
                                                                                      expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    divineInterventionAbility.explanation = divineInterventionExplanation;
    [divineInterventionGroup addModifier:divineInterventionAbility forStatisticID:DKStatIDDivineIntervention];
    
    NSString* autoInterveneExplanation = @"Your call for intervention succeeds automatically, no roll required.";
    DKDependentModifier* autoInterveneAbility = [DKDependentModifierBuilder informationalModifierFromSource:level
                                                                                                    enabled:[DKDependentModifierBuilder
                                                                                                             enabledWhen:@"source" isGreaterThanOrEqualTo:20]
                                                                                                explanation:autoInterveneExplanation];
    [divineInterventionGroup addModifier:autoInterveneAbility forStatisticID:DKStatIDDivineIntervention];
    
    return divineInterventionGroup;
}

+ (DKModifierGroup*)domainSpellsGroupClericLevel:(DKNumericStatistic*)level spellDictionary:(NSDictionary*)spellsDict {

    DKModifierGroup* domainSpellsGroup = [[DKModifierGroup alloc] init];
    DKModifier* domainInfoModifier = [DKModifierBuilder modifierWithExplanation:@"Divine Domain: Spells granted by your Divine Domain do not count against "
                                      "your prepared spells limit."];
    [domainSpellsGroup addModifier:domainInfoModifier forStatisticID:DKStatIDPreparedSpellsMax];
    
    for (NSNumber* levelThreshold in spellsDict.allKeys) {
        NSArray* spellExplanations = spellsDict[levelThreshold];
        for (NSString* spellName in spellExplanations) {
            
            DKModifier* modifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                    value:[DKDependentModifierBuilder expressionForConstantValue:spellName]
                                                                                  enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                           isGreaterThanOrEqualTo:levelThreshold.intValue]
                                                                              explanation:[NSString stringWithFormat:@"Level %@ Divine Domain Spell", levelThreshold]];
            [domainSpellsGroup addModifier:modifier forStatisticID:DKStatIDPreparedSpells];
        }
    }
    
    return domainSpellsGroup;
}

#pragma mark -

+ (DKModifierGroup*)lifeDomainWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* lifeDomainGroup = [[DKModifierGroup alloc] init];
    lifeDomainGroup.explanation = @"Divine Domain: Life";
    
    [lifeDomainGroup addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Heavy]
                                                                   explanation:@"Life Domain Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    
    NSDictionary* spells = @{ @(1): @[ @"Bless", @"Cure Wounds" ],
                              @(3): @[ @"Lesser Restoration", @"Spiritual Weapon" ],
                              @(5): @[ @"Beacon of Hope", @"Revivify" ],
                              @(7): @[ @"Death Ward", @"Guardian of Faith" ],
                              @(9): @[ @"Mass Cure Wounds", @"Raise Dead" ] };
    DKModifierGroup* lifeDomainSpellsGroup = [DKCleric5E domainSpellsGroupClericLevel:level spellDictionary:spells];
    [lifeDomainGroup addSubgroup:lifeDomainSpellsGroup];
    
    DKModifier* discipleOfLife = [DKModifierBuilder modifierWithAppendedString:@"Disciple of Life" explanation:@"Whenever you use a spell of 1st level or higher to restore hit points to a creature, the creature regains additional hit points equal to 2 + the spell's level."];
    [lifeDomainGroup addModifier:discipleOfLife forStatisticID:DKStatIDClericTraits];
    
    NSString* preserveLifeExplanation = @"As an action, you present your holy symbol and evoke healing energy that "
    "can restore a number of hit points equal to five times your cleric level.  Choose any creatures within 30 feet of you, and divide those hit points "
    "among them.  This feature can restore a creature to no more than half of its hit point maximum.  You can't use this feature on an undead or "
    "a construct.";
    DKDependentModifier* preserveLifeAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                            constantValue:@"Channel Divinity - Preserve Life"
                                                                                                  enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                           isGreaterThanOrEqualTo:2]
                                                                                              explanation:preserveLifeExplanation];
    [lifeDomainGroup addModifier:preserveLifeAbility forStatisticID:DKStatIDClericTraits];
    
    NSString* blessedHealerExplanation = @"Blessed Healer: The healing spells you cast on others heal you as well.  When you cast a spell of 1st "
    "level or higher that restores hit points to a creature other than you, you regain hit points equal to 2 + the spell’s level.";

    DKDependentModifier* blessedHealerAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                        constantValue:@"Blessed Healer"
                                                                                              enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                       isGreaterThanOrEqualTo:6]
                                                                                          explanation:blessedHealerExplanation];
    [lifeDomainGroup addModifier:blessedHealerAbility forStatisticID:DKStatIDClericTraits];
    
    NSString* divineStrikeExplanation = @"You gain the ability to infuse your weapon strikes with divine energy. Once on each of your "
    "turns when you hit a creature with a weapon attack, you can cause the attack to deal an extra 1d8 radiant damage to the target. When you reach 14th "
    "level, the extra damage increases to 2d8.";
    DKDependentModifier* divineStrikeAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                         constantValue:@"Divine Strike"
                                                                                               enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                        isGreaterThanOrEqualTo:8]
                                                                                           explanation:divineStrikeExplanation];
    [lifeDomainGroup addModifier:divineStrikeAbility forStatisticID:DKStatIDClericTraits];
    
    NSString* supremeHealingExplanation = @"Supreme Healing: When you would normally roll one or more dice to restore hit points with a spell, you "
    "instead use the highest number possible for each die.";
    DKDependentModifier* supremeHealingAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                        constantValue:@"Supreme Healing"
                                                                                              enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                       isGreaterThanOrEqualTo:17]
                                                                                          explanation:supremeHealingExplanation];
    [lifeDomainGroup addModifier:supremeHealingAbility forStatisticID:DKStatIDClericTraits];
    
    return lifeDomainGroup;
}

#pragma mark -

- (id)initWithAbilities:(DKAbilities5E*)abilities {
    
    self = [super init];
    if (self) {
        
        self.channelDivinityUsesMax = [DKNumericStatistic statisticWithInt:0];
        self.channelDivinityUsesCurrent = [DKNumericStatistic statisticWithInt:0];
        [_channelDivinityUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_channelDivinityUsesMax]];
        
        self.turnUndead = [DKNumericStatistic statisticWithInt:0];
        self.divineIntervention = [DKNumericStatistic statisticWithInt:0];
        
        self.classModifiers = [DKCleric5E clericWithLevel:self.classLevel abilities:abilities];
        [self.classModifiers addModifier:[DKDependentModifierBuilder addedDiceModifierFromSource:self.classHitDice
                                                                                     explanation:@"Cleric hit dice"] forStatisticID:DKStatIDHitDiceMax];
        self.divineDomain = [DKCleric5E lifeDomainWithLevel:self.classLevel];
    }
    return self;
}

@end