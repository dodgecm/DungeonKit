//
//  DKRogue5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 6/29/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKRogue5E.h"
#import "DKAbilities5E.h"
#import "DKEquipment5E.h"
#import "DKModifierBuilder.h"
#import "DKStatisticIDs5E.h"

@implementation DKRogue5E

@synthesize strokeOfLuckUsesCurrent = _strokeOfLuckUsesCurrent;
@synthesize strokeOfLuckUsesMax = _strokeOfLuckUsesMax;
@synthesize roguishArchetype = _roguishArchetype;

+ (DKModifierGroup*)rogueWithLevel:(DKNumericStatistic*)level
                         abilities:(DKAbilities5E*)abilities
                         equipment:(DKEquipment5E*)equipment
                  proficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    DKModifierGroup* class = [[DKModifierGroup alloc] init];
    class.explanation = @"Rogue class modifiers";
    
    [class addModifier:[DKClass5E hitDiceModifierForSides:8 level:level] forStatisticID:DKStatIDRogueHitDice];
    
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Rogue Saving Throw Proficiency: Dexterity"]
        forStatisticID:DKStatIDSavingThrowDexterityProficiency];
    [class addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Rogue Saving Throw Proficiency: Intelligence"]
        forStatisticID:DKStatIDSavingThrowIntelligenceProficiency];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeaponCategory:kDKWeaponCategory5E_Simple]
                                                         explanation:@"Rogue Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_HandCrossbow]
                                                         explanation:@"Rogue Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longsword]
                                                         explanation:@"Rogue Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Rapier]
                                                         explanation:@"Rogue Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortsword]
                                                         explanation:@"Rogue Weapon Proficiencies"]
        forStatisticID:DKStatIDWeaponProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Light]
                                                         explanation:@"Rogue Armor Proficiencies"]
        forStatisticID:DKStatIDArmorProficiencies];
    [class addModifier:[DKModifierBuilder modifierWithAppendedString:@"Thieves' tools"
                                                         explanation:@"Rogue Tool Proficiencies"]
        forStatisticID:DKStatIDToolProficiencies];
    
    DKModifierGroup* skillSubgroup = [[DKModifierGroup alloc] init];
    skillSubgroup.explanation = @"Rogue Skill Proficiencies: Choose two from Acrobatics, Athletics, Deception, Insight, Intimidation, Investigation, Perception, Performance, Persuasion, Sleight of Hand, and Stealth";
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Rogue Skill Proficiency: Deception (default)"]
                forStatisticID:DKStatIDSkillDeceptionProficiency];
    [skillSubgroup addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Rogue Skill Proficiency: Perception (default)"]
                forStatisticID:DKStatIDSkillPerceptionProficiency];
    [class addSubgroup:skillSubgroup];
    
    //Expertise
    DKModifierGroup* expertiseSubgroup = [[DKModifierGroup alloc] init];
    NSArray* statIDs = @[ DKStatIDSkillDeceptionProficiency, DKStatIDSkillPerceptionProficiency,
                          DKStatIDSkillSleightOfHandProficiency, DKStatIDSkillStealthProficiency];
    NSArray* statNames = @[ @"Deception", @"Perception", @"Sleight of Hand", @"Stealth"];
    NSArray* levelRequirements = @[ @1, @1, @6, @6];
    for (int i = 0; i < statIDs.count; i++) {
        DKModifier* expertiseSkill = [DKRogue5E expertiseModifierWithLevel:level levelRequirement:levelRequirements[i]];
        expertiseSkill.explanation = [NSString stringWithFormat:@"Rogue expertise in %@ (default)", statNames[i]];
        [expertiseSubgroup addModifier:expertiseSkill forStatisticID:statIDs[i]];
    }
    [class addSubgroup:expertiseSubgroup];
    
    //Sneak Attack
    DKModifierGroup* sneakAtatckSubgroup = [DKRogue5E sneakAttackModifierWithLevel:level equipment:equipment];
    [class addSubgroup:sneakAtatckSubgroup];
    
    //Thieves' Cant
    NSString* thievesCantExplanation = @"You know a secret mix of dialect, jargon, and code that allows you to hide messages in seemingly normal conversation. Only another creature that knows thieves’ cant understands such messages. It takes four times longer to convey such a message than it does to speak the same idea plainly.  In addition, you understand a set of secret signs and symbols used to convey short, simple messages, such as whether an area is dangerous or the territory of a thieves’ guild, whether loot is nearby, or whether the people in an area are easy marks or will provide a safe house for thieves on the run.";
    DKModifier* thievesCantModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                               constantValue:@"Thieves' Cant"
                                                                                     enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                              isGreaterThanOrEqualTo:1]
                                                                                 explanation:thievesCantExplanation];
    [class addModifier:thievesCantModifier forStatisticID:DKStatIDRogueTraits];
    
    //Cunning Action
    NSString* cunningActionExplanation = @"Your quick thinking and agility allow you to move and act quickly. You can take a bonus action on each of your turns in combat. This action can be used only to take the Dash, Disengage, or Hide action.";
    DKModifier* cunningActionModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                 constantValue:@"Cunning Action"
                                                                                       enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                isGreaterThanOrEqualTo:2]
                                                                                   explanation:cunningActionExplanation];
    [class addModifier:cunningActionModifier forStatisticID:DKStatIDRogueTraits];
    
    //Uncanny Dodge
    NSString* uncannyDodgeExplanation = @"When an attacker that you can see hits you with an attack, you can use your reaction to halve the attack’s damage against you.";
    DKModifier* uncannyDodgeModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                constantValue:@"Uncanny Dodge"
                                                                                      enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                               isGreaterThanOrEqualTo:5]
                                                                                  explanation:uncannyDodgeExplanation];
    [class addModifier:uncannyDodgeModifier forStatisticID:DKStatIDRogueTraits];
    
    //Evasion
    NSString* evasionExplanation = @"When you are subjected to an effect that allows you to make a Dexterity saving throw to take only half damage, you instead take no damage if you succeed on the saving throw, and only half damage if you fail.";
    DKModifier* evasionModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                           constantValue:@"Evasion"
                                                                                 enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                          isGreaterThanOrEqualTo:7]
                                                                             explanation:evasionExplanation];
    [class addModifier:evasionModifier forStatisticID:DKStatIDRogueTraits];
    
    //Reliable Talent
    NSString* reliableTalentExplanation = @"Whenever you make an ability check that lets you add your proficiency bonus, you can treat a d20 roll of 9 or lower as a 10.";
    DKModifier* reliableTalentModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                  constantValue:@"Reliable Talent"
                                                                                        enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                 isGreaterThanOrEqualTo:11]
                                                                                    explanation:reliableTalentExplanation];
    [class addModifier:reliableTalentModifier forStatisticID:DKStatIDRogueTraits];
    
    //Blindsense
    NSString* blindsenseExplanation = @"If you are able to hear, you are aware of the location of any hidden or invisible creature within 10 feet of you.";
    DKModifier* blindsenseModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                              constantValue:@"Blindsense"
                                                                                    enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                             isGreaterThanOrEqualTo:14]
                                                                                explanation:blindsenseExplanation];
    [class addModifier:blindsenseModifier forStatisticID:DKStatIDRogueTraits];
    
    //Slippery Mind
    DKModifier* slipperyMindModifier = [[DKDependentModifier alloc] initWithSource:level
                                                                             value:nil
                                                                           enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                    isGreaterThanOrEqualTo:15]
                                                                          priority:kDKModifierPriority_Clamping
                                                                        expression:[DKModifierBuilder simpleClampExpressionBetween:1 and:1]];
    slipperyMindModifier.explanation = @"Slippery Mind (Rogue)";
    [class addModifier:slipperyMindModifier forStatisticID:DKStatIDSavingThrowWisdomProficiency];
    
    //Elusive
    NSString* elusiveExplanation = @"No attack roll has advantage against you while you aren’t incapacitated.";
    DKModifier* elusiveModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                           constantValue:@"Elusive"
                                                                                 enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                          isGreaterThanOrEqualTo:18]
                                                                             explanation:elusiveExplanation];
    [class addModifier:elusiveModifier forStatisticID:DKStatIDRogueTraits];
    
    NSString* strokeOfLuckExplanation = @"If your attack misses a target within range, you can turn the miss into a hit. Alternatively, if you fail an ability check, you can treat the d20 roll as a 20.";
    DKModifier* strokeOfLuckAbility = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                               constantValue:@"Stroke of Luck"
                                                                                     enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                              isGreaterThanOrEqualTo:20]
                                                                                 explanation:strokeOfLuckExplanation];
    [class addModifier:strokeOfLuckAbility forStatisticID:DKStatIDRogueTraits];
    
    DKModifier* strokeOfLuckModifier = [DKDependentModifierBuilder addedNumberFromSource:level
                                                                           constantValue:@1
                                                                                 enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                          isGreaterThanOrEqualTo:20]
                                                                             explanation:@"Once you use this feature, you can’t use it again until you finish a short or long rest."];
    [class addModifier:strokeOfLuckModifier forStatisticID:DKStatIDStrokeOfLuckUsesMax];

    NSArray* abilityScoreImprovementLevels = @[ @4, @8, @10, @12, @16, @19];
    for (NSNumber* abilityScoreLevel in abilityScoreImprovementLevels) {
        DKModifierGroup* abilityScoreGroup = [DKClass5E abilityScoreImprovementForThreshold:abilityScoreLevel.integerValue level:level];
        [class addSubgroup:abilityScoreGroup];
    }
    
    return class;
}

+ (DKModifier*)expertiseModifierWithLevel:(DKNumericStatistic*)level
                         levelRequirement:(NSNumber*)enabledLevel {
    return [[DKDependentModifier alloc] initWithDependencies:@{ @"level" : level }
                                                       value:nil
                                                     enabled:[DKDependentModifierBuilder enabledWhen:@"level"
                                                                              isGreaterThanOrEqualTo:enabledLevel.integerValue]
                                                    priority:kDKModifierPriority_Clamping
                                                  expression:[DKModifierBuilder simpleClampExpressionBetween:2 and:2]];
}

+ (DKModifierGroup*)sneakAttackModifierWithLevel:(DKNumericStatistic*)level
                                  equipment:(DKEquipment5E*)equipment {
    
    DKModifierGroup* sneakAttackGroup = [[DKModifierGroup alloc] init];
    sneakAttackGroup.explanation = @"Sneak Attack";
    
    NSMutableDictionary* piecewiseFunction = [NSMutableDictionary dictionary];
    for (int i = 1; i <= 20; i += 2) {
        //Starts at 1d6 for levels 1 and 2, increases by d6 every two levels afterwards
        piecewiseFunction[[DKDependentModifierBuilder rangeValueWithMin:i max:i+1]] =
            [DKDiceCollection diceCollectionWithQuantity:ceil(i/2.0) sides:6 modifier:0];
    }
    NSExpression* sneakAttackValue = [DKDependentModifierBuilder valueFromPiecewiseFunctionRanges:piecewiseFunction
                                                                                     usingDependency:@"source"];
    NSPredicate* levelPredicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:1];
    NSPredicate* finesseWeaponPredicate = [DKDependentModifierBuilder enabledWhen:@"weapon" containsObject:@"Finesse"];
    NSPredicate* rangedWeaponPredicate = [DKDependentModifierBuilder enabledWhen:@"weapon" containsObject:@"Ranged"];
    NSPredicate* weaponPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:@[finesseWeaponPredicate, rangedWeaponPredicate]];
    NSPredicate* enabledPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[levelPredicate, weaponPredicate]];
    
    DKModifier* mainHandModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"source" : level,
                                                                                        @"weapon" : equipment.mainHandWeaponAttributes }
                                                                               value:sneakAttackValue
                                                                             enabled:enabledPredicate
                                                                            priority:kDKModifierPriority_Additive
                                                                          expression:[DKModifierBuilder simpleAddDiceModifierExpression]];
    mainHandModifier.explanation = @"In order to deal Sneak Attack damage, you must have advantage on the attack roll.  You don’t need advantage on the attack roll if another enemy of the target is within 5 feet of it, that enemy isn’t incapacitated, and you don’t have disadvantage on the attack roll.  Sneak attack damage can only be dealt once per turn.";
    [sneakAttackGroup addModifier:mainHandModifier forStatisticID:DKStatIDMainHandWeaponDamage];
    
    DKModifier* offHandModifier = [[DKDependentModifier alloc] initWithDependencies:@{ @"source" : level,
                                                                                       @"weapon" : equipment.offHandWeaponAttributes }
                                                                              value:[sneakAttackValue copy]
                                                                            enabled:[enabledPredicate copy]
                                                                           priority:kDKModifierPriority_Additive
                                                                         expression:[DKModifierBuilder simpleAddDiceModifierExpression]];
    [sneakAttackGroup addModifier:offHandModifier forStatisticID:DKStatIDOffHandWeaponDamage];
    offHandModifier.explanation = @"In order to deal Sneak Attack damage, you must have advantage on the attack roll.  You don’t need advantage on the attack roll if another enemy of the target is within 5 feet of it, that enemy isn’t incapacitated, and you don’t have disadvantage on the attack roll.  Sneak attack damage can only be dealt once per turn.";
    
    return sneakAttackGroup;
}

#pragma mark -

+ (DKModifierGroup*)thiefRoguishArchetypeWithLevel:(DKNumericStatistic*)level {
    
    DKModifierGroup* thiefGroup = [[DKModifierGroup alloc] init];
    thiefGroup.explanation = @"Thief roguish archetype";
    
    //Fast Hands
    NSString* fastHandsExplanation = @"You can use the bonus action granted by your Cunning Action to make a Dexterity (Sleight of Hand) check, use your thieves’ tools to disarm a trap or open a lock, or take the Use an Object action.";
    DKModifier* fastHandsModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                           constantValue:@"Fast Hands"
                                                                                 enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                          isGreaterThanOrEqualTo:3]
                                                                             explanation:fastHandsExplanation];
    [thiefGroup addModifier:fastHandsModifier forStatisticID:DKStatIDRogueTraits];
    
    //Second-Story Work
    NSString* secondStoryWorkExplanation = @"You gain the ability to climb faster than normal; climbing no longer costs you extra movement.  In addition, when you make a running jump, the distance you cover increases by a number of feet equal to your Dexterity modifier.";
    DKModifier* secondStoryWorkModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                             constantValue:@"Second-Story Work"
                                                                                   enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                            isGreaterThanOrEqualTo:3]
                                                                               explanation:secondStoryWorkExplanation];
    [thiefGroup addModifier:secondStoryWorkModifier forStatisticID:DKStatIDRogueTraits];
    
    //Supreme Sneak
    NSString* supremeSneakExplanation = @"You have advantage on a Stealth check if you move no more than half your speed on the same turn.";
    DKModifier* supremeSneakModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                   constantValue:@"Supreme Sneak"
                                                                                         enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                  isGreaterThanOrEqualTo:9]
                                                                                     explanation:supremeSneakExplanation];
    [thiefGroup addModifier:supremeSneakModifier forStatisticID:DKStatIDRogueTraits];
    [thiefGroup addModifier:[DKModifierBuilder modifierWithExplanation:supremeSneakExplanation] forStatisticID:DKStatIDSkillStealth];
    
    //Use Magic Device
    NSString* useMagicDeviceExplanation = @"You can improvise the use of items even when they are not intended for you. You ignore all class, race, and level requirements on the use of magic items.";
    DKModifier* useMagicDeviceModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                   constantValue:@"Use Magic Device"
                                                                                         enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                  isGreaterThanOrEqualTo:13]
                                                                                     explanation:useMagicDeviceExplanation];
    [thiefGroup addModifier:useMagicDeviceModifier forStatisticID:DKStatIDRogueTraits];
    
    //Thief's Reflexes
    NSString* thiefReflexesExplanation = @"You can take two turns during the first round of any combat. You take your first turn at your normal initiative and your second turn at your initiative minus 10. You can’t use this feature when you are surprised.";
    DKModifier* thiefReflexesModifier = [DKDependentModifierBuilder appendedModifierFromSource:level
                                                                                  constantValue:@"Thief's Reflexes"
                                                                                        enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                 isGreaterThanOrEqualTo:17]
                                                                                    explanation:thiefReflexesExplanation];
    [thiefGroup addModifier:thiefReflexesModifier forStatisticID:DKStatIDRogueTraits];
    
    return thiefGroup;
}

#pragma mark -

- (id)initWithAbilities:(DKAbilities5E*)abilities
              equipment:(DKEquipment5E*)equipment
       proficiencyBonus:(DKNumericStatistic*)proficiencyBonus {
    
    self = [super init];
    if (self) {
        
        self.classModifiers = [DKRogue5E rogueWithLevel:self.classLevel
                                              abilities:abilities
                                              equipment:equipment
                                       proficiencyBonus:proficiencyBonus];
        [self.classModifiers addModifier:[DKDependentModifierBuilder addedDiceModifierFromSource:self.classHitDice
                                                                                     explanation:@"Rogue hit dice"] forStatisticID:DKStatIDHitDiceMax];
        
        self.roguishArchetype = [DKRogue5E thiefRoguishArchetypeWithLevel:self.classLevel];
    }
    return self;
}

- (NSDictionary*) statisticKeyPaths {
    return @{
             DKStatIDRogueLevel: @"classLevel",
             DKStatIDRogueTraits: @"classTraits",
             DKStatIDRogueHitDice: @"classHitDice",
             DKStatIDStrokeOfLuckUsesCurrent: @"strokeOfLuckUsesCurrent",
             DKStatIDStrokeOfLuckUsesMax: @"strokeOfLuckUsesMax",
             };
}

- (void)loadStatistics {
    
    [super loadStatistics];
    self.strokeOfLuckUsesCurrent = [DKNumericStatistic statisticWithInt:0];
    self.strokeOfLuckUsesMax = [DKNumericStatistic statisticWithInt:0];
}

- (void)loadModifiers {
    
    [super loadModifiers];
    [_strokeOfLuckUsesCurrent applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:_strokeOfLuckUsesMax]];
}

@end
