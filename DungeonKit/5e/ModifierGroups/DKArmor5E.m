//
//  DKArmor5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 6/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKArmor5E.h"
#import "DKAbilities5E.h"
#import "DKCharacter5E.h"
#import "DKModifierBuilder.h"
#import "DKStatisticIDs5E.h"

@implementation DKArmorBuilder5E

+ (DKModifierGroup*)armorProficiencyPenaltiesForArmorName:(NSString*)name
                                         proficiencyTypes:(NSArray*)proficiencyTypes
                                       armorProficiencies:(DKSetStatistic*)armorProficiencies {
    
    DKModifierGroup* penalties = [[DKModifierGroup alloc] init];
    penalties.explanation = @"Non-proficient armor penalties";
    
    NSDictionary* dependencies = @{ @"proficiencies" : armorProficiencies };
    DKDependentModifier* defaultPenalty = [[DKDependentModifier alloc] initWithDependencies:dependencies
                                                                                      value:nil
                                                                                    enabled:[DKDependentModifierBuilder enabledWhen:@"proficiencies"doesNotContainAnyFromObjects:proficiencyTypes]
                                                                                   priority:kDKModifierPriority_Informational
                                                                                 expression:nil];
    
    NSArray* descriptions = @[@"strength saving throws",
                              @"dexterity saving throws",
                              @"acrobatics checks",
                              @"athletics checks",
                              @"sleight of hand checks",
                              @"stealth checks"];
    NSArray* statIDs = @[DKStatIDSavingThrowStrength,
                         DKStatIDSavingThrowDexterity,
                         DKStatIDSkillAcrobatics,
                         DKStatIDSkillAthletics,
                         DKStatIDSkillSleightOfHand,
                         DKStatIDSkillStealth];
    
    for (int i = 0; i < statIDs.count; i++) {
        
        NSString* description = descriptions[i];
        NSString* statID = statIDs[i];
        DKModifier* penaltyModifier = [defaultPenalty copy];
        penaltyModifier.explanation = [NSString stringWithFormat:@"Disadvantage on %@ while wearing armor (%@) that you are not proficient with.", description, name];
        [penalties addModifier:penaltyModifier forStatisticID:statID];
    }
    
    DKDependentModifier* clampPenalty = [[DKDependentModifier alloc] initWithDependencies:dependencies
                                                                                      value:[DKDependentModifierBuilder expressionForConstantInteger:0]
                                                                                    enabled:[DKDependentModifierBuilder enabledWhen:@"proficiencies"doesNotContainAnyFromObjects:proficiencyTypes]
                                                                                   priority:kDKModifierPriority_Clamping
                                                                                 expression:[DKModifierBuilder simpleClampExpressionBetween:0 and:0]];
    statIDs = @[DKStatIDFirstLevelSpellSlotsCurrent,
                DKStatIDSecondLevelSpellSlotsCurrent,
                DKStatIDThirdLevelSpellSlotsCurrent,
                DKStatIDFourthLevelSpellSlotsCurrent,
                DKStatIDFifthLevelSpellSlotsCurrent,
                DKStatIDSixthLevelSpellSlotsCurrent,
                DKStatIDSeventhLevelSpellSlotsCurrent,
                DKStatIDEighthLevelSpellSlotsCurrent,
                DKStatIDNinthLevelSpellSlotsCurrent];
    
    for (NSString* statID in statIDs) {
        
        DKModifier* penaltyModifier = [clampPenalty copy];
        penaltyModifier.explanation = [NSString stringWithFormat:@"Cannot cast spells while wearing armor (%@) that you are not proficient with.", name];
        [penalties addModifier:penaltyModifier forStatisticID:statID];
    }
    
    return penalties;
}

+ (DKArmor5E*)armorWithName:(NSString*)name
                     baseAC:(NSNumber*)baseAC
           proficiencyTypes:(NSArray*)proficiencyTypes
               addDexterity:(BOOL)addDex
          dexterityBonusCap:(NSNumber*)dexBonusCap
            strengthMinimum:(NSNumber*)strMinimum
        stealthDisadvantage:(BOOL)stealthDisadvantage
                  abilities:(DKAbilities5E*)abilities
         armorProficiencies:(DKSetStatistic*)armorProficiencies {
    
    DKArmor5E* armor = [[DKArmor5E alloc] init];
    armor.explanation = [name copy];

    [armor addModifier:[DKModifierBuilder modifierWithAdditiveBonus:baseAC.integerValue - 10
                                                        explanation:[NSString stringWithFormat:@"%@ base AC", name]] forStatisticID:DKStatIDArmorClass];
    
    //Armor proficiency
    if (proficiencyTypes.count > 0) {
        [armor addSubgroup:[DKArmorBuilder5E armorProficiencyPenaltiesForArmorName:name
                                                                  proficiencyTypes:proficiencyTypes
                                                                armorProficiencies:armorProficiencies]];
    }
    
    //Dexterity bonus to AC
    if (addDex) {
        if ([dexBonusCap integerValue] > 0) {
            
            NSExpression* valueExpression = [NSExpression expressionForFunction:@"min:"
                                                                      arguments:@[
                                                                                  [NSExpression expressionForAggregate:@[
                                                                                                                         [NSExpression expressionForConstantValue:dexBonusCap],
                                                                                                                          [DKAbilityScore abilityScoreValueForDependency:@"source"]
                                                                                                                         ]]
                                                                                  ]];
            DKModifier* dexBonusModifier = [[DKDependentModifier alloc] initWithSource:abilities.dexterity
                                                                                 value:valueExpression
                                                                              priority:kDKModifierPriority_Additive
                                                                            expression:[DKModifierBuilder simpleAdditionModifierExpression]];
            dexBonusModifier.explanation = [NSString stringWithFormat:@"%@ dexterity bonus", name];
            [armor addModifier:dexBonusModifier forStatisticID:DKStatIDArmorClass];
            
        } else {
            [armor addModifier:[abilities.dexterity modifierFromAbilityScoreWithExplanation:[NSString stringWithFormat:@"%@ dexterity bonus", name]]
                forStatisticID:DKStatIDArmorClass];
        }
    }
    
    if (strMinimum) {
        
        DKModifier* moveSpeedPenaltyModifier = [[DKDependentModifier alloc] initWithSource:abilities.strength
                                                                                     value:[DKDependentModifierBuilder expressionForConstantInteger:-10]
                                                                                   enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                                        isLessThan:strMinimum.integerValue]
                                                                                  priority:kDKModifierPriority_Additive
                                                                                expression:[DKModifierBuilder simpleAdditionModifierExpression]];
        moveSpeedPenaltyModifier.explanation = [NSString stringWithFormat:@"%@ reduces move speed by 10 if you are below %@ strength.", name, strMinimum];
        [armor addModifier:moveSpeedPenaltyModifier forStatisticID:DKStatIDMoveSpeed];
    }
    
    if (stealthDisadvantage) {
        
        [armor addModifier:[DKModifierBuilder modifierWithExplanation:
                            [NSString stringWithFormat:@"While wearing %@, you have disadvantage on Stealth checks.", name]]
            forStatisticID:DKStatIDSkillStealth];
    }
    
    return armor;
}

+ (DKArmor5E*)armorOfType:(DKArmorType5E)type
             forCharacter:(DKCharacter5E*)character {
    
    return [DKArmorBuilder5E armorOfType:type
                               abilities:character.abilities
                      armorProficiencies:character.armorProficiencies];
}

+ (DKArmor5E*)armorOfType:(DKArmorType5E)type
                abilities:(DKAbilities5E*)abilities
       armorProficiencies:(DKSetStatistic*)armorProficiencies {
    
    switch (type) {
            
        case kDKArmorType5E_Unarmored: {
            return [DKArmorBuilder5E armorWithName:@"Unarmored"
                                            baseAC:@10
                                  proficiencyTypes:@[]
                                      addDexterity:YES
                                 dexterityBonusCap:nil
                                   strengthMinimum:nil
                               stealthDisadvantage:NO
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_Padded: {
            return [DKArmorBuilder5E armorWithName:@"Padded"
                                            baseAC:@11
                                  proficiencyTypes:@[@"Light Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:nil
                                   strengthMinimum:nil
                               stealthDisadvantage:YES
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_Leather: {
            return [DKArmorBuilder5E armorWithName:@"Leather"
                                            baseAC:@11
                                  proficiencyTypes:@[@"Light Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:nil
                                   strengthMinimum:nil
                               stealthDisadvantage:NO
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_StuddedLeather: {
            return [DKArmorBuilder5E armorWithName:@"Studded Leather"
                                            baseAC:@12
                                  proficiencyTypes:@[@"Light Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:nil
                                   strengthMinimum:nil
                               stealthDisadvantage:NO
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_Hide: {
            return [DKArmorBuilder5E armorWithName:@"Hide"
                                            baseAC:@12
                                  proficiencyTypes:@[@"Medium Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:@2
                                   strengthMinimum:nil
                               stealthDisadvantage:NO
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_ChainShirt: {
            return [DKArmorBuilder5E armorWithName:@"Chain Shirt"
                                            baseAC:@13
                                  proficiencyTypes:@[@"Medium Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:@2
                                   strengthMinimum:nil
                               stealthDisadvantage:NO
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_ScaleMail: {
            return [DKArmorBuilder5E armorWithName:@"Scale Mail"
                                            baseAC:@14
                                  proficiencyTypes:@[@"Medium Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:@2
                                   strengthMinimum:nil
                               stealthDisadvantage:YES
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_Breastplate: {
            return [DKArmorBuilder5E armorWithName:@"Breastplate"
                                            baseAC:@14
                                  proficiencyTypes:@[@"Medium Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:@2
                                   strengthMinimum:nil
                               stealthDisadvantage:NO
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_HalfPlate: {
            return [DKArmorBuilder5E armorWithName:@"Half Plate"
                                            baseAC:@15
                                  proficiencyTypes:@[@"Medium Armor"]
                                      addDexterity:YES
                                 dexterityBonusCap:@2
                                   strengthMinimum:nil
                               stealthDisadvantage:YES
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_RingMail: {
            return [DKArmorBuilder5E armorWithName:@"Ring Mail"
                                            baseAC:@14
                                  proficiencyTypes:@[@"Heavy Armor"]
                                      addDexterity:NO
                                 dexterityBonusCap:nil
                                   strengthMinimum:nil
                               stealthDisadvantage:YES
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_ChainMail: {
            return [DKArmorBuilder5E armorWithName:@"Chain Mail"
                                            baseAC:@16
                                  proficiencyTypes:@[@"Heavy Armor"]
                                      addDexterity:NO
                                 dexterityBonusCap:nil
                                   strengthMinimum:@13
                               stealthDisadvantage:YES
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_Splint: {
            return [DKArmorBuilder5E armorWithName:@"Splint"
                                            baseAC:@17
                                  proficiencyTypes:@[@"Heavy Armor"]
                                      addDexterity:NO
                                 dexterityBonusCap:nil
                                   strengthMinimum:@15
                               stealthDisadvantage:YES
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        case kDKArmorType5E_Plate: {
            return [DKArmorBuilder5E armorWithName:@"Plate"
                                            baseAC:@18
                                  proficiencyTypes:@[@"Heavy Armor"]
                                      addDexterity:NO
                                 dexterityBonusCap:nil
                                   strengthMinimum:@15
                               stealthDisadvantage:YES
                                         abilities:abilities
                                armorProficiencies:armorProficiencies];
            break;
        }
            
        default:
            break;
    }
    
    return nil;
}

+ (DKArmor5E*)shieldWithEquipment:(DKEquipment5E*)equipment
               armorProficiencies:(DKSetStatistic*)armorProficiencies {
    
    DKArmor5E* shield = [[DKArmor5E alloc] init];
    shield.explanation = @"Shield";
    
    //Shield is worn on the offhand
    [shield addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDOffHandOccupied];
    
    //+2 to AC only when off hand does not have a weapon equipped
    [shield addModifier:[[DKDependentModifier alloc] initWithSource:equipment.offHandOccupied
                                                              value:[DKDependentModifierBuilder expressionForConstantInteger:2]
                                                            enabled:[DKDependentModifierBuilder enabledWhen:@"source" isLessThan:2]
                                                           priority:kDKModifierPriority_Additive
                                                         expression:[DKModifierBuilder simpleAdditionModifierExpression]]
         forStatisticID:DKStatIDArmorClass];
    
    DKModifierGroup* proficiencyPenalties = [DKArmorBuilder5E armorProficiencyPenaltiesForArmorName:@"Shield"
                                                                                   proficiencyTypes:@[@"Shields"]
                                                                                 armorProficiencies:armorProficiencies];
    [shield addSubgroup:proficiencyPenalties];
    
    return shield;
}

@end
