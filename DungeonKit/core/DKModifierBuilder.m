//
//  DKExpressionBuilder.m
//  DungeonKit
//
//  Created by Christopher Dodge on 5/4/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKModifierBuilder.h"
#import "DKDiceCollection.h"

@implementation DKModifier(Base)

/** Initializes a modifier with no mathematical effects */
+ (instancetype)modifierWithExplanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier modifierWithValue:@(0)
                                                priority:kDKModifierPriority_Informational
                                              expression:[NSExpression expressionForVariable:@"input"]];
    modifier.explanation = explanation;
    return modifier;
}

+ (instancetype)modifierWithValue:(id<NSObject>)value
                         priority:(DKModifierPriority)priority
                       expression:(NSExpression*)expression {
    
    DKModifier* modifier = [[DKModifier alloc] initWithValue:value
                                                    priority:priority
                                                  expression:expression];
    return modifier;
}

+ (instancetype)modifierFromSource:(NSObject<DKDependency>*)source
                           enabled:(NSPredicate*)enabledPredicate
                       explanation:(NSString*)explanation {
    
    DKModifier* modifier = [[DKModifier alloc] initWithSource:source
                                                        value:nil
                                                      enabled:enabledPredicate
                                                     priority:kDKModifierPriority_Informational
                                                   expression:nil];
    modifier.explanation = explanation;
    return modifier;
}

@end

@implementation DKModifier (Numeric)

+ (instancetype)numericModifierWithAdditiveBonus:(NSInteger)bonus {
    
    DKModifier* modifier = [DKModifier modifierWithValue:@(bonus)
                                                priority:kDKModifierPriority_Additive
                                              expression:[DKExpressionBuilder additionExpression]];
    modifier.expectedInputType = [NSNumber class];
    modifier.expectedValueType = [NSNumber class];
    return modifier;
}

+ (instancetype)numericModifierWithAdditiveBonus:(NSInteger)bonus explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:bonus];
    modifier.explanation = explanation;
    return modifier;
}

+ (instancetype)numericModifierWithMin:(NSInteger)min {
    
    NSExpression* maxExpression =  [NSExpression expressionWithFormat:@"max:({%i, $input})", min];
    DKModifier* modifier = [DKModifier modifierWithValue:@(0)
                                                priority:kDKModifierPriority_Clamping
                                              expression:maxExpression];
    modifier.expectedInputType = [NSNumber class];
    modifier.expectedValueType = [NSNumber class];
    return modifier;
}

+ (instancetype)numericModifierWithClampBetween:(NSInteger)min and:(NSInteger)max {
    
    NSExpression* clampExpression =  [NSExpression expressionWithFormat:@"min:({%i, max:({%i, $input}) })", max, min];
    DKModifier* modifier = [DKModifier modifierWithValue:@(0)
                                                priority:kDKModifierPriority_Clamping
                                              expression:clampExpression];
    modifier.expectedInputType = [NSNumber class];
    modifier.expectedValueType = [NSNumber class];
    return modifier;
}

+ (instancetype)numericModifierWithClampBetween:(NSInteger)min and:(NSInteger)max explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier numericModifierWithClampBetween:min and:max];
    modifier.explanation = explanation;
    return modifier;
}

+ (instancetype)numericModifierAddedFromSource:(NSObject<DKDependency>*)source {
    
    DKModifier* modifier = [[DKModifier alloc] initWithSource:source
                                                        value:[DKExpressionBuilder valueFromDependency:@"source"]
                                                     priority:kDKModifierPriority_Additive
                                                   expression:[DKExpressionBuilder additionExpression]];
    modifier.expectedInputType = [NSNumber class];
    modifier.expectedValueType = [NSNumber class];
    return modifier;
}

+ (instancetype)numericModifierAddedFromSource:(NSObject<DKDependency>*)source
                                 constantValue:(id)constantValue
                                       enabled:(NSPredicate*)enabledPredicate {
    
    DKModifier* modifier = [[DKModifier alloc] initWithSource:source
                                                        value:[DKExpressionBuilder valueFromObject:constantValue]
                                                      enabled:enabledPredicate
                                                     priority:kDKModifierPriority_Additive
                                                   expression:[DKExpressionBuilder additionExpression]];
    modifier.expectedInputType = [NSNumber class];
    modifier.expectedValueType = [NSNumber class];
    return modifier;
}

@end

@implementation DKModifier (String)

/** Replaces the existing value of the string modifier with the new string */
+ (instancetype)stringModifierWithNewString:(NSString*)string {
    
    DKModifier* modifier = [DKModifier modifierWithValue:string
                                                priority:kDKModifierPriority_Additive
                                              expression:[NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                                                                selectorName:@"stringByReplacingWithString:"
                                                                                   arguments:@[ [NSExpression expressionForVariable:@"value"] ] ] ];
    modifier.expectedInputType = [NSString class];
    modifier.expectedValueType = [NSString class];
    return modifier;
}

@end

@implementation DKModifier (Set)

+ (instancetype)setModifierWithAppendedObject:(NSObject*)objectToAppend {
    
    DKModifier* modifier = [DKModifier modifierWithValue:objectToAppend
                                                priority:kDKModifierPriority_Additive
                                              expression:[DKExpressionBuilder appendExpression]];
    modifier.expectedInputType = [NSSet class];
    modifier.expectedValueType = [NSObject class];
    return modifier;
}

+ (instancetype)setModifierWithAppendedObject:(NSObject*)objectToAppend explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier setModifierWithAppendedObject:objectToAppend];
    modifier.explanation = explanation;
    return modifier;
}

+ (instancetype)setModifierAppendedFromSource:(NSObject<DKDependency>*)source
                                        value:(NSExpression*)valueExpression
                                      enabled:(NSPredicate*)enabledPredicate {
    
    DKModifier* modifier = [[DKModifier alloc] initWithSource:source
                                                        value:valueExpression
                                                      enabled:enabledPredicate
                                                     priority:kDKModifierPriority_Additive
                                                   expression:[DKExpressionBuilder appendExpression]];
    modifier.expectedInputType = [NSSet class];
    modifier.expectedValueType = [NSObject class];
    return modifier;
}

+ (instancetype)setModifierAppendedFromSource:(NSObject<DKDependency>*)source
                                constantValue:(id)constantValue
                                      enabled:(NSPredicate*)enabledPredicate
                                  explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier setModifierAppendedFromSource:source
                                                               value:[DKExpressionBuilder valueFromObject:constantValue]
                                                             enabled:enabledPredicate];
    modifier.explanation = explanation;
    return modifier;
}

@end

@implementation DKModifier (Dice)

+ (instancetype)diceModifierWithAddedDice:(DKDiceCollection*)collection {
    
    DKModifier* modifier = [DKModifier modifierWithValue:collection
                                                priority:kDKModifierPriority_Additive
                                              expression:[DKExpressionBuilder addDiceExpression]];
    modifier.expectedInputType = [DKDiceCollection class];
    modifier.expectedValueType = [DKDiceCollection class];
    return modifier;
}

+ (instancetype)diceModifierAddedFromSource:(NSObject<DKDependency>*)source {
    
    DKModifier* modifier = [[DKModifier alloc] initWithSource:source
                                                        value:[DKExpressionBuilder valueFromDependency:@"source"]
                                                      enabled:nil
                                                     priority:kDKModifierPriority_Additive
                                                   expression:[DKExpressionBuilder addDiceExpression]];
    modifier.expectedInputType = [DKDiceCollection class];
    modifier.expectedValueType = [DKDiceCollection class];
    return modifier;
}

+ (instancetype)diceModifierAddedFromSource:(NSObject<DKDependency>*)source
                                      value:(NSExpression*)valueExpression
                                    enabled:(NSPredicate*)enabledPredicate {
    
    DKModifier* modifier = [[DKModifier alloc] initWithSource:source
                                                        value:valueExpression
                                                      enabled:enabledPredicate
                                                     priority:kDKModifierPriority_Additive
                                                   expression:[DKExpressionBuilder addDiceExpression]];
    modifier.expectedInputType = [DKDiceCollection class];
    modifier.expectedValueType = [DKDiceCollection class];
    return modifier;
}

@end

@implementation DKExpressionBuilder

+ (NSExpression*)additionExpression {
    return [NSExpression expressionWithFormat:@"$input+$value"];
}

+ (NSExpression*)clampExpressionBetween:(NSInteger)min and:(NSInteger)max {
    
    return [NSExpression expressionWithFormat:@"min:({%i, max:({%i, $input}) })", max, min];
}

+ (NSExpression*)appendExpression {
    return [NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                  selectorName:@"setByAddingObject:"
                                     arguments:@[ [NSExpression expressionForVariable:@"value"] ] ];
}

+ (NSExpression*)appendObjectsInSetExpression {
    
    return [NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                  selectorName:@"setByAddingObjectsFromSet:"
                                     arguments:@[ [NSExpression expressionForVariable:@"value"] ] ];
}

+ (NSExpression*)addDiceExpression {
    return [NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                  selectorName:@"diceByAddingDice:"
                                     arguments:@[ [NSExpression expressionForVariable:@"value"] ] ];
}

+ (NSExpression*)replaceStringExpression {
    return [NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                  selectorName:@"stringByReplacingWithString:"
                                     arguments:@[ [NSExpression expressionForVariable:@"value"] ] ];
}

+ (NSExpression*)valueFromDependency:(NSString*)dependencyKey {
    return [NSExpression expressionForVariable:dependencyKey];
}

+ (NSExpression*)valueFromInteger:(NSInteger)value {
    return [NSExpression expressionForConstantValue:@(value)];
}

+ (NSExpression*)valueFromObject:(id<NSObject>)value {
    return [NSExpression expressionForConstantValue:value];
}

+ (NSValue*)rangeValueWithMin:(NSInteger)min max:(NSInteger)max {
    return [NSValue valueWithRange:NSMakeRange(min, max + 1 - min)];
}

+ (NSExpression*)valueFromPiecewiseFunctionRanges:(NSDictionary*)ranges usingDependency:(NSString*)dependencyKey {
    
    NSMutableDictionary* piecewiseFunction = [NSMutableDictionary dictionary];
    for (NSValue* key in ranges.allKeys) {
        NSRange range = key.rangeValue;
        NSNumber* value = ranges[key];
        for (NSInteger j = range.location; j < range.location + range.length; j++) {
            piecewiseFunction[@(j)] = value;
        }
    }
    return [NSExpression expressionForFunction:[NSExpression expressionForConstantValue:piecewiseFunction]
                                  selectorName:@"objectForKey:"
                                     arguments:@[ [NSExpression expressionForVariable:dependencyKey] ] ];
}

+ (NSExpression*)valueAsDiceCollectionFromNumericDependency:(NSString*)dependencyKey {
    
    return [DKExpressionBuilder valueAsDiceCollectionFromExpression:[NSExpression expressionForVariable:dependencyKey]];
}

+ (NSExpression*)valueAsDiceCollectionFromExpression:(NSExpression*)numericExpression {
    
    return [NSExpression expressionForFunction:[NSExpression expressionForConstantValue:[DKDiceCollection diceCollection]]
                                  selectorName:@"diceByAddingModifier:"
                                     arguments:@[ numericExpression ] ];
}

@end

@implementation DKPredicateBuilder

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isGreaterThanOrEqualTo:(NSInteger)threshold {
    
    // $dependencyName >= threshold
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                              rightExpression:[NSExpression expressionForConstantValue:@(threshold)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSGreaterThanOrEqualToPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToOrBetween:(NSInteger)lowThreshold and:(NSInteger)highThreshold {
    
    // ($dependencyName >= lowThreshold) && ($dependencyName <= highThreshold)
    NSPredicate* firstPredicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                                                     rightExpression:[NSExpression expressionForConstantValue:@(lowThreshold)]
                                                                            modifier:NSDirectPredicateModifier
                                                                                type:NSGreaterThanOrEqualToPredicateOperatorType
                                                                             options:0];
    
    NSPredicate* secondPredicate = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                                                      rightExpression:[NSExpression expressionForConstantValue:@(highThreshold)]
                                                                             modifier:NSDirectPredicateModifier
                                                                                 type:NSLessThanOrEqualToPredicateOperatorType
                                                                              options:0];
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[firstPredicate, secondPredicate]];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isLessThan:(NSInteger)threshold {
    
    // $dependencyName < threshold
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                              rightExpression:[NSExpression expressionForConstantValue:@(threshold)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSLessThanPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToString:(NSString*)string {
    
    NSExpression* equalityExpression = [NSExpression expressionForFunction:[NSExpression expressionForVariable:dependencyName]
                                                              selectorName:@"isEqualToStringAsNumber:"
                                                                 arguments:@[ [NSExpression expressionForConstantValue:string] ] ];
    return [NSComparisonPredicate predicateWithLeftExpression:equalityExpression
                                              rightExpression:[NSExpression expressionForConstantValue:@(YES)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSEqualToPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToAnyFromStrings:(NSArray*)objects {
    
    NSExpression* equalityExpression = [NSExpression expressionForFunction:[NSExpression expressionForVariable:dependencyName]
                                                              selectorName:@"isEqualToAnyStringsAsNumber:"
                                                                 arguments:@[ [NSExpression expressionForConstantValue:objects] ] ];
    return [NSComparisonPredicate predicateWithLeftExpression:equalityExpression
                                              rightExpression:[NSExpression expressionForConstantValue:@(YES)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSEqualToPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName containsObject:(id)object {
    
    NSExpression* containsObjectExpression = [NSExpression expressionForFunction:[NSExpression expressionForVariable:dependencyName]
                                                                    selectorName:@"containsObjectAsNumber:"
                                                                       arguments:@[ [NSExpression expressionForConstantValue:object] ] ];
    return [NSComparisonPredicate predicateWithLeftExpression:containsObjectExpression
                                              rightExpression:[NSExpression expressionForConstantValue:@(YES)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSEqualToPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName containsAnyFromObjects:(NSArray*)objects {
    
    NSExpression* containsObjectExpression = [NSExpression expressionForFunction:[NSExpression expressionForVariable:dependencyName]
                                                                    selectorName:@"containsAnyObjectsAsNumber:"
                                                                       arguments:@[ [NSExpression expressionForConstantValue:objects] ] ];
    return [NSComparisonPredicate predicateWithLeftExpression:containsObjectExpression
                                              rightExpression:[NSExpression expressionForConstantValue:@(YES)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSEqualToPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName doesNotContainAnyFromObjects:(NSArray*)objects {
    
    NSExpression* containsObjectExpression = [NSExpression expressionForFunction:[NSExpression expressionForVariable:dependencyName]
                                                                    selectorName:@"containsAnyObjectsAsNumber:"
                                                                       arguments:@[ [NSExpression expressionForConstantValue:objects] ] ];
    return [NSComparisonPredicate predicateWithLeftExpression:containsObjectExpression
                                              rightExpression:[NSExpression expressionForConstantValue:@(NO)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSEqualToPredicateOperatorType
                                                      options:0];
}

@end

@implementation NSString (DungeonKit)

- (NSNumber*)isEqualToStringAsNumber:(NSString *)aString {
    return @([self isEqualToString:aString]);
}

- (NSNumber*)isEqualToAnyStringsAsNumber:(NSArray*)stringArray {
    for (id object in stringArray) {
        if ([self isEqualToString:object]) {
            return @(YES);
        }
    }
    return @(NO);
}

- (NSString*)stringByReplacingWithString:(NSString*)aString {
    return [NSString stringWithString:aString];
}

@end

@implementation NSArray (DungeonKit)

- (NSNumber*)containsObjectAsNumber:(id)anObject {
    return @([self containsObject:anObject]);
}

- (NSNumber*)containsAnyObjectsAsNumber:(NSArray*)objectArray {
    for (id object in objectArray) {
        if ([self containsObject:object]) {
            return @(YES);
        }
    }
    return @(NO);
}

@end

@implementation NSSet (DungeonKit)

- (NSNumber*)containsObjectAsNumber:(id)anObject {
    return @([self containsObject:anObject]);
}

- (NSNumber*)containsAnyObjectsAsNumber:(NSArray*)objectArray {
    for (id object in objectArray) {
        if ([self containsObject:object]) {
            return @(YES);
        }
    }
    return @(NO);
}

@end