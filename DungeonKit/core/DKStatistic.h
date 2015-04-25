//
//  DKStatistic.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"
#import "DKDependentModifier.h"

@interface DKStatistic : NSObject <DKDependentModifierOwner>

/** The value of the statistic without any modifiers. */
@property (nonatomic, assign) int base;
/** The value of the statistic after modifiers have been applied. */
@property (nonatomic, readonly) int value;
/** An array of modifiers, both enabled and disabled, that are currently applied to this statistic. */
@property (nonatomic, strong, readonly) NSArray* modifiers;

- (id)init __unavailable;
+ (id)statisticWithBase:(int)base;
- (id)initWithBase:(int)base;

- (NSArray*)enabledModifiers;
- (NSArray*)disabledModifiers;

/** Applies the given modifier to this statistic.  A modifier can only be applied to one statistic at a time. */
- (void)applyModifier:(DKModifier*)modifier;

- (void)recalculateValue;

@end
