//
//  DKModifierBuilder.m
//  DungeonKit
//
//  Created by Christopher Dodge on 5/4/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKModifierBuilder.h"
#import "DKDiceCollection.h"

@implementation DKModifierBuilder

+ (id)modifierWithAdditiveBonus:(NSInteger)bonus {
    
    DKModifier* modifier = [DKModifier modifierWithValue:@(bonus)
                                                       priority:kDKModifierPriority_Additive
                                                     expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    return modifier;
}

+ (id)modifierWithAdditiveBonus:(NSInteger)bonus explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:bonus];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithMinimum:(NSInteger)min {
    
    NSExpression* maxExpression =  [NSExpression expressionWithFormat:@"max:({%i, $input})", min];
    DKModifier* modifier = [DKModifier modifierWithValue:@(0)
                                                priority:kDKModifierPriority_Clamping
                                              expression:maxExpression];
    return modifier;
}

+ (id)modifierWithMinimum:(NSInteger)min explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithMinimum:min];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithClampBetween:(NSInteger)min and:(NSInteger)max {
    
    NSExpression* clampExpression =  [NSExpression expressionWithFormat:@"min:({%i, max:({%i, $input}) })", max, min];
    DKModifier* modifier = [DKModifier modifierWithValue:@(0)
                                                priority:kDKModifierPriority_Clamping
                                              expression:clampExpression];
    return modifier;
}


+ (id)modifierWithClampBetween:(NSInteger)min and:(NSInteger)max explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithClampBetween:min and:max];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithNewString:(NSString*)string {

    DKModifier* modifier = [DKModifier modifierWithValue:string
                                                priority:kDKModifierPriority_Additive
                                              expression:[NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                                                                selectorName:@"stringByReplacingOccurrencesOfString:withString:"
                                                                                   arguments:@[ [NSExpression expressionForVariable:@"input"],
                                                                                                [NSExpression expressionForVariable:@"value"] ] ] ];
    return modifier;
}

+ (id)modifierWithAppendedString:(NSString*)stringToAppend {
    
    return [DKModifierBuilder modifierWithAppendedString:stringToAppend explanation:nil];
}

+ (id)modifierWithAppendedString:(NSString*)stringToAppend explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier modifierWithValue:stringToAppend
                                                priority:kDKModifierPriority_Additive
                                              expression:[DKModifierBuilder simpleAppendModifierExpression]];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithAddedDice:(DKDiceCollection*)collection {
    return [DKModifierBuilder modifierWithAddedDice:collection explanation:nil];
}

+ (id)modifierWithAddedDice:(DKDiceCollection*)collection explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier modifierWithValue:collection
                                                priority:kDKModifierPriority_Additive
                                              expression:[DKModifierBuilder simpleAddDiceModifierExpression]];
    modifier.explanation = explanation;
    return modifier;
}

+ (NSExpression*)simpleAdditionModifierExpression {
    return [NSExpression expressionWithFormat:@"$input+$value"];
}

+ (NSExpression*)simpleClampExpressionBetween:(NSInteger)min and:(NSInteger)max {
    
    return [NSExpression expressionWithFormat:@"min:({%i, max:({%i, $input}) })", max, min];
}

+ (NSExpression*)simpleAppendModifierExpression {
    return [NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                  selectorName:@"setByAddingObject:"
                                     arguments:@[ [NSExpression expressionForVariable:@"value"] ] ];
}

+ (NSExpression*)simpleAddDiceModifierExpression {
    return [NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                  selectorName:@"diceByAddingDice:"
                                     arguments:@[ [NSExpression expressionForVariable:@"value"] ] ];
}

+ (id)modifierWithExplanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifier modifierWithValue:@(0)
                                                priority:kDKModifierPriority_Informational
                                              expression:[NSExpression expressionForVariable:@"input"]];
    modifier.explanation = explanation;
    return modifier;
}

@end


@implementation DKDependentModifierBuilder

+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source {
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:[DKDependentModifierBuilder valueFromDependency:@"source"]
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    return modifier;
}

+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source explanation:(NSString*)explanation {
    DKDependentModifier* modifier = [DKDependentModifierBuilder simpleModifierFromSource:source];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)appendedModifierFromSource:(NSObject<DKDependentModifierOwner>*)source
                           value:(NSExpression*)valueExpression
                         enabled:(NSPredicate*)enabledPredicate
                     explanation:(NSString*)explanation {
    
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:valueExpression
                                                                        enabled:enabledPredicate
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKModifierBuilder simpleAppendModifierExpression]];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)appendedModifierFromSource:(NSObject<DKDependentModifierOwner>*)source
                   constantValue:(id)constantValue
                         enabled:(NSPredicate*)enabledPredicate
                     explanation:(NSString*)explanation {
    return [DKDependentModifierBuilder appendedModifierFromSource:source
                                                            value:[NSExpression expressionForConstantValue:constantValue]
                                                          enabled:enabledPredicate
                                                      explanation:explanation];
}

+ (id)addedDiceModifierFromSource:(NSObject<DKDependentModifierOwner>*)source
                      explanation:(NSString*)explanation {
    
    return [DKDependentModifierBuilder addedDiceModifierFromSource:source
                                                             value:[DKDependentModifierBuilder valueFromDependency:@"source"]
                                                           enabled:nil
                                                       explanation:explanation];
}

+ (id)addedDiceModifierFromSource:(NSObject<DKDependentModifierOwner>*)source
                            value:(NSExpression*)valueExpression
                          enabled:(NSPredicate*)enabledPredicate
                      explanation:(NSString*)explanation {
    
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:valueExpression
                                                                        enabled:enabledPredicate
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKModifierBuilder simpleAddDiceModifierExpression]];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)informationalModifierFromSource:(NSObject<DKDependentModifierOwner>*)source
                              enabled:(NSPredicate*)enabledPredicate
                          explanation:(NSString*)explanation {
    
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:nil
                                                                        enabled:enabledPredicate
                                                                       priority:kDKModifierPriority_Informational
                                                                     expression:nil];
    modifier.explanation = explanation;
    return modifier;
}

+ (NSExpression*)valueFromDependency:(NSString*)dependencyKey {
    return [NSExpression expressionForVariable:dependencyKey];
}

+ (NSExpression*)expressionForConstantInteger:(NSInteger)value {
    return [NSExpression expressionForConstantValue:@(value)];
}

+ (NSExpression*)expressionForConstantValue:(id<NSObject>) value {
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

    return [DKDependentModifierBuilder valueAsDiceCollectionFromExpression:[NSExpression expressionForVariable:dependencyKey]];
}

+ (NSExpression*)valueAsDiceCollectionFromExpression:(NSExpression*)numericExpression {
    
    return [NSExpression expressionForFunction:[NSExpression expressionForConstantValue:[DKDiceCollection diceCollection]]
                                  selectorName:@"diceByAddingModifier:"
                                     arguments:@[ numericExpression ] ];
}

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