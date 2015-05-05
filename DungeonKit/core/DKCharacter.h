//
//  DKCharacter.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKModifierGroup.h"

@interface DKCharacter : NSObject <DKModifierGroupOwner, NSCoding> {
    
}

- (DKStatistic*)statisticForID:(NSString*)statID;
- (void)addKeyPath:(NSString*)keyPath forStatisticID:(NSString*)statID;
- (void)setStatistic:(DKStatistic*)statistic forStatisticID:(NSString*)statID;
- (void)removeStatisticWithID:(NSString*)statID;

- (void)applyModifier:(DKModifier*)modifier toStatisticWithID:(NSString*)statID;

- (DKModifierGroup*)modifierGroupForID:(NSString*)groupID;
- (void)addKeyPath:(NSString*)keyPath forModifierGroupID:(NSString*)groupID;
- (void)addModifierGroup:(DKModifierGroup*)modifierGroup forGroupID:(NSString*)groupID;
- (void)removeModifierGroupWithID:(NSString*)groupID;

@end
