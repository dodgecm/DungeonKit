//
//  DKWizard5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 7/1/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKClass5E.h"

@interface DKWizard5E : DKClass5E

@property (nonatomic, strong) DKNumericStatistic* arcaneRecoveryUsesCurrent;
@property (nonatomic, strong) DKNumericStatistic* arcaneRecoveryUsesMax;
@property (nonatomic, strong) DKNumericStatistic* arcaneRecoverySpellSlots;
@property (nonatomic, strong) DKSetStatistic* spellMasterySpells;
@property (nonatomic, strong) DKSetStatistic* signatureSpells;

@end
