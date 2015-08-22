//
//  DKStatistic.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKDependencyOwner.h"
#import "DKModifier.h"
#import "DKDiceCollection.h"

@interface DKStatistic : NSObject <DKDependency, DKModifierOwner, NSCoding>

/** The value of the statistic without any modifiers. */
@property (nonatomic, readonly) id<NSObject> base;
/** The value of the statistic after modifiers have been applied. */
@property (nonatomic, readonly) id<NSObject> value;
/** An array of modifiers, both enabled and disabled, that are currently applied to this statistic. */
@property (nonatomic, strong, readonly) NSArray* modifiers;

+ (id)statisticWithBase:(id<NSObject>)base;
- (id)init __unavailable;
- (id)initWithBase:(id<NSObject>)base;

/** Applies the given modifier to this statistic.  A modifier can only be applied to one statistic at a time. */
- (void)applyModifier:(DKModifier*)modifier;
- (NSArray*)enabledModifiers;
- (NSArray*)disabledModifiers;

- (void)recalculateValue;

- (NSString*)modifiersDescription;

@end

#pragma mark -
@interface DKNumericStatistic : DKStatistic

/** The value of the statistic without any modifiers. */
@property (nonatomic, copy, readwrite) NSNumber* base;
@property (nonatomic, readonly) NSNumber* value;

+ (id)statisticWithInt:(int)base;
+ (id)statisticWithBase:(id<NSObject>)base __unavailable;
- (id)initWithInt:(int)base;
- (id)initWithBase:(id<NSObject>)base __unavailable;

- (int)intValue;

@end

#pragma mark -
@interface DKStringStatistic : DKStatistic

/** The value of the statistic without any modifiers. */
@property (nonatomic, copy, readwrite) NSString* base;
@property (nonatomic, readonly) NSString* value;

+ (id)statisticWithString:(NSString*)base;
+ (id)statisticWithBase:(id<NSObject>)base __unavailable;
- (id)initWithString:(NSString*)base;
- (id)initWithBase:(id<NSObject>)base __unavailable;

@end

#pragma mark -
@interface DKSetStatistic : DKStatistic

/** The value of the statistic without any modifiers. */
@property (nonatomic, copy, readwrite) NSSet* base;
@property (nonatomic, readonly) NSSet* value;

+ (id)statisticWithEmptySet;
+ (id)statisticWithSet:(NSSet*)base;
+ (id)statisticWithBase:(id<NSObject>)base __unavailable;
- (id)initWithSet:(NSSet*)base;
- (id)initWithBase:(id<NSObject>)base __unavailable;

@end

#pragma mark -
@interface DKDiceStatistic : DKStatistic

/** The value of the statistic without any modifiers. */
@property (nonatomic, strong, readwrite) DKDiceCollection* base;
@property (nonatomic, readonly) DKDiceCollection* value;

+ (id)statisticWithNoDice;
+ (id)statisticWithDice:(DKDiceCollection*)base;
+ (id)statisticWithBase:(id<NSObject>)base __unavailable;
- (id)initWithDice:(DKDiceCollection*)base;
- (id)initWithBase:(id<NSObject>)base __unavailable;

@end