//
//  DKChoiceModifierGroup.h
//  DungeonKit
//
//  Created by Christopher Dodge on 7/7/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifierGroup.h"

@interface DKChoiceModifierGroup : DKModifierGroup <DKModifierGroupOwner, NSCoding>

@property (nonatomic, strong, readonly) DKModifier* chosenModifier;

- (id)init __unavailable;
- (void)chooseModifier:(DKModifier*)chosenModifier;

@end

@interface DKMultipleChoiceModifierGroup : DKModifierGroup <DKModifierGroupOwner, NSCoding>

@property (nonatomic, strong, readonly) DKModifierGroup* chosenGroup;

- (id)init __unavailable;
- (void)chooseModifierGroup:(DKModifierGroup*)chosenModifierGroup;

@end