//
//  DKModifierBuilder.h
//  DungeonKit
//
//  Created by Christopher Dodge on 5/4/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKDependentModifier.h"

/** The DKModifierBuilder class provides convenience initialization methods for common DKModifier operations. */
@interface DKModifierBuilder : NSObject

/** Initializes a standard additive modifier, ex: +2 to a statistic. */
+ (id)modifierWithAdditiveBonus:(int)bonus;
/** Initializes a standard additive modifier, ex: +2 to a statistic. */
+ (id)modifierWithAdditiveBonus:(int)bonus explanation:(NSString*)explanation;

/** Initializes a modifier that keeps the statistic value above the given minimum */
+ (id)modifierWithMinimum:(int)min;
/** Initializes a modifier that keeps the statistic value above the given minimum */
+ (id)modifierWithMinimum:(int)min explanation:(NSString*)explanation;

/** Initializes a modifier that keeps the statistic value within the given range */
+ (id)modifierWithClampBetween:(int)min and:(int)max;
/** Initializes a modifier that keeps the statistic value within the given range */
+ (id)modifierWithClampBetween:(int)min and:(int)max explanation:(NSString*)explanation;

/** Initializes a modifier with no mathematical effects */
+ (id)modifierWithExplanation:(NSString*)explanation;

+ (NSExpression*)simpleAdditionModifierExpression;

@end


/** The DKDependentModifierBuilder class provides convenience initialization methods for generating common modifiers from statistics. */
@interface DKDependentModifierBuilder : NSObject

/** Initializes a modifier from the source object that simply adds the source's value to the modifier's owner. */
+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source;

+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source
                   explanation:(NSString*)explanation;

+ (id)informationalModifierFromSource:(NSObject<DKDependentModifierOwner>*)source
                              enabled:(NSPredicate*)enabledPredicate
                          explanation:(NSString*)explanation;

/** An expression that simply uses the specified dependency's value as the modifier value. */
+ (NSExpression*)valueFromDependency:(NSString*)dependencyKey;
/** An expression that has a constant value instead of relying on any of the dependencies. */
+ (NSExpression*)expressionForConstantValue:(int)value;

+ (NSValue*)rangeValueWithMin:(NSInteger)min max:(NSInteger)max;
+ (NSExpression*)valueFromPiecewiseFunctionRanges:(NSDictionary*)ranges usingDependency:(NSString*)dependencyKey;

//+ (DKDependentModifierEnabledBlockType)enableWhenGreaterThanOrEqualTo:(int)threshold;
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isGreaterThanOrEqualTo:(int)threshold;
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToOrBetween:(int)lowThreshold and:(int)highThreshold;

@end