//
//  DKCharacter5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/3/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCharacter5E.h"

@implementation DKCharacter5E

@synthesize level = _level;
@synthesize abilities = _abilities;
@synthesize proficiencyBonus = _proficiencyBonus;
@synthesize armorClass = _armorClass;
@synthesize initiativeBonus = _initiativeBonus;
@synthesize movementSpeed = _movementSpeed;

+ (NSDictionary*) buildKeyPaths {
    return @{
             DKStatIDLevel: @"level",
             DKStatIDProficiencyBonus: @"proficiencyBonus",
             DKStatIDArmorClass: @"armorClass",
             DKStatIDInitiative: @"initiativeBonus",
             DKStatIDMoveSpeed: @"movementSpeed",
             
             DKStatIDStrength: @"abilities.strength",
             DKStatIDDexterity: @"abilities.dexterity",
             //DKStatIDConstitution: @"abilities.constitution",
             DKStatIDIntelligence: @"abilities.intelligence",
             DKStatIDWisdom: @"abilities.wisdom",
             DKStatIDCharisma: @"abilities.charisma",
             };
}

- (id)init {
    self = [super init];
    if (self) {
        
        self.level = [DKStatistic statisticWithBase:1];
        self.proficiencyBonus = [DKStatistic statisticWithBase:2];
        self.abilities = [[DKAbilities alloc] initWithStr:12 dex:12 con:12 intel:12 wis:12 cha:12];
        self.armorClass = [DKStatistic statisticWithBase:10];
        self.initiativeBonus = [DKStatistic statisticWithBase:0];
        self.movementSpeed = [DKStatistic statisticWithBase:0];
    }
    return self;
}

@end
