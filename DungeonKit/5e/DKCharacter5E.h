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
#import "DKClass5E.h"
#import "DKCleric5E.h"
#import "DKAbilities5E.h"
#import "DKSavingThrows5E.h"
#import "DKSkills5E.h"
#import "DKSpells5E.h"
#import "DKCurrency5E.h"

@interface DKCharacter5E : DKCharacter

@property (nonatomic, strong) DKStatistic* level;
@property (nonatomic, strong) DKRace5E* race;
@property (nonatomic, strong) DKSubrace5E* subrace;
@property (nonatomic, strong) DKClasses5E* classes;

@property (nonatomic, strong) DKStatistic* inspiration;
@property (nonatomic, strong) DKStatistic* proficiencyBonus;

@property (nonatomic, strong) DKAbilities5E* abilities;
@property (nonatomic, strong) DKSavingThrows5E* savingThrows;
@property (nonatomic, strong) DKSkills5E* skills;
@property (nonatomic, strong) DKSpells5E* spells;
@property (nonatomic, strong) DKCurrency5E* currency;

@property (nonatomic, strong) DKStatistic* hitPointsMax;
@property (nonatomic, strong) DKStatistic* hitPointsTemporary;
@property (nonatomic, strong) DKStatistic* hitPointsCurrent;
@property (nonatomic, strong) DKDice* hitDiceMax;
@property (nonatomic, strong) DKDice* hitDiceCurrent;

@property (nonatomic, strong) DKStatistic* armorClass;
@property (nonatomic, strong) DKStatistic* initiativeBonus;
@property (nonatomic, strong) DKStatistic* movementSpeed;
@property (nonatomic, strong) DKStatistic* darkvisionRange;

@property (nonatomic, strong) DKStatistic* deathSaveSuccesses;
@property (nonatomic, strong) DKStatistic* deathSaveFailures;

@property (nonatomic, strong) DKStatistic* weaponProficiencies;
@property (nonatomic, strong) DKStatistic* armorProficiencies;
@property (nonatomic, strong) DKStatistic* toolProficiencies;

@property (nonatomic, strong) DKStatistic* languages;

@property (nonatomic, strong) DKStatistic* resistances;
@property (nonatomic, strong) DKStatistic* immunities;

@property (nonatomic, strong) DKStatistic* otherTraits;

@end
