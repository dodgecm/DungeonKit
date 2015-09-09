//
//  DKModifierBuilder.h
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"
#import "DKDiceCollection.h"

#pragma mark DKModifier constructors
@interface DKModifier (Base)

/** Initializes a modifier with no mathematical effects */
+ (instancetype)modifierWithExplanation:(NSString*)explanation;

+ (instancetype)modifierWithValue:(id<NSObject>)value
               priority:(DKModifierPriority)priority
             expression:(NSExpression*)expression;

+ (instancetype)modifierFromSource:(NSObject<DKDependency>*)source
                 enabled:(NSPredicate*)enabledPredicate
             explanation:(NSString*)explanation;

@end

@interface DKModifier (Numeric)

/** Initializes a standard additive modifier, ex: +2 to a statistic. */
+ (instancetype)numericModifierWithAdditiveBonus:(NSInteger)bonus;
+ (instancetype)numericModifierWithAdditiveBonus:(NSInteger)bonus explanation:(NSString*)explanation;

/** Initializes a modifier that keeps the statistic value above the given minimum */
+ (instancetype)numericModifierWithMin:(NSInteger)min;

/** Initializes a modifier that keeps the statistic value within the given range */
+ (instancetype)numericModifierWithClampBetween:(NSInteger)min and:(NSInteger)max;
+ (instancetype)numericModifierWithClampBetween:(NSInteger)min and:(NSInteger)max explanation:(NSString*)explanation;

/** Initializes a modifier from the source object that adds the source's value to the modifier's owner. */
+ (instancetype)numericModifierAddedFromSource:(NSObject<DKDependency>*)source;

+ (instancetype)numericModifierAddedFromSource:(NSObject<DKDependency>*)source
                       constantValue:(id)constantValue
                             enabled:(NSPredicate*)enabledPredicate;

@end

@interface DKModifier (String)

/** Replaces the existing value of the string modifier with the new string */
+ (instancetype)stringModifierWithNewString:(NSString*)string;

@end

@interface DKModifier (Set)

/** DKSetStatistic Modifiers */
+ (instancetype)setModifierWithAppendedObject:(NSObject*)objectToAppend;
+ (instancetype)setModifierWithAppendedObject:(NSString*)stringToAppend explanation:(NSString*)explanation;

+ (instancetype)setModifierAppendedFromSource:(NSObject<DKDependency>*)source
                              value:(NSExpression*)valueExpression
                            enabled:(NSPredicate*)enabledPredicate;

+ (instancetype)setModifierAppendedFromSource:(NSObject<DKDependency>*)source
                      constantValue:(id)constantValue
                            enabled:(NSPredicate*)enabledPredicate
                        explanation:(NSString*)explanation;

@end

@interface DKModifier (Dice)

/** DKDiceCollection Modifiers */
+ (instancetype)diceModifierWithAddedDice:(DKDiceCollection*)collection;

+ (instancetype)diceModifierAddedFromSource:(NSObject<DKDependency>*)source;

+ (instancetype)diceModifierAddedFromSource:(NSObject<DKDependency>*)source
                            value:(NSExpression*)valueExpression
                          enabled:(NSPredicate*)enabledPredicate;

@end

#pragma mark -
#pragma mark DKExpressionBuilder

@interface DKExpressionBuilder : NSObject

+ (NSExpression*)additionExpression;
+ (NSExpression*)clampExpressionBetween:(NSInteger)min and:(NSInteger)max;
+ (NSExpression*)appendExpression;
+ (NSExpression*)appendObjectsInSetExpression;
+ (NSExpression*)addDiceExpression;
+ (NSExpression*)replaceStringExpression;

/** An expression that uses the specified dependency's value as the modifier value. */
+ (NSExpression*)valueFromDependency:(NSString*)dependencyKey;
/** An expression that has a constant value instead of relying on any of the dependencies. */
+ (NSExpression*)valueFromInteger:(NSInteger)value;
/** An expression that has a constant value instead of relying on any of the dependencies. */
+ (NSExpression*)valueFromObject:(id<NSObject>)value;

+ (NSValue*)rangeValueWithMin:(NSInteger)min max:(NSInteger)max;
/** An expression that uses a DKNumericStatistic dependency as a lookup key for a value. */
+ (NSExpression*)valueFromPiecewiseFunctionRanges:(NSDictionary*)ranges usingDependency:(NSString*)dependencyKey;

/** An expression that uses a DKNumericStatistic dependency and converts it into a DKDiceCollection value. */
+ (NSExpression*)valueAsDiceCollectionFromNumericDependency:(NSString*)dependencyKey;
+ (NSExpression*)valueAsDiceCollectionFromExpression:(NSExpression*)numericExpression;

@end

#pragma mark -
#pragma mark DKPredicateBuilder

@interface DKPredicateBuilder : NSObject

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