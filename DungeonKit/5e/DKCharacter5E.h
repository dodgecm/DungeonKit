//
//  DKCharacter5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/3/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCharacter.h"
#import "DKDice.h"
#import "DKStatisticIDs5E.h"
#import "DKModifierGroupIDs5E.h"
#import "DKRace5E.h"
#import "DKClasses5E.h"
#import "DKAbilities5E.h"
#import "DKSavingThrows5E.h"
#import "DKSkills5E.h"
#import "DKSpells5E.h"
#import "DKCurrency5E.h"

@interface DKCharacter5E : DKCharacter

@property (nonatomic, strong) DKNumericStatistic* level;
@property (nonatomic, strong) DKRace5E* race;
@property (nonatomic, strong) DKSubrace5E* subrace;
@property (nonatomic, strong) DKClasses5E* classes;

@property (nonatomic, strong) DKNumericStatistic* inspiration;
@property (nonatomic, strong) DKNumericStatistic* proficiencyBonus;

@property (nonatomic, strong) DKAbilities5E* abilities;
@property (nonatomic, strong) DKSavingThrows5E* savingThrows;
@property (nonatomic, strong) DKSkills5E* skills;
@property (nonatomic, strong) DKSpells5E* spells;
@property (nonatomic, strong) DKCurrency5E* currency;

@property (nonatomic, strong) DKNumericStatistic* hitPointsMax;
@property (nonatomic, strong) DKNumericStatistic* hitPointsTemporary;
@property (nonatomic, strong) DKNumericStatistic* hitPointsCurrent;
@property (nonatomic, strong) DKDice* hitDiceMax;
@property (nonatomic, strong) DKDice* hitDiceCurrent;

@property (nonatomic, strong) DKNumericStatistic* armorClass;
@property (nonatomic, strong) DKNumericStatistic* initiativeBonus;
@property (nonatomic, strong) DKNumericStatistic* movementSpeed;
@property (nonatomic, strong) DKNumericStatistic* darkvisionRange;

@property (nonatomic, strong) DKNumericStatistic* deathSaveSuccesses;
@property (nonatomic, strong) DKNumericStatistic* deathSaveFailures;

@property (nonatomic, strong) DKSetStatistic* weaponProficiencies;
@property (nonatomic, strong) DKSetStatistic* armorProficiencies;
@property (nonatomic, strong) DKSetStatistic* toolProficiencies;

@property (nonatomic, strong) DKSetStatistic* languages;

@property (nonatomic, strong) DKSetStatistic* resistances;
@property (nonatomic, strong) DKSetStatistic* immunities;

@property (nonatomic, strong) DKNumericStatistic* otherTraits;

@end
