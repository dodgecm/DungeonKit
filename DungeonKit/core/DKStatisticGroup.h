//
//  DKCharacter.h
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKChoiceModifierGroup.h"

@protocol DKStatisticGroupOwner <NSObject>
@required
- (void)applyModifier:(DKModifier*)modifier toStatisticWithID:(NSString*)statID;
@end


@interface DKStatisticGroup : NSObject <DKStatisticGroupOwner, DKModifierGroupOwner, NSCoding>
@property (nonatomic, weak, readonly) id<DKStatisticGroupOwner> owner;

- (NSArray*)allStatisticIDs;
- (DKStatistic*)statisticForID:(NSString*)statID;
- (void)addKeyPath:(NSString*)keyPath forStatisticID:(NSString*)statID;
- (void)setStatistic:(DKStatistic*)statistic forStatisticID:(NSString*)statID;
- (void)removeStatisticWithID:(NSString*)statID;

- (void)applyModifier:(DKModifier*)modifier toStatisticWithID:(NSString*)statID;

- (DKStatisticGroup*)statisticGroupForID:(NSString*)statGroupID;
- (void)addKeyPath:(NSString*)keyPath forStatisticGroupID:(NSString*)statGroupID;
- (void)addStatisticGroup:(DKStatisticGroup*)statisticGroup forStatisticGroupID:(NSString*)statGroupID;
- (void)removeStatisticGroupWithID:(NSString*)statGroupID;

- (DKModifierGroup*)modifierGroupForID:(NSString*)groupID;
- (void)addKeyPath:(NSString*)keyPath forModifierGroupID:(NSString*)groupID;
- (void)addModifierGroup:(DKModifierGroup*)modifierGroup forGroupID:(NSString*)groupID;
- (void)removeModifierGroupWithID:(NSString*)groupID;

- (DKModifierGroup*)firstModifierGroupWithTag:(NSString*)tag;
- (NSArray*)allModifierGroupsWithTag:(NSString*)tag;

- (DKChoiceModifierGroup*)firstUnallocatedChoiceWithTag:(NSString*)tag;
- (NSArray*)allUnallocatedChoicesWithTag:(NSString*)tag;
- (NSArray*)allUnallocatedChoices;

/** Callback method for when the statistic group's owner gets changed.  Only DKStatisticGroup and similar owner
 classes should call this method directly.  */
- (void)wasAddedToOwner:(id<DKStatisticGroupOwner>)owner;

@end
