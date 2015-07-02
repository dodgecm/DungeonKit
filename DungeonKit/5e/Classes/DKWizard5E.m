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
#import "DKAbilities5E.h"
#import "DKModifierBuilder.h"
#import "DKWeapon5E.h"

@implementation DKWizard5E

@synthesize arcaneRecoveryUsesCurrent = _arcaneRecoveryUsesCurrent;
@synthesize arcaneRecoveryUsesMax = _arcaneRecoveryUsesMax;
@synthesize arcaneRecoverySpellSlots = _arcaneRecoverySpellSlots;
@synthesize spellMasterySpells = _spellMasterySpells;
@synthesize signatureSpells = _signatureSpells;

+ (DKModifierGroup*)clericWithLevel:(DKNumericStatistic*)level abilities:(DKAbilities5E*)abilities {
    
    DKModifierGroup* class = [[DKModifierGroup alloc] init];
    class.explanation = @"Wizard class modifiers";
    
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
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:@"Channel Divinity" explanation:@"You have the ability to channel divine energy directly from your deity, using that energy to fuel magical effects.  When you use your Channel Divinity, you choose which effect to create.  You must then finish a short or long rest to use your Channel Divinity again."]
        forStatisticID:DKStatIDClericTraits];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:@"Ritual Casting" explanation:@"You can cast a wizard spell as a ritual if that spell has the ritual tag and you have the spell prepared"]
        forStatisticID:DKStatIDClericTraits];
    
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Wizard Saving Throw Proficiency: Wisdom"]
        forStatisticID:DKStatIDSavingThrowWisdomProficiency];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Wizard Saving Throw Proficiency: Intelligence"]
        forStatisticID:DKStatIDSavingThrowIntelligenceProficiency];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Dagger]
                                                         explanation:@"Wizard Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Dart]
                                                         explanation:@"Wizard Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Sling]
                                                         explanation:@"Wizard Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Quarterstaff]
                                                         explanation:@"Wizard Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_LightCrossbow]
                                                         explanation:@"Wizard Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    
    DKModifierGroup* skillSubgroup = [[DKModifierGroup alloc] init];
    skillSubgroup.explanation = @"Wizard Skill Proficiencies: Choose two from Arcana, History, Insight, Investigation, Medicine, and Religion";
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Wizard Skill Proficiency: History (default)"]
                forStatisticID:DKStatIDSkillHistoryProficiency];
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Wizard Skill Proficiency: Arcana (default)"]
                forStatisticID:DKStatIDSkillArcanaProficiency];
    [class addSubgroup:skillSubgroup];
    
    DKModifierGroup* arcaneRecoveryGroup = [DKWizard5E arcaneRecoveryWithWizardLevel:level];
    [class addSubgroup:arcaneRecoveryGroup];
    
    DKModifierGroup* spellMasteryGroup = [DKWizard5E spellMasteryWithWizardLevel:level];
    [class addSubgroup:spellMasteryGroup];
    
    DKModifierGroup* signatureSpellsGroup = [DKWizard5E signatureSpellsWithWizardLevel:level];
    [class addSubgroup:signatureSpellsGroup];
    
    NSArray* abilityScoreImprovementLevels = @[ @4, @8, @12, @16, @19];
    for (NSNumber* abilityScoreLevel in abilityScoreImprovementLevels) {
        DKModifierGroup* abilityScoreGroup = [DKClass5E abilityScoreImprovementForThreshold:abilityScoreLevel.integerValue level:level];
        [class addSubgroup:abilityScoreGroup];
    }
    
    return class;
}

+ (DKModifierGroup*)arcaneRecoveryWithWizardLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* arcaneRecoveryGroup = [[DKModifierGroup alloc] init];
    arcaneRecoveryGroup.explanation = @"Arcane Recovery ability";
    
    NSString* arcaneRecoveryExplanation = @"Once per day when you finish a short rest, you can choose expended spell slots to recover. The spell slots cannot be 6th level or higher.  For example, if you’re a 4th-level wizard, you can recover up to two levels worth of spell slots. You can recover either a 2nd-level spell slot or two 1st-level spell slots.";
    DKDependentModifier* arcaneRecoveryAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                         constantValue:@"Arcane Recovery"
                                                                                               enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                        isGreaterThanOrEqualTo:1]
                                                                                           explanation:arcaneRecoveryExplanation];
    [arcaneRecoveryGroup addModifier:arcaneRecoveryAbility forStatisticID:DKStatIDWizardTraits];
    
    DKDependentModifier* arcaneRecoveryUses = [DKDependentModifierBuilder addedNumberFromSource:level
                                                                                  constantValue:@1
                                                                                        enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                 isGreaterThanOrEqualTo:1]
                                                                                    explanation:@"Once per day when you finish a short rest, you can choose expended spell slots to recover."];
    [arcaneRecoveryGroup addModifier:arcaneRecoveryUses forStatisticID:DKStatIDArcaneRecoveryUsesMax];
    
    NSExpression* divisionExpression = [NSExpression expressionForFunction:@"divide:by:" arguments:@[[NSExpression expressionForVariable:@"source"], [NSExpression expressionForConstantValue:@2]]];
    NSExpression* roundUpExpression = [NSExpression expressionForFunction:@"ceiling:" arguments:@[divisionExpression]];
    DKDependentModifier* arcaneRecoverySlots = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                                value:roundUpExpression
                                                                                              enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                       isGreaterThanOrEqualTo:1]
                                                                                          explanation:@"The spell slots can have a combined level that is equal to or less than half your wizard level (rounded up)."];
    [arcaneRecoveryGroup addModifier:arcaneRecoverySlots forStatisticID:DKStatIDArcaneRecoverySpellSlots];
    
    return arcaneRecoveryGroup;
}

+ (DKModifierGroup*)spellMasteryWithWizardLevel:(DKNumericStatistic*)level {

    DKModifierGroup* spellMasteryGroup = [[DKModifierGroup alloc] init];
    spellMasteryGroup.explanation = @"Spell Mastery ability";
    
    NSString* spellMasteryExplanation = @"Choose a 1st-level wizard spell and a 2nd-level wizard spell that are in your spellbook. You can cast those spells at their lowest level without expending a spell slot when you have them prepared. If you want to cast either spell at a higher level, you must expend a spell slot as normal.  By spending 8 hours in study, you can exchange one or both of the spells you chose for different spells of the same levels.";
    DKDependentModifier* spellMasteryAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                          constantValue:@"Spell Mastery"
                                                                                                enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                         isGreaterThanOrEqualTo:18]
                                                                                            explanation:spellMasteryExplanation];
    [spellMasteryGroup addModifier:spellMasteryAbility forStatisticID:DKStatIDWizardTraits];
    
    DKDependentModifier* firstLevelSpell = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                       constantValue:@"1st-level spell Placeholder"
                                                                                             enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                      isGreaterThanOrEqualTo:18]
                                                                                         explanation:@"Choose a 1st-level wizard spell that is in your spellbook."];
    [spellMasteryGroup addModifier:firstLevelSpell forStatisticID:DKStatIDSpellMasterySpells];
    
    DKDependentModifier* secondLevelSpell = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                     constantValue:@"2nd-level spell Placeholder"
                                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                    isGreaterThanOrEqualTo:18]
                                                                                       explanation:@"Choose a 2nd-level wizard spell that is in your spellbook."];
    [spellMasteryGroup addModifier:secondLevelSpell forStatisticID:DKStatIDSpellMasterySpells];
    
    return spellMasteryGroup;
}

+ (DKModifierGroup*)signatureSpellsWithWizardLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* signatureSpellsGroup = [[DKModifierGroup alloc] init];
    signatureSpellsGroup.explanation = @"Signature Spells ability";
    
    NSString* signatureSpellsExplanation = @"Choose two 3rd-level wizard spells in your spellbook as your signature spells. You always have these spells prepared, they don’t count against the number of spells you have prepared, and you can cast each of them once at 3rd level without expending a spell slot. When you do so, you can’t do so again until you finish a short or long rest.  If you want to cast either spell at a higher level, you must expend a spell slot as normal.";
    DKDependentModifier* signatureSpellsAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                        constantValue:@"Signature Spells"
                                                                                              enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                       isGreaterThanOrEqualTo:20]
                                                                                          explanation:signatureSpellsExplanation];
    [signatureSpellsGroup addModifier:signatureSpellsAbility forStatisticID:DKStatIDWizardTraits];
    
    DKDependentModifier* thirdLevelSpell = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                    constantValue:@"3rd-level spell Placeholder"
                                                                                          enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                   isGreaterThanOrEqualTo:20]
                                                                                      explanation:@"Choose a 3rd-level wizard spell in your spellbook as one of your signature spells."];
    [signatureSpellsGroup addModifier:thirdLevelSpell forStatisticID:DKStatIDSignatureSpells];
    
    DKDependentModifier* otherThirdLevelSpell = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                    constantValue:@"Other 3rd-level spell Placeholder"
                                                                                          enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                   isGreaterThanOrEqualTo:20]
                                                                                      explanation:@"Choose a 3rd-level wizard spell in your spellbook as one of your signature spells."];
    [signatureSpellsGroup addModifier:otherThirdLevelSpell forStatisticID:DKStatIDSignatureSpells];
    
    return signatureSpellsGroup;
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
             DKStatIDSignatureSpells: @"signatureSpells",
             };
}

- (void)loadStatistics {
    
    [super loadStatistics];
    self.arcaneRecoveryUsesCurrent = [DKNumericStatistic statisticWithInt:0];
    self.arcaneRecoveryUsesMax = [DKNumericStatistic statisticWithInt:0];
    self.arcaneRecoverySpellSlots = [DKNumericStatistic statisticWithInt:0];
    self.spellMasterySpells = [DKSetStatistic statisticWithEmptySet];
    self.signatureSpells = [DKSetStatistic statisticWithEmptySet];
}

- (void)loadModifiers {
    
    [super loadModifiers];
    [_arcaneRecoveryUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_arcaneRecoveryUsesMax]];
}

@end
