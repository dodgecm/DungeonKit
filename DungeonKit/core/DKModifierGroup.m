//
//  DKModifierGroup.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKModifierGroup.h"

@implementation DKModifierGroup {
    NSMutableDictionary* _modifiersByStatID;
}

@synthesize modifiersByStatID = _modifiersByStatID;
@synthesize owner = _owner;

- (id)init {
    self = [super init];
    if (self) {
        _modifiersByStatID = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSArray*)allModifiers {
    return [_modifiersByStatID allValues];
}

- (void)addModifier:(DKModifier*)modifier forStatisticID:(NSString*)statID {
    
    if (!statID) {
        NSLog(@"DKModifierGroup: Attempted to add modifier: %@ but statistic ID cannot be nil.", modifier);
        return;
    }
    
    [_owner group:self willAddModifier:modifier forStatID:statID];
    [_modifiersByStatID setObject:modifier forKey:statID];
}

- (void)removeModifierForStatisticID:(NSString*)statID {
    
    if (!statID) {
        NSLog(@"DKModifierGroup: Attempted to remove modifier but statistic ID cannot be nil.");
        return;
    }
    
    DKModifier* modifierToRemove = _modifiersByStatID[statID];
    if (modifierToRemove) {
        [_owner group:self willRemoveModifier:modifierToRemove];
        [_modifiersByStatID removeObjectForKey:statID];
    }
}

- (void)removeFromOwner {
    [_owner removeModifierGroup:self];
    _owner = nil;
}

- (void)wasAddedToOwner:(id<DKModifierGroupOwner>)owner {
    _owner = owner;
}

@end
