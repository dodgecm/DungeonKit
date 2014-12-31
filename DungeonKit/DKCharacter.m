//
//  DKCharacter.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKCharacter.h"
#import "DKStatisticIdentifiers.h"

@implementation DKCharacter

@synthesize level = _level;
@synthesize abilities = _abilities;
@synthesize proficiencyBonus = _proficiencyBonus;
@synthesize armorClass = _armorClass;
@synthesize initiativeBonus = _initiativeBonus;
@synthesize movementSpeed = _movementSpeed;

static NSDictionary* keyPaths;

+ (void) buildKeyPaths {
    keyPaths = @{
                 DKStatIDLevel: @"level",
                 DKStatIDProficiencyBonus: @"proficiencyBonus",
                 DKStatIDArmorClass: @"armorClass",
                 DKStatIDInitiative: @"initiativeBonus",
                 DKStatIDMoveSpeed: @"movementSpeed",
                 
                 DKStatIDStrength: @"abilities.strength",
                 DKStatIDDexterity: @"abilities.dexterity",
                 DKStatIDConstitution: @"abilities.constitution",
                 DKStatIDIntelligence: @"abilities.intelligence",
                 DKStatIDWisdom: @"abilities.wisdom",
                 DKStatIDCharisma: @"abilities.charisma",
                 };
}

+ (NSArray*) allStatisticIDs {
    
    if (!keyPaths) {
        [DKCharacter buildKeyPaths];
    }
    return [keyPaths allKeys];
}

+ (NSArray*) allKeyPaths {
    
    if (!keyPaths) {
        [DKCharacter buildKeyPaths];
    }
    return [keyPaths allValues];
}

+ (NSString*) keyPathForStatisticID: (NSString*) statisticID {
    
    if (!statisticID) { return nil; }
    
    if (!keyPaths) {
        [DKCharacter buildKeyPaths];
    }
    return [keyPaths objectForKey:statisticID];
}

- (void)dealloc {
    for (NSString* keyPath in [DKCharacter allKeyPaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
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
        
        for (NSString* keyPath in [DKCharacter allKeyPaths]) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //One of our statistics got replaced, so transfer the modifiers from the old object to the new object
    DKStatistic* oldStat = change[@"old"];
    DKStatistic* newStat = change[@"new"];
    for (DKModifier* modifier in oldStat.modifiers) {
        [newStat applyModifier:modifier];
    }
}

- (DKStatistic*)statisticForID:(NSString*)statisticID {
    return [self valueForKeyPath:statisticID];
}

@end
