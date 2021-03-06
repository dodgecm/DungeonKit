//
//  DKModifierGroup.h
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"

@class DKModifierGroup;
@protocol DKModifierGroupOwner <NSObject>
@required
- (BOOL)enabledPredicateResult;
- (void)removeModifierGroup:(DKModifierGroup*)modifier;
- (void)group:(DKModifierGroup*)modifierGroup willAddModifier:(DKModifier*)modifier forStatID:(NSString*)statID;
- (void)group:(DKModifierGroup*)modifierGroup willRemoveModifier:(DKModifier*)modifier;
@end

@interface DKModifierGroup : DKDependencyOwner <DKModifierGroupOwner, NSCoding>

/** Array of DKModifiers that this DKModifierGroup is the owner of (including modifiers from subgroups). */
@property (nonatomic, strong, readonly) NSArray* modifiers;
/** Array of DKModifierGroups that this DKModifierGroup is the owner of. */
@property (nonatomic, strong, readonly) NSOrderedSet* subgroups;
/** An optional tag for looking up this modifier group */
@property (nonatomic, copy) NSString* tag;
/** An optional explanation of the nature or source of this modifier group */
@property (nonatomic, copy) NSString* explanation;
@property (nonatomic, weak, readonly) id<DKModifierGroupOwner> owner;

- (id)init;
- (id)initWithTag:(NSString*)tag;

- (NSString*)statIDForModifier:(DKModifier*)modifier;

- (void)addModifier:(DKModifier*)modifier forStatisticID:(NSString*)statID;
- (void)removeModifier:(DKModifier*)modifier;

- (void)addSubgroup:(DKModifierGroup*)subgroup;
- (void)removeSubgroup:(DKModifierGroup*)subgroup;

- (DKModifierGroup*)firstSubgroupWithTag:(NSString*)tag;
- (NSArray*)allSubgroupsWithTag:(NSString*)tag;
- (NSArray*)allSubgroupsOfType:(Class)type;

/** Removes the modifier group from its owner. */
- (void)removeFromOwner;

/** Callback method for when the modifier group gets changed.  Only DKStatisticGroup and similar owner
 classes should call this method directly.  */
- (void)wasAddedToOwner:(id<DKModifierGroupOwner>)owner;

- (NSString*)shortDescription;

@end

