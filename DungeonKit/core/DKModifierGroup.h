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

@interface DKModifierGroup : NSObject

@property (nonatomic, strong, readonly) NSDictionary* modifiersByStatID;
@property (nonatomic, weak, readonly) id<DKModifierGroupOwner> owner;

- (NSArray*)allModifiers;
- (void)addModifier:(DKModifier*)modifier forStatisticID:(NSString*)statID;
- (void)removeModifierForStatisticID:(NSString*)statID;

/** Removes the modifier from its owner character. */
- (void)removeFromOwner;

/** Callback method for when the modifier group gets added.  Only DKCharacter and similar owner
 classes should call this method directly.  */
- (void)wasAddedToOwner:(id<DKModifierGroupOwner>)owner;

@end
