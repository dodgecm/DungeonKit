//
//  DKCleric5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/27/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCleric5E.h"
#import "DKStatisticIDs5E.h"
#import "DKAbilities5E.h"

@implementation DKCleric5E

@synthesize channelDivinityUsesCurrent = _channelDivinityUsesCurrent;
@synthesize channelDivinityUsesMax = _channelDivinityUsesMax;
@synthesize turnUndead = _turnUndead;
@synthesize divineIntervention = _divineIntervention;
@synthesize divineDomain = _divineDomain;

#pragma mark -

+ (DKModifierGroup*)clericWithLevel:(DKStatistic*)level abilities:(DKAbilities5E*)abilities {
    
    DKModifierGroup* class = [[DKModifierGroup alloc] init];
    class.explanation = @"Cleric class modifiers";
    [class addModifier:[DKModifierBuilder modifierWithAdditiveBonus:8 explanation:@"Cleric hit die"]
        forStatisticID:DKStatIDHitDiceMaxSides];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:abilities.wisdom explanation:@"Cleric spellcasting ability: Wisdom"]  forStatisticID:DKStatIDSpellSaveDC];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:abilities.wisdom explanation:@"Cleric spellcasting ability: Wisdom"] forStatisticID:DKStatIDSpellAttackBonus];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:abilities.wisdom explanation:@"Cleric spellcasting ability: Wisdom"] forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKDependentModifierBuilder simpleModifierFromSource:level explanation:@"Cleric level"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKModifierBuilder modifierWithMinimum:1 explanation:@"Minimum of 1 prepared spell"]
        forStatisticID:DKStatIDPreparedSpellsMax];
    [class addModifier:[DKModifierBuilder modifierWithExplanation:@"Channel Divinity: You have the ability to channel divine energy directly from your deity, using that energy to fuel magical effects.  When you use your Channel Divinity, you choose which effect to create.  You must then finish a short or long rest to use your Channel Divinity again."]
        forStatisticID:DKStatIDClericTraits];
    [class addModifier:[DKModifierBuilder modifierWithExplanation:@"Ritual Casting: You can cast a cleric spell as a ritual if that spell "
                        "has the ritual tag and you have the spell prepared"]
        forStatisticID:DKStatIDClericTraits];
    
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Saving Throw Proficiency: Wisdom"]
        forStatisticID:DKStatIDSavingThrowWisdomProficiency];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Cleric Saving Throw Proficiency: Charisma"]
        forStatisticID:DKStatIDSavingThrowCharismaProficiency];
    [class addModifier:[DKModifierBuilder modifierWithExplanation:@"Cleric Weapon Proficiencies: Simple weapons"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithExplanation:@"Cleric Armor Proficiencies: Light and medium armor, shields"]
        forStatisticID:DKStatIDArmorProficiencies];
    
    DKDependentModifier* channelDivinityUses = [[DKDependentModifier alloc] initWithSource:level
                                                                                     value:^int(int sourceValue) {
                                                                                         if (sourceValue <= 1) { return 0; }
                                                                                         if (sourceValue >= 2 && sourceValue <= 5) { return 1; }
                                                                                         else if (sourceValue >= 6 && sourceValue <= 17) { return 2; }
                                                                                         else { return 3; }
                                                                                     }
                                                                                  priority:kDKModifierPriority_Additive
                                                                                     block:[DKModifierBuilder simpleAdditionModifierBlock]];
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
    
    DKModifierGroup* fourthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:4 level:level];
    [class addSubgroup:fourthLevelAbilityScore];
    DKModifierGroup* eighthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:8 level:level];
    [class addSubgroup:eighthLevelAbilityScore];
    DKModifierGroup* twelfthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:12 level:level];
    [class addSubgroup:twelfthLevelAbilityScore];
    DKModifierGroup* sixteenthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:16 level:level];
    [class addSubgroup:sixteenthLevelAbilityScore];
    DKModifierGroup* nineteenthLevelAbilityScore = [DKClass5E abilityScoreImprovementForThreshold:19 level:level];
    [class addSubgroup:nineteenthLevelAbilityScore];
    
    return class;
}

+ (DKModifierGroup*)cantripsWithLevel:(DKStatistic*)level {
    
    DKModifierGroup* cantripsGroup = [[DKModifierGroup alloc] init];
    cantripsGroup.explanation = @"Cleric cantrips";
    DKModifierGroup* cantripStartingGroup = [[DKModifierGroup alloc] init];
    cantripStartingGroup.explanation = @"Clerics are granted three cantrips at first level";
    [cantripsGroup addSubgroup:cantripStartingGroup];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithExplanation:@"Light (default)"] forStatisticID:DKStatIDCantrips];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithExplanation:@"Sacred Flame (default)"] forStatisticID:DKStatIDCantrips];
    [cantripStartingGroup addModifier:[DKModifierBuilder modifierWithExplanation:@"Thaumaturgy (default)"] forStatisticID:DKStatIDCantrips];
    
    DKModifierGroup* cantripSecondGroup = [[DKModifierGroup alloc] init];
    cantripSecondGroup.explanation = @"Clerics are granted one additional cantrip at fourth level";
    [cantripsGroup addSubgroup:cantripSecondGroup];
    [cantripSecondGroup addModifier:[DKDependentModifierBuilder informationalModifierFromSource:level threshold:4
                                                                                    explanation:@"Spare the Dying (default)"]
                     forStatisticID:DKStatIDCantrips];
    
    DKModifierGroup* cantripThirdGroup = [[DKModifierGroup alloc] init];
    cantripThirdGroup.explanation = @"Clerics are granted one additional cantrip at tenth level";
    [cantripsGroup addSubgroup:cantripThirdGroup];
    [cantripThirdGroup addModifier:[DKDependentModifierBuilder informationalModifierFromSource:level threshold:10
                                                                                   explanation:@"Guidance (default)"]
                    forStatisticID:DKStatIDCantrips];
    
    return cantripsGroup;
}

+ (DKModifierGroup*)spellSlotsWithLevel:(DKStatistic*)level {
    
    DKModifierGroup* spellSlotsGroup = [[DKModifierGroup alloc] init];
    spellSlotsGroup.explanation = @"Cleric spell slots";
    
    DKDependentModifier* firstLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:^int(int sourceValue) {
                                                                                          if (sourceValue == 1) { return 2; }
                                                                                          else if (sourceValue == 2) { return 3; }
                                                                                          else { return 4; }
                                                                                      }
                                                                                   priority:kDKModifierPriority_Additive
                                                                                      block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:firstLevelSpellSlots forStatisticID:DKStatIDFirstLevelSpellSlotsMax];
    
    DKDependentModifier* secondLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                       value:^int(int sourceValue) {
                                                                                           if (sourceValue <= 2) { return 0; }
                                                                                           else if (sourceValue == 2) { return 2; }
                                                                                           else { return 3; }
                                                                                       }
                                                                                    priority:kDKModifierPriority_Additive
                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:secondLevelSpellSlots forStatisticID:DKStatIDSecondLevelSpellSlotsMax];
    
    DKDependentModifier* thirdLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:^int(int sourceValue) {
                                                                                          if (sourceValue <= 4) { return 0; }
                                                                                          else if (sourceValue == 5) { return 2; }
                                                                                          else { return 3; }
                                                                                      }
                                                                                   priority:kDKModifierPriority_Additive
                                                                                      block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:thirdLevelSpellSlots forStatisticID:DKStatIDThirdLevelSpellSlotsMax];
    
    DKDependentModifier* fourthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                       value:^int(int sourceValue) {
                                                                                           if (sourceValue <= 6) { return 0; }
                                                                                           else if (sourceValue == 7) { return 1; }
                                                                                           else if (sourceValue == 8) { return 2; }
                                                                                           else { return 3; }
                                                                                       }
                                                                                    priority:kDKModifierPriority_Additive
                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:fourthLevelSpellSlots forStatisticID:DKStatIDFourthLevelSpellSlotsMax];
    
    DKDependentModifier* fifthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:^int(int sourceValue) {
                                                                                          if (sourceValue <= 8) { return 0; }
                                                                                          else if (sourceValue == 9) { return 1; }
                                                                                          else if (sourceValue >= 10 && sourceValue <= 17) { return 2; }
                                                                                          else { return 3; }
                                                                                      }
                                                                                   priority:kDKModifierPriority_Additive
                                                                                      block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:fifthLevelSpellSlots forStatisticID:DKStatIDFifthLevelSpellSlotsMax];
    
    DKDependentModifier* sixthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:^int(int sourceValue) {
                                                                                          if (sourceValue <= 10) { return 0; }
                                                                                          else if (sourceValue >= 11 && sourceValue <= 18) { return 1; }
                                                                                          else { return 2; }
                                                                                      }
                                                                                   priority:kDKModifierPriority_Additive
                                                                                      block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:sixthLevelSpellSlots forStatisticID:DKStatIDSixthLevelSpellSlotsMax];
    
    DKDependentModifier* seventhLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                        value:^int(int sourceValue) {
                                                                                            if (sourceValue <= 12) { return 0; }
                                                                                            else if (sourceValue >= 13 && sourceValue <= 19) { return 1; }
                                                                                            else { return 2; }
                                                                                        }
                                                                                     priority:kDKModifierPriority_Additive
                                                                                        block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:seventhLevelSpellSlots forStatisticID:DKStatIDSeventhLevelSpellSlotsMax];
    
    DKDependentModifier* eighthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                       value:^int(int sourceValue) {
                                                                                           if (sourceValue <= 14) { return 0; }
                                                                                           else { return 1; }
                                                                                       }
                                                                                    priority:kDKModifierPriority_Additive
                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:eighthLevelSpellSlots forStatisticID:DKStatIDEighthLevelSpellSlotsMax];
    
    DKDependentModifier* ninthLevelSpellSlots = [[DKDependentModifier alloc] initWithSource:level
                                                                                      value:^int(int sourceValue) {
                                                                                          if (sourceValue <= 16) { return 0; }
                                                                                          else { return 1; }
                                                                                      }
                                                                                   priority:kDKModifierPriority_Additive
                                                                                      block:[DKModifierBuilder simpleAdditionModifierBlock]];
    [spellSlotsGroup addModifier:ninthLevelSpellSlots forStatisticID:DKStatIDNinthLevelSpellSlotsMax];
    
    return spellSlotsGroup;
}

+ (DKModifierGroup*)turnUndeadWithLevel:(DKStatistic*)level {
    
    DKModifierGroup* turnUndeadGroup = [[DKModifierGroup alloc] init];
    DKDependentModifier* turnUndeadAbility = [[DKDependentModifier alloc] initWithSource:level
                                                                                   value:^int(int sourceValue) {
                                                                                       if (sourceValue <= 1) { return 0; }
                                                                                       else { return 1; }
                                                                                   }
                                                                                 enabled:^BOOL(int sourceValue) {
                                                                                     if (sourceValue <= 1) { return NO; }
                                                                                     else { return YES; }
                                                                                 }
                                                                                priority:kDKModifierPriority_Additive                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    turnUndeadAbility.explanation = @"Channel Divinity - Turn Undead: As an action, you present your holy symbol and speak a prayer censuring the undead.  "  "Each undead that can see or hear you within 30 feet of you must make a Wisdom saving throw.  If the creature fails its saving throw, "
        "it is turned for 1 minute or until it takes any damage.";
    [turnUndeadGroup addModifier:turnUndeadAbility forStatisticID:DKStatIDTurnUndead];
    
    NSString* destroyUndeadExplanation = @"Destroy Undead: When an undead fails its saving throw against your Turn Undead feature, "
    "the creature is instantly destroyed if its challenge rating is at or below a certain threshold.";
    DKDependentModifier* destroyUndeadAbility = [DKDependentModifierBuilder informationalModifierFromSource:level
                                                                                                  threshold:5
                                                                                                explanation:destroyUndeadExplanation];
    [turnUndeadGroup addModifier:destroyUndeadAbility forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* firstCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                   value:^int(int sourceValue) { return 0; }
                                                                                 enabled:^BOOL(int sourceValue) {
                                                                                     if (sourceValue <= 4 || sourceValue >= 8) { return NO; }
                                                                                     else { return YES; }
                                                                                 }
                                                                                priority:kDKModifierPriority_Informational                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    firstCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 1/2 or lower.";
    [turnUndeadGroup addModifier:firstCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* secondCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                   value:^int(int sourceValue) { return 0; }
                                                                                 enabled:^BOOL(int sourceValue) {
                                                                                     if (sourceValue <= 7 || sourceValue >= 11) { return NO; }
                                                                                     else { return YES; }
                                                                                 }
                                                                                priority:kDKModifierPriority_Informational                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    secondCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 1 or lower.";
    [turnUndeadGroup addModifier:secondCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* thirdCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                  value:^int(int sourceValue) { return 0; }
                                                                                enabled:^BOOL(int sourceValue) {
                                                                                    if (sourceValue <= 10 || sourceValue >= 14) { return NO; }
                                                                                    else { return YES; }
                                                                                }
                                                                               priority:kDKModifierPriority_Informational                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    thirdCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 2 or lower.";
    [turnUndeadGroup addModifier:thirdCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* fourthCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                   value:^int(int sourceValue) { return 0; }
                                                                                 enabled:^BOOL(int sourceValue) {
                                                                                     if (sourceValue <= 13 || sourceValue >= 17) { return NO; }
                                                                                     else { return YES; }
                                                                                 }
                                                                                priority:kDKModifierPriority_Informational                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    fourthCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 3 or lower.";
    [turnUndeadGroup addModifier:fourthCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    DKDependentModifier* fifthCRThreshold = [[DKDependentModifier alloc] initWithSource:level
                                                                                  value:^int(int sourceValue) { return 0; }
                                                                                enabled:^BOOL(int sourceValue) {
                                                                                    if (sourceValue <= 16) { return NO; }
                                                                                    else { return YES; }
                                                                                }
                                                                               priority:kDKModifierPriority_Informational                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    fifthCRThreshold.explanation = @"Destroy Undead destroys undead creatures of CR 4 or lower.";
    [turnUndeadGroup addModifier:fifthCRThreshold forStatisticID:DKStatIDTurnUndead];
    
    return turnUndeadGroup;
}

+ (DKModifierGroup*)divineInterventionWithLevel:(DKStatistic*)level {
    
    DKModifierGroup* divineInterventionGroup = [[DKModifierGroup alloc] init];
    
    NSString* divineInterventionExplanation = @"Divine Intervention: You can call on your deity to intervene on your behalf when your need is great.  "
    "Imploring your deity's aid requires you to use your action.  Describe the assistance you seek, and roll percentile dice.  If you roll a number "
    "equal to or lower than your cleric level, your deity intervenes.  If your deity intervenes, you can't use this feature again for 7 days.  Otherwise, "
    "you can use it again after you finish a long rest.";
    DKDependentModifier* divineInterventionAbility = [[DKDependentModifier alloc] initWithSource:level
                                                                                           value:^int(int sourceValue) {
                                                                                               if (sourceValue <= 9) { return 0; }
                                                                                               else { return 1; }
                                                                                           }
                                                                                         enabled:^BOOL(int sourceValue) {
                                                                                             if (sourceValue <= 9) { return NO; }
                                                                                             else { return YES; }
                                                                                         }
                                                                                        priority:kDKModifierPriority_Additive                                                                                       block:[DKModifierBuilder simpleAdditionModifierBlock]];
    divineInterventionAbility.explanation = divineInterventionExplanation;
    [divineInterventionGroup addModifier:divineInterventionAbility forStatisticID:DKStatIDDivineIntervention];
    
    NSString* autoInterveneExplanation = @"Your call for intervention succeeds automatically, no roll required.";
    DKDependentModifier* autoInterveneAbility = [DKDependentModifierBuilder informationalModifierFromSource:level
                                                                                                  threshold:20
                                                                                                explanation:autoInterveneExplanation];
    [divineInterventionGroup addModifier:autoInterveneAbility forStatisticID:DKStatIDDivineIntervention];
    
    return divineInterventionGroup;
}

#pragma mark -

- (id)initWithAbilities:(DKAbilities5E*)abilities {
    
    self = [super init];
    if (self) {
        
        self.channelDivinityUsesMax = [DKStatistic statisticWithBase:0];
        self.channelDivinityUsesCurrent = [DKStatistic statisticWithBase:0];
        [_channelDivinityUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_channelDivinityUsesMax]];
        
        self.turnUndead = [DKStatistic statisticWithBase:0];
        self.divineIntervention = [DKStatistic statisticWithBase:0];
        
        self.classModifiers = [DKCleric5E clericWithLevel:self.classLevel abilities:abilities];
    }
    return self;
}

@end