//
//  DKChoiceModifierGroup.h
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <Foundation/Foundation.h>
#import "DKModifierGroup.h"

@interface DKChoiceModifierGroup : DKModifierGroup

@property (nonatomic, strong, readonly) id<NSObject> choice;
@property (nonatomic, strong, readonly) NSArray* choices;
- (void)choose:(id)choice;

@end

@interface DKSingleChoiceModifierGroup : DKChoiceModifierGroup <DKModifierGroupOwner, NSCoding>

@property (nonatomic, strong, readonly) DKModifier* chosenModifier;
@property (nonatomic, strong) DKModifierGroup* choicesSource;

- (id)init __unavailable;
- (void)chooseModifier:(DKModifier*)chosenModifier;

@end

@interface DKSubgroupChoiceModifierGroup : DKChoiceModifierGroup <DKModifierGroupOwner, NSCoding>

@property (nonatomic, strong, readonly) DKModifierGroup* chosenGroup;

- (id)init __unavailable;
- (void)chooseModifierGroup:(DKModifierGroup*)chosenModifierGroup;

@end