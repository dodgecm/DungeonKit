//
//  DKClasses5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/28/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKClasses5E.h"
#import "DKStatisticGroupIDs5E.h"
#import "DKCharacter5E.h"

@implementation DKClasses5E

@synthesize cleric = _cleric;
@synthesize fighter = _fighter;
@synthesize rogue = _rogue;
@synthesize wizard = _wizard;

- (id)initWithCharacter:(DKCharacter5E*)character {
    self = [super init];
    if (self) {
        
        self.cleric = [[DKCleric5E alloc] initWithAbilities:character.abilities];
        self.fighter = [[DKFighter5E alloc] initWithAbilities:character.abilities
                                                       skills:character.skills
                                                    equipment:character.equipment
                                             proficiencyBonus:character.proficiencyBonus];
        self.rogue = [[DKRogue5E alloc] initWithAbilities:character.abilities
                                                equipment:character.equipment
                                         proficiencyBonus:character.proficiencyBonus];
        self.wizard = [[DKWizard5E alloc] initWithAbilities:character.abilities];
    }
    return self;
}

- (NSDictionary*) statisticGroupKeyPaths {
    return @{
             DKStatisticGroupIDCleric: @"cleric",
             DKStatisticGroupIDFighter: @"fighter",
             DKStatisticGroupIDRogue: @"rogue",
             DKStatisticGroupIDWizard: @"wizard",
             };
}

@end