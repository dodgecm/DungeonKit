//
//  DKModifierGroup.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"

@class DKModifierGroup;
@protocol DKModifierGroupOwner <NSObject>
@required
- (void)removeModifierGroup:(DKModifierGroup*)modifier;
- (void)group:(DKModifierGroup*)modifierGroup willAddModifier:(DKModifier*)modifier forStatID:(NSString*)statID;
- (void)group:(DKModifierGroup*)modifierGroup willRemoveModifier:(DKModifier*)modifier;
@end

@interface DKModifierGroup : NSObject <DKModifierGroupOwner, NSCoding>

/** Array of DKModifiers that this DKModifierGroup is the owner of (including modifiers from subgroups). */
@property (nonatomic, strong, readonly) NSArray* modifiers;
/** Array of DKModifierGroups that this DKModifierGroup is the owner of. */
@property (nonatomic, strong, readonly) NSSet* subgroups;
/** An optional explanation of the nature or source of this modifier group */
@property (nonatomic, copy) NSString* explanation;
@property (nonatomic, weak, readonly) id<DKModifierGroupOwner> owner;

- (NSString*)statIDForModifier:(DKModifier*)modifier;

- (void)addModifier:(DKModifier*)modifier forStatisticID:(NSString*)statID;
- (void)removeModifier:(DKModifier*)modifier;

- (void)addSubgroup:(DKModifierGroup*)subgroup;
- (void)removeSubgroup:(DKModifierGroup*)subgroup;

/** Removes the modifier group from its owner. */
- (void)removeFromOwner;

/** Callback method for when the modifier group gets changed.  Only DKStatisticGroup and similar owner
 classes should call this method directly.  */
- (void)wasAddedToOwner:(id<DKModifierGroupOwner>)owner;

- (NSString*)shortDescription;

@end

