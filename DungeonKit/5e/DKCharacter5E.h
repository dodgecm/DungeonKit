//
//  DKCharacter5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/3/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCharacter.h"
#import "DKStatisticIdentifiers5E.h"
#import "DKAbilities5E.h"
#import "DKSavingThrows5E.h"

@interface DKCharacter5E : DKCharacter

@property (nonatomic, strong) DKStatistic* level;
@property (nonatomic, strong) DKStatistic* proficiencyBonus;

@property (nonatomic, strong) DKAbilities5E* abilities;
@property (nonatomic, strong) DKSavingThrows5E* savingThrows;

@property (nonatomic, strong) DKStatistic* armorClass;
@property (nonatomic, strong) DKStatistic* initiativeBonus;
@property (nonatomic, strong) DKStatistic* movementSpeed;

@end
