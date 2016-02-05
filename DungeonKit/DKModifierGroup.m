//
//  DKModifierGroup.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKModifierGroup.h"

@interface DKModifierGroup()
@property (nonatomic, strong, readonly) NSDictionary* modifierHashesToStatIDs;
@end

@implementation DKModifierGroup {
    NSMutableDictionary* _modifierHashesToStatIDs;
    NSMutableArray* _modifiers;
    NSMutableOrderedSet* _subgroups;
}

@synthesize modifierHashesToStatIDs = _modifierHashesToStatIDs;

@synthesize modifiers = _modifiers;
@synthesize subgroups = _subgroups;
@synthesize tag = _tag;
@synthesize explanation = _explanation;
@synthesize owner = _owner;

- (id)init {
    self = [super init];
    if (self) {
        _modifierHashesToStatIDs = [NSMutableDictionary dictionary];
        _modifiers = [NSMutableArray array];
        _subgroups = [NSMutableOrderedSet orderedSet];
    }
    return self;
}

- (id)initWithTag:(NSString*)tag {
    self = [self init];
    if (self) {
        self.tag = tag;
    }
    return self;
}

- (NSString*)statIDForModifier:(DKModifier*)modifier {
    return [_modifierHashesToStatIDs objectForKey: @([modifier hash]) ];
}

- (void)addModifier:(DKModifier*)modifier forStatisticID:(NSString*)statID {
    
    if (!statID || !modifier) {
        NSLog(@"DKModifierGroup: Attempted to add modifier: %@ for statistic ID: %@ cannot be nil.", modifier, statID);
        return;
    }

    [_owner group:self willAddModifier:modifier forStatID:statID];
    [_modifiers addObject:modifier];
    [_modifierHashesToStatIDs setObject:statID forKey:@([modifier hash])];
    [self refresh];
}

- (void)removeModifier:(DKModifier*)modifier {
    
    if (!modifier) {
        NSLog(@"DKModifierGroup: Attempted to remove nil modifier.");
        return;
    }
    
    [_owner group:self willRemoveModifier:modifier];
    [_modifiers removeObject:modifier];
    [_modifierHashesToStatIDs removeObjectForKey:@([modifier hash])];
    [self refresh];
}

- (void)addSubgroup:(DKModifierGroup*)subgroup {
    
    if (!subgroup || [subgroup isEqual:[NSNull null]]) { 
        NSLog(@"DKModifierGroup: Attempted to add nil subgroup.");
        return;
    } else if ([_subgroups containsObject:subgroup]) {
        NSLog(@"DKModifierGroup: Attempted to add subgroup: %@ that already belongs to this modifier group.", subgroup);
        return;
    }
    
    [subgroup removeFromOwner];
    [_subgroups addObject:subgroup];
    for (DKModifier* modifier in subgroup.modifiers) {
        
        NSString* statID = [subgroup statIDForModifier:modifier];
        [self addModifier:modifier forStatisticID:statID];
    }
    
    [subgroup wasAddedToOwner:self];
}

- (void)removeSubgroup:(DKModifierGroup*)subgroup {
    
    if (!subgroup || [subgroup isEqual:[NSNull null]]) {
        NSLog(@"DKModifierGroup: Attempted to remove nil subgroup.");
        return;
    }
    
    [_subgroups removeObject:subgroup];
    for (DKModifier* modifier in subgroup.modifiers) {
        
        [self removeModifier:modifier];
    }
    [subgroup wasAddedToOwner:nil];
}

- (void)removeFromOwner {
    [_owner removeModifierGroup:self];
    _owner = nil;
}

- (void)wasAddedToOwner:(id<DKModifierGroupOwner>)owner {
    _owner = owner;
    [self refresh];
}

- (DKModifierGroup*)firstSubgroupWithTag:(NSString*)tag {
    
    if (![tag length]) {
        return nil;
    }
    
    for (DKModifierGroup* subgroup in _subgroups) {
        if ([tag isEqualToString:subgroup.tag]) {
            return subgroup;
        }
        
        DKModifierGroup* matchingSubgroup = [subgroup firstSubgroupWithTag:tag];
        if (matchingSubgroup) {
            return matchingSubgroup;
        }
    }
    
    return nil;
}

- (NSArray*)allSubgroupsWithTag:(NSString*)tag {
    
    if (![tag length]) {
        return @[];
    }
    
    NSMutableArray* matchingSubgroups = [NSMutableArray array];
    for (DKModifierGroup* subgroup in _subgroups) {
        if ([tag isEqualToString:subgroup.tag]) {
            [matchingSubgroups addObject:subgroup];
        }
        [matchingSubgroups addObjectsFromArray:[subgroup allSubgroupsWithTag:tag]];
    }
    
    return matchingSubgroups;
}

- (NSArray*)allSubgroupsOfType:(Class)type {
    
    NSMutableArray* matchingSubgroups = [NSMutableArray array];
    for (DKModifierGroup* subgroup in _subgroups) {
        if ([subgroup isKindOfClass:type]) {
            [matchingSubgroups addObject:subgroup];
        }
        [matchingSubgroups addObjectsFromArray:[subgroup allSubgroupsOfType:type]];
    }
    
    return matchingSubgroups;
}

/* Will be overridden in subclasses */
- (BOOL)shouldModifierBeActive:(DKModifier*)modifier {
    return self.enabled;
}

#pragma DKDependencyOwner override

- (void)refresh {
    
    [super refresh];
    
    for (DKModifier* modifier in self.modifiers) {
        BOOL modifierActive = [self shouldModifierBeActive:modifier];
        if (!modifierActive) {
            modifier.active = modifierActive;
        } else {
            BOOL isPrimaryOwner = YES;
            for (DKModifierGroup* subgroup in self.subgroups) {
                if ([subgroup.modifiers containsObject:modifier]) {
                    isPrimaryOwner = NO;
                }
            }
            if (isPrimaryOwner) {
                modifier.active = modifierActive;
            }
        }
    }
    
    //Due to our enabled state, we may have caused some of our subgroups to become enabled as well, so we have to refresh them
    for (DKModifierGroup* subgroup in self.subgroups) {
        if (self.enabled || subgroup.enabled) {
            [subgroup refresh];
        }
    }
}

- (BOOL)enabledPredicateResult:(NSDictionary*)context {
    
    BOOL ownerEnabled = YES;
    if (self.owner) {
        ownerEnabled = [self.owner enabledPredicateResult];
    }
    
    if (self.enabledPredicate != nil) {
        return [self.enabledPredicate evaluateWithObject:self substitutionVariables:context] && ownerEnabled && self.active;
    } else {
        return ownerEnabled && self.active;
    }
}

- (void)remove {
    [self removeFromOwner];
}

#pragma DKModifierGroupOwner

- (BOOL)enabledPredicateResult {
    
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    for (NSString* key in self.dependencies) {
        NSObject<DKDependency>* dependency = self.dependencies[key];
        context[key] = dependency.value;
    }
    
    return [self enabledPredicateResult:context];
}

- (void)removeModifierGroup:(DKModifierGroup*)modifierGroup {
    
    [self removeSubgroup:modifierGroup];
}

- (void)group:(DKModifierGroup*)modifierGroup willAddModifier:(DKModifier*)modifier forStatID:(NSString*)statID {
    
    [_owner group:self willAddModifier:modifier forStatID:statID];
    [self addModifier:modifier forStatisticID:statID];
}

- (void)group:(DKModifierGroup*)modifierGroup willRemoveModifier:(DKModifier*)modifier {
    
    [_owner group:self willRemoveModifier:modifier];
    [self removeModifier:modifier];
}

- (NSString*)shortDescription {
    
    NSMutableString* description = [NSMutableString string];
    if ([_explanation length]) { [description appendString:_explanation]; }
    if (!self.enabled) { [description appendString:@" - inactive"]; }
    for (DKModifier* modifier in _modifiers) {
        [description appendFormat:@"\n\t%@", modifier];
    }
    return description;
}

- (NSString*)description {
    
    NSMutableString* description = [NSMutableString stringWithString:@"Modifier group: "];
    if ([_explanation length]) { [description appendFormat:@"%@", _explanation]; }
    if (!self.enabled) { [description appendString:@" - inactive"]; }
    [description appendString:@"\n"];
    if ([_subgroups count]) {
        [description appendString:[NSString stringWithFormat:@"%lu subgroups(s):", (unsigned long) _subgroups.count]];
        for (DKModifierGroup* subgroup in _subgroups) {
            [description appendFormat:@"\n%@", [subgroup shortDescription]];
        }
        [description appendFormat:@"\n\n"];
    }
    if ([_modifiers count]) {
        [description appendString:[NSString stringWithFormat:@"%lu modifier(s):", (unsigned long) _modifiers.count]];
        for (DKModifier* modifier in _modifiers) {
            NSString* statID = [self statIDForModifier:modifier];
            [description appendFormat:@"\n%@: %@", statID, modifier];
        }
    }
    return description;
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    NSMutableDictionary* statIDsToModifiers = [NSMutableDictionary dictionary];
    for (DKModifier* modifier in _modifiers) {
        NSString* statID = [self statIDForModifier:modifier];
        statIDsToModifiers[statID] = modifier;
    }
    
    [aCoder encodeObject:statIDsToModifiers forKey:@"statIDsToModifiers"];
    [aCoder encodeObject:_modifiers forKey:@"modifiers"];
    [aCoder encodeObject:_subgroups forKey:@"subgroups"];
    [aCoder encodeObject:_tag forKey:@"tag"];
    [aCoder encodeObject:_explanation forKey:@"explanation"];
    [aCoder encodeConditionalObject:_owner forKey:@"owner"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        NSDictionary* statIDsToModifiers = [aDecoder decodeObjectForKey:@"statIDsToModifiers"];
        _modifierHashesToStatIDs = [NSMutableDictionary dictionary];
        for (NSString* statID in statIDsToModifiers.allKeys) {
            DKModifier* modifier = statIDsToModifiers[statID];
            [_modifierHashesToStatIDs setObject:statID forKey:@([modifier hash])];
        }
        _modifiers = [aDecoder decodeObjectForKey:@"modifiers"];
        _subgroups = [aDecoder decodeObjectForKey:@"subgroups"];
        _tag = [aDecoder decodeObjectForKey:@"tag"];
        _explanation = [aDecoder decodeObjectForKey:@"explanation"];
        _owner = [aDecoder decodeObjectForKey:@"owner"];
        
        [self refresh];
    }
    return self;
}

@end
