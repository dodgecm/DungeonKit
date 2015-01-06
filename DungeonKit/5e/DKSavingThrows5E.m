//
//  DKSavingThrows5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/6/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKSavingThrows5E.h"

@implementation DKSavingThrows5E

@synthesize strength = _strength;
@synthesize dexterity = _dexterity;
@synthesize constitution = _constitution;
@synthesize intelligence = _intelligence;
@synthesize wisdom = _wisdom;
@synthesize charisma = _charisma;

- (id)initWithAbilities:(DKAbilities5E*)abilities {
    self = [super init];
    if (self) {
        
        self.strength = [DKStatistic statisticWithBase:0];
        self.dexterity = [DKStatistic statisticWithBase:0];
        self.constitution = [DKStatistic statisticWithBase:0];
        self.intelligence = [DKStatistic statisticWithBase:0];
        self.wisdom = [DKStatistic statisticWithBase:0];
        self.charisma = [DKStatistic statisticWithBase:0];
        
        //Apply modifiers from the abilities block to the saving throws
        [_strength applyModifier:[abilities.strength modifierFromAbilityScore]];
        [_dexterity applyModifier:[abilities.dexterity modifierFromAbilityScore]];
        [_constitution applyModifier:[abilities.constitution modifierFromAbilityScore]];
        [_intelligence applyModifier:[abilities.intelligence modifierFromAbilityScore]];
        [_wisdom applyModifier:[abilities.wisdom modifierFromAbilityScore]];
        [_charisma applyModifier:[abilities.charisma modifierFromAbilityScore]];
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Saving throws - STR:%@ DEX:%@ CON:%@ INT:%@ WIS:%@ CHA:%@",
            _strength, _dexterity, _constitution, _intelligence, _wisdom, _charisma];
}

@end
