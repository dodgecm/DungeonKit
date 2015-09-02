//
//  DKModifierBuilder.h
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"

@class DKDiceCollection;

/** The DKModifierBuilder class provides convenience initialization methods for common DKModifier operations. */
@interface DKModifierBuilder : NSObject

/** Initializes a standard additive modifier, ex: +2 to a statistic. */
+ (id)modifierWithAdditiveBonus:(NSInteger)bonus;
/** Initializes a standard additive modifier, ex: +2 to a statistic. */
+ (id)modifierWithAdditiveBonus:(NSInteger)bonus explanation:(NSString*)explanation;

/** Initializes a modifier that keeps the statistic value above the given minimum */
+ (id)modifierWithMinimum:(NSInteger)min;
/** Initializes a modifier that keeps the statistic value above the given minimum */
+ (id)modifierWithMinimum:(NSInteger)min explanation:(NSString*)explanation;

/** Initializes a modifier that keeps the statistic value within the given range */
+ (id)modifierWithClampBetween:(NSInteger)min and:(NSInteger)max;
/** Initializes a modifier that keeps the statistic value within the given range */
+ (id)modifierWithClampBetween:(NSInteger)min and:(NSInteger)max explanation:(NSString*)explanation;

/** DKStringStatistic Modifiers */
+ (id)modifierWithOverrideString:(NSString*)string;

/** DKSetStatistic Modifiers */
+ (id)modifierWithAppendedString:(NSString*)stringToAppend;
+ (id)modifierWithAppendedString:(NSString*)stringToAppend explanation:(NSString*)explanation;

+ (id)modifierWithAddedDice:(DKDiceCollection*)collection;
+ (id)modifierWithAddedDice:(DKDiceCollection*)collection explanation:(NSString*)explanation;

/** Initializes a modifier with no mathematical effects */
+ (id)modifierWithExplanation:(NSString*)explanation;

+ (NSExpression*)simpleAdditionModifierExpression;
+ (NSExpression*)simpleClampExpressionBetween:(NSInteger)min and:(NSInteger)max;
+ (NSExpression*)simpleAppendModifierExpression;
+ (NSExpression*)simpleAppendSetModifierExpression;
+ (NSExpression*)simpleAddDiceModifierExpression;
+ (NSExpression*)simpleReplaceStringExpression;


@end


/** The DKDependentModifierBuilder class provides convenience initialization methods for generating common modifiers from statistics. */
@interface DKDependentModifierBuilder : NSObject

/** Initializes a modifier from the source object that simply adds the source's value to the modifier's owner. */
+ (id)simpleModifierFromSource:(NSObject<DKDependency>*)source;

+ (id)simpleModifierFromSource:(NSObject<DKDependency>*)source
                   explanation:(NSString*)explanation;

+ (id)addedNumberFromSource:(NSObject<DKDependency>*)source
              constantValue:(id)constantValue
                    enabled:(NSPredicate*)enabledPredicate
                explanation:(NSString*)explanation;

+ (id)appendedModifierFromSource:(NSObject<DKDependency>*)source
                           value:(NSExpression*)valueExpression
                         enabled:(NSPredicate*)enabledPredicate
                     explanation:(NSString*)explanation;

+ (id)appendedModifierFromSource:(NSObject<DKDependency>*)source
                   constantValue:(id)constantValue
                         enabled:(NSPredicate*)enabledPredicate
                     explanation:(NSString*)explanation;

+ (id)addedDiceModifierFromSource:(NSObject<DKDependency>*)source
                      explanation:(NSString*)explanation;

+ (id)addedDiceModifierFromSource:(NSObject<DKDependency>*)source
                            value:(NSExpression*)valueExpression
                          enabled:(NSPredicate*)enabledPredicate
                      explanation:(NSString*)explanation;

+ (id)informationalModifierFromSource:(NSObject<DKDependency>*)source
                              enabled:(NSPredicate*)enabledPredicate
                          explanation:(NSString*)explanation;

/** An expression that simply uses the specified dependency's value as the modifier value. */
+ (NSExpression*)valueFromDependency:(NSString*)dependencyKey;
/** An expression that has a constant value instead of relying on any of the dependencies. */
+ (NSExpression*)expressionForConstantInteger:(NSInteger)value;
/** An expression that has a constant value instead of relying on any of the dependencies. */
+ (NSExpression*)expressionForConstantValue:(id<NSObject>) value;

+ (NSValue*)rangeValueWithMin:(NSInteger)min max:(NSInteger)max;
+ (NSExpression*)valueFromPiecewiseFunctionRanges:(NSDictionary*)ranges usingDependency:(NSString*)dependencyKey;

/** An expression that uses a DKNumericStatistic dependency and converts it into a DKDiceCollection value. */
+ (NSExpression*)valueAsDiceCollectionFromNumericDependency:(NSString*)dependencyKey;
+ (NSExpression*)valueAsDiceCollectionFromExpression:(NSExpression*)numericExpression;

/** DKNumericStatistic predicates */
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isGreaterThanOrEqualTo:(NSInteger)threshold;
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToOrBetween:(NSInteger)lowThreshold and:(NSInteger)highThreshold;
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isLessThan:(NSInteger)threshold;

/** DKStringStatistic predicates */
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToString:(NSString*)string;
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToAnyFromStrings:(NSArray*)objects;

/** DKSetStatistic predicates */
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName containsObject:(id)object;
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName containsAnyFromObjects:(NSArray*)objects;
+ (NSPredicate*)enabledWhen:(NSString*)dependencyName doesNotContainAnyFromObjects:(NSArray*)objects;

@end