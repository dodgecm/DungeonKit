//
//  DKCharacter.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKCharacter.h"
#import "DKStatisticIDs5E.h"
#import "DKConstants.h"


@interface DKCharacter()
@property (nonatomic, strong) NSMutableDictionary* statistics;
@property (nonatomic, strong) NSMutableDictionary* modifierGroups;
@end

@implementation DKCharacter

@synthesize statistics = _statistics;
@synthesize modifierGroups = _modifierGroups;

static void* const DKCharacterStatisticKVOContext = (void*)&DKCharacterStatisticKVOContext;
static void* const DKCharacterModifierGroupKVOContext = (void*)&DKCharacterModifierGroupKVOContext;

- (void)dealloc {

    for (id object in [_statistics allValues]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString* keyPath = (NSString*)object;
            [self removeObserver:self forKeyPath:keyPath];
        }
    }
}

- (id)init {
    self = [super init];
    if (self) {
        
        _statistics = [NSMutableDictionary dictionary];
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
    else if ([statOrKeyPath isKindOfClass:[DKStatistic class]]) {
        return statOrKeyPath;
    } else {
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
        
    } else if ([statisticToRemove isKindOfClass:[DKStatistic class]]) {
        //Otherwise, it was just registered directly
    }
    [_statistics removeObjectForKey:statID];
}

- (void)applyModifier:(DKModifier*)modifier toStatisticWithID:(NSString*)statID {
    
    DKStatistic* stat = [self statisticForID:statID];
    [stat applyModifier:modifier];
}

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
    [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:DKCharacterModifierGroupKVOContext];
}

- (void)addModifierGroup:(DKModifierGroup*)modifierGroup forGroupID:(NSString*)groupID {
    
    if (!groupID) { return; }
    
    [self removeModifierGroupWithID:groupID];
    [_modifierGroups setObject:modifierGroup forKey:groupID];
    
    //Apply all the modifiers in this group to our statistics
    for (NSString* statID in [[modifierGroup modifiersByStatID] allKeys]) {
        [self applyModifier:[modifierGroup modifiersByStatID][statID] toStatisticWithID:statID];
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
    for (DKModifier* modifier in [groupToRemove allModifiers]) {
        [modifier removeFromStatistic];
    }
    
    [_modifierGroups removeObjectForKey:groupID];
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
        
        DKStatistic* oldStat = change[@"old"];
        //Send out a notification so all the DKDependantModifiers can update their parent objects
        [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                            object:oldStat
                                                          userInfo:change];
        
    } else if (context == DKCharacterModifierGroupKVOContext) {
        
        //Remove all the modifiers in the old group and apply the modifiers from the new group
        DKModifierGroup* oldGroup = change[@"old"];
        if ([oldGroup isEqual:[NSNull null]]) { oldGroup = nil; }
        for (DKModifier* modifier in [oldGroup allModifiers]) {
            [modifier removeFromStatistic];
        }
        DKModifierGroup* newGroup = change[@"new"];
        if ([newGroup isEqual:[NSNull null]]) { newGroup = nil; }
        for (NSString* statID in [[newGroup modifiersByStatID] allKeys]) {
            [self applyModifier:[newGroup modifiersByStatID][statID] toStatisticWithID:statID];
        }
    }
}

@end
