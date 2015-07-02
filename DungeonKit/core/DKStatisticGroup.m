//
//  DKCharacter.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKStatisticGroup.h"
#import "DKStatisticIDs5E.h"
#import "DKConstants.h"


@interface DKStatisticGroup()
@property (nonatomic, strong) NSMutableDictionary* statistics;
@property (nonatomic, strong) NSMutableDictionary* statisticGroups;
@property (nonatomic, strong) NSMutableDictionary* modifierGroups;
@end

@implementation DKStatisticGroup

@synthesize owner = _owner;
@synthesize statistics = _statistics;
@synthesize statisticGroups = _statisticGroups;
@synthesize modifierGroups = _modifierGroups;

static void* const DKCharacterStatisticKVOContext = (void*)&DKCharacterStatisticKVOContext;
static void* const DKCharacterStatisticGroupKVOContext = (void*)&DKCharacterStatisticGroupKVOContext;
static void* const DKCharacterModifierGroupKVOContext = (void*)&DKCharacterModifierGroupKVOContext;

- (void)dealloc {

    NSArray* dictionaries = @[_statistics, _modifierGroups, _statisticGroups];
    for (NSDictionary* dictionary in dictionaries) {
        for (id object in [dictionary allValues]) {
            if ([object isKindOfClass:[NSString class]]) {
                NSString* keyPath = (NSString*)object;
                [self removeObserver:self forKeyPath:keyPath];
            }
        }
    }
}

- (id)init {
    self = [super init];
    if (self) {
        
        _statistics = [NSMutableDictionary dictionary];
        _statisticGroups = [NSMutableDictionary dictionary];
        _modifierGroups = [NSMutableDictionary dictionary];
    }
    return self;
}

- (DKStatistic*)statisticForID:(NSString*)statID {
    if (!statID) { return nil; }
    id statOrKeyPath = [_statistics objectForKey:statID];
    if ([statOrKeyPath isKindOfClass:[NSString class]]) {
        NSString* keyPath = (NSString*)statOrKeyPath;
        return [self valueForKeyPath:keyPath];
    }
    else if ([statOrKeyPath isKindOfClass:[DKNumericStatistic class]]) {
        return statOrKeyPath;
    } else {
        for (NSString* subgroupId in _statisticGroups.allKeys) {
            DKStatisticGroup* subgroup = [self statisticGroupForID:subgroupId];
            DKStatistic* subgroupStat = [subgroup statisticForID:statID];
            if (subgroupStat) { return subgroupStat; }
        }
        return nil;
    }
}

- (void)addKeyPath:(NSString*)keyPath forStatisticID:(NSString*)statID {
    
    id oldStat = [self statisticForID:statID];
    if (!oldStat) { oldStat = [NSNull null]; }
    [self removeStatisticWithID:statID];
    
    [_statistics setObject:keyPath forKey:statID];
    [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:DKCharacterStatisticKVOContext];
    id newStat = [self statisticForID:statID];
    if (!newStat) { newStat = [NSNull null]; }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                        object:oldStat
                                                      userInfo:@{@"old": oldStat,
                                                                 @"new": newStat}];
}

- (void)setStatistic:(DKStatistic*)statistic forStatisticID:(NSString*)statID {
    
    if (!statID) { return; }
    id oldStat = [self statisticForID:statID];
    if (!oldStat) { oldStat = [NSNull null]; }
    [self removeStatisticWithID:statID];
    
    [_statistics setObject:statistic forKey:statID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                        object:oldStat
                                                      userInfo:@{@"old": oldStat,
                                                                 @"new": statistic}];
}

- (void)removeStatisticWithID:(NSString*)statID {
    
    if (!statID) { return; }
    id statisticToRemove = _statistics[statID];
    if (!statisticToRemove) { return; }
    
    if ([statisticToRemove isKindOfClass:[NSString class]]) {
        //If the object is a string, then this statistic is registered through its key path
        NSString* keyPath = (NSString*)statisticToRemove;
        [self removeObserver:self forKeyPath:keyPath];
        
    } else if ([statisticToRemove isKindOfClass:[DKNumericStatistic class]]) {
        //Otherwise, it was just registered directly
    }
    [_statistics removeObjectForKey:statID];
}

- (void)applyModifier:(DKModifier*)modifier toStatisticWithID:(NSString*)statID {
    
    //We want modifiers to go all the way to the top of the tree, so that we can see every registered statistic
    if (_owner) {
        [_owner applyModifier:modifier toStatisticWithID:statID];
    } else {
        DKStatistic* stat = [self statisticForID:statID];
        [stat applyModifier:modifier];
    }
}

#pragma mark -

- (DKStatisticGroup*)statisticGroupForID:(NSString*)statGroupID {
    
    if (!statGroupID) { return nil; }
    id groupOrKeyPath = [_statisticGroups objectForKey:statGroupID];
    if ([groupOrKeyPath isKindOfClass:[NSString class]]) {
        NSString* keyPath = (NSString*)groupOrKeyPath;
        return [self valueForKeyPath:keyPath];
    }
    else if ([groupOrKeyPath isKindOfClass:[DKStatisticGroup class]]) {
        return groupOrKeyPath;
    } else {
        return nil;
    }
}

- (void)addKeyPath:(NSString*)keyPath forStatisticGroupID:(NSString*)statGroupID {
    
    [self removeStatisticGroupWithID:statGroupID];
    [_statisticGroups setObject:keyPath forKey:statGroupID];
    [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
              context:DKCharacterStatisticGroupKVOContext];
}

- (void)addStatisticGroup:(DKStatisticGroup*)statisticGroup forStatisticGroupID:(NSString*)statGroupID {
    
    if (!statGroupID) { return; }
    
    [self removeStatisticGroupWithID:statGroupID];
    [_statisticGroups setObject:statisticGroup forKey:statGroupID];
    [statisticGroup wasAddedToOwner:self];
}

- (void)removeStatisticGroupWithID:(NSString*)statGroupID {
    
    if (!statGroupID) { return; }
    id groupToRemoveOrKeyPath = _statisticGroups[statGroupID];
    if (!groupToRemoveOrKeyPath) { return; }
    
    DKStatisticGroup* groupToRemove = nil;
    if ([groupToRemoveOrKeyPath isKindOfClass:[NSString class]]) {
        //If the object is a string, then this group is registered through its key path
        NSString* keyPath = (NSString*)groupToRemoveOrKeyPath;
        groupToRemove = [self valueForKeyPath:keyPath];
        [self removeObserver:self forKeyPath:keyPath];
    } else if ([groupToRemoveOrKeyPath isKindOfClass:[DKStatisticGroup class]]) {
        //Otherwise, it was just registered directly
        groupToRemove = (DKStatisticGroup*)groupToRemoveOrKeyPath;
    }
    
    [_statisticGroups removeObjectForKey:statGroupID];
    [groupToRemove wasAddedToOwner:nil];
}

#pragma mark -

- (DKModifierGroup*)modifierGroupForID:(NSString*)groupID {
    if (!groupID) { return nil; }
    id groupOrKeyPath = [_modifierGroups objectForKey:groupID];
    if ([groupOrKeyPath isKindOfClass:[NSString class]]) {
        NSString* keyPath = (NSString*)groupOrKeyPath;
        return [self valueForKeyPath:keyPath];
    }
    else if ([groupOrKeyPath isKindOfClass:[DKModifierGroup class]]) {
        return groupOrKeyPath;
    } else {
        return nil;
    }
}

- (void)addKeyPath:(NSString*)keyPath forModifierGroupID:(NSString*)groupID {
    
    [self removeModifierGroupWithID:groupID];
    [_modifierGroups setObject:keyPath forKey:groupID];
    [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew|NSKeyValueObservingOptionInitial
              context:DKCharacterModifierGroupKVOContext];
}

- (void)addModifierGroup:(DKModifierGroup*)modifierGroup forGroupID:(NSString*)groupID {
    
    if (!groupID) { return; }
    
    [self removeModifierGroupWithID:groupID];
    [_modifierGroups setObject:modifierGroup forKey:groupID];
    
    //Apply all the modifiers in this group to our statistics
    for (DKModifier* modifier in modifierGroup.modifiers) {
        [self applyModifier:modifier toStatisticWithID:[modifierGroup statIDForModifier:modifier]];
    }
    
    [modifierGroup wasAddedToOwner:self];
}

- (void)removeModifierGroupWithID:(NSString*)groupID {
    
    if (!groupID) { return; }
    id groupToRemoveOrKeyPath = _modifierGroups[groupID];
    if (!groupToRemoveOrKeyPath) { return; }
    
    DKModifierGroup* groupToRemove = nil;
    if ([groupToRemoveOrKeyPath isKindOfClass:[NSString class]]) {
        //If the object is a string, then this group is registered through its key path
        NSString* keyPath = (NSString*)groupToRemoveOrKeyPath;
        groupToRemove = [self valueForKeyPath:keyPath];
        [self removeObserver:self forKeyPath:keyPath];
        
    } else if ([groupToRemoveOrKeyPath isKindOfClass:[DKModifierGroup class]]) {
        //Otherwise, it was just registered directly
        groupToRemove = (DKModifierGroup*)groupToRemoveOrKeyPath;
    }
    
    //Remove all the modifiers in this group from our statistics
    for (DKModifier* modifier in groupToRemove.modifiers) {
        [modifier removeFromStatistic];
    }
    
    [_modifierGroups removeObjectForKey:groupID];
    [groupToRemove wasAddedToOwner:nil];
}

- (void)wasAddedToOwner:(id<DKStatisticGroupOwner>)owner {
    _owner = owner;
}

#pragma DKModifierGroupOwner

- (void)removeModifierGroup:(DKModifierGroup*)modifierGroup {
    
    if (!modifierGroup || [modifierGroup isEqual:[NSNull null]]) { return; }
    
    NSArray* allKeys = [_modifierGroups allKeysForObject:modifierGroup];
    for (NSString* key in allKeys) {
        [self removeModifierGroupWithID:key];
    }
}

- (void)group:(DKModifierGroup*)modifierGroup willAddModifier:(DKModifier*)modifier forStatID:(NSString*)statID {
    
    [self applyModifier:modifier toStatisticWithID:statID];
}

- (void)group:(DKModifierGroup*)modifierGroup willRemoveModifier:(DKModifier*)modifier {
    
    [modifier removeFromStatistic];
}

#pragma NSKeyValueObserving

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (context == DKCharacterStatisticKVOContext) {
        
        DKNumericStatistic* oldStat = change[@"old"];
        //Send out a notification so all the DKDependantModifiers can update their parent objects
        [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                            object:oldStat
                                                          userInfo:change];
        
    } else if (context == DKCharacterModifierGroupKVOContext) {
        
        //Remove all the modifiers in the old group and apply the modifiers from the new group
        DKModifierGroup* oldGroup = change[@"old"];
        if ([oldGroup isEqual:[NSNull null]]) { oldGroup = nil; }
        for (DKModifier* modifier in oldGroup.modifiers) {
            [modifier removeFromStatistic];
        }
        [oldGroup wasAddedToOwner:nil];
        DKModifierGroup* newGroup = change[@"new"];
        if ([newGroup isEqual:[NSNull null]]) { newGroup = nil; }
        for (DKModifier* modifier in newGroup.modifiers) {
            [self applyModifier:modifier toStatisticWithID:[newGroup statIDForModifier:modifier]];
        }
        [newGroup wasAddedToOwner:self];
        
    } else if (context == DKCharacterStatisticGroupKVOContext) {
        
        DKStatisticGroup* oldGroup = change[@"old"];
        if ([oldGroup isEqual:[NSNull null]]) { oldGroup = nil; }
        [oldGroup wasAddedToOwner:nil];
        
        DKStatisticGroup* newGroup = change[@"new"];
        if ([newGroup isEqual:[NSNull null]]) { newGroup = nil; }
        [newGroup wasAddedToOwner:self];
    }
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeConditionalObject:_owner forKey:@"owner"];
    [aCoder encodeObject:_statistics forKey:@"statistics"];
    [aCoder encodeObject:_statisticGroups forKey:@"statisticGroups"];
    [aCoder encodeObject:_modifierGroups forKey:@"modifierGroups"];
    
    NSMutableDictionary* keyPathsToStatistics = [NSMutableDictionary dictionary];
    for (NSString* statisticId in _statistics.allKeys) {
        id statisticObject = _statistics[statisticId];
        if ([statisticObject isKindOfClass:[NSString class]]) {
            DKStatistic* statistic = [self statisticForID:statisticId];
            if (statistic) { [keyPathsToStatistics setValue:statistic forKey:statisticObject]; }
        }
    }
    [aCoder encodeObject:keyPathsToStatistics forKey:@"keyPathsToStatistics"];
    
    NSMutableDictionary* keyPathsToStatisticGroups = [NSMutableDictionary dictionary];
    for (NSString* statisticGroupId in _statisticGroups.allKeys) {
        id statisticGroupObject = _statistics[statisticGroupId];
        if ([statisticGroupObject isKindOfClass:[NSString class]]) {
            DKStatisticGroup* statisticGroup = [self statisticGroupForID:statisticGroupId];
            if (statisticGroup) { [keyPathsToStatisticGroups setValue:statisticGroup forKey:statisticGroupObject]; }
        }
    }
    [aCoder encodeObject:keyPathsToStatisticGroups forKey:@"keyPathsToStatisticGroups"];
    
    NSMutableDictionary* keyPathsToModifierGroups = [NSMutableDictionary dictionary];
    for (NSString* groupId in _modifierGroups.allKeys) {
        id groupObject = _modifierGroups[groupId];
        if ([groupObject isKindOfClass:[NSString class]]) {
            DKModifierGroup* group = [self modifierGroupForID:groupId];
            if (group) { [keyPathsToModifierGroups setValue:group forKey:groupObject]; }
        }
    }
    [aCoder encodeObject:keyPathsToModifierGroups forKey:@"keyPathsToModifierGroups"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _owner = [aDecoder decodeObjectForKey:@"owner"];
        _statistics = [NSMutableDictionary dictionary];
        _statisticGroups = [NSMutableDictionary dictionary];
        _modifierGroups = [NSMutableDictionary dictionary];
        
        NSDictionary* decodedStatistics = [aDecoder decodeObjectForKey:@"statistics"];
        for (NSString* statisticId in decodedStatistics.allKeys) {
            id statisticObject = decodedStatistics[statisticId];
            if ([statisticObject isKindOfClass:[NSString class]]) {
                [self addKeyPath:statisticObject forStatisticID:statisticId];
            } else if([statisticObject isKindOfClass:[DKStatistic class]]) {
                [self setStatistic:statisticObject forStatisticID:statisticId];
            }
        }
        
        NSDictionary* decodedStatisticGroups = [aDecoder decodeObjectForKey:@"statisticGroups"];
        for (NSString* statisticGroupId in decodedStatisticGroups.allKeys) {
            id statisticGroupObject = decodedStatisticGroups[statisticGroupId];
            if ([statisticGroupObject isKindOfClass:[NSString class]]) {
                [self addKeyPath:statisticGroupObject forStatisticGroupID:statisticGroupId];
            } else if([statisticGroupObject isKindOfClass:[DKStatisticGroup class]]) {
                [self addStatisticGroup:statisticGroupObject forStatisticGroupID:statisticGroupId];
            }
        }
        
        NSDictionary* decodedModifierGroups = [aDecoder decodeObjectForKey:@"modifierGroups"];
        for (NSString* groupId in decodedModifierGroups.allKeys) {
            id groupObject = decodedModifierGroups[groupId];
            if ([groupObject isKindOfClass:[NSString class]]) {
                [self addKeyPath:groupObject forModifierGroupID:groupId];
            } else if([groupObject isKindOfClass:[DKModifierGroup class]]) {
                [self addModifierGroup:groupObject forGroupID:groupId];
            }
        }
        
        NSDictionary* keyPathsToStatistics = [aDecoder decodeObjectForKey:@"keyPathsToStatistics"];
        for (NSString* keyPath in keyPathsToStatistics.allKeys) {
            DKStatistic* stat = keyPathsToStatistics[keyPath];
            [self setValue:stat forKeyPath:keyPath];
        }
        
        NSDictionary* keyPathsToStatisticGroups = [aDecoder decodeObjectForKey:@"keyPathsToStatisticGroups"];
        for (NSString* keyPath in keyPathsToStatisticGroups.allKeys) {
            DKStatisticGroup* statGroup = keyPathsToStatisticGroups[keyPath];
            [self setValue:statGroup forKeyPath:keyPath];
        }
        
        NSDictionary* keyPathsToModifierGroups = [aDecoder decodeObjectForKey:@"keyPathsToModifierGroups"];
        for (NSString* keyPath in keyPathsToModifierGroups.allKeys) {
            DKModifierGroup* modifierGroup = keyPathsToModifierGroups[keyPath];
            [self setValue:modifierGroup forKeyPath:keyPath];
        }
    }
    return self;
}

@end
