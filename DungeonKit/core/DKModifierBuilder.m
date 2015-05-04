//
//  DKModifierBuilder.m
//  DungeonKit
//
//  Created by Christopher Dodge on 5/4/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKModifierBuilder.h"

@implementation DKModifierBuilder

+ (id)modifierWithAdditiveBonus:(int)bonus {
    DKModifier* modifier = [[DKModifier alloc] initWithValue:bonus
                                                    priority:kDKModifierPriority_Additive
                                                  expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    return modifier;
}

+ (id)modifierWithAdditiveBonus:(int)bonus explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:bonus];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithMinimum:(int)min {
    
    NSExpression* maxExpression =  [NSExpression expressionWithFormat:@"max:({%i, $input})", min];
    DKModifier* modifier = [[DKModifier alloc] initWithValue:0
                                                    priority:kDKModifierPriority_Clamping
                                                  expression:maxExpression];
    return modifier;
}

+ (id)modifierWithMinimum:(int)min explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithMinimum:min];
    modifier.explanation = explanation;
    return modifier;
}

+ (id)modifierWithClampBetween:(int)min and:(int)max {
    
    NSExpression* clampExpression =  [NSExpression expressionWithFormat:@"min:({%i, max:({%i, $input}) })", max, min];
    DKModifier* modifier = [[DKModifier alloc] initWithValue:0
                                                    priority:kDKModifierPriority_Clamping
                                                  expression:clampExpression];
    return modifier;
}


+ (id)modifierWithClampBetween:(int)min and:(int)max explanation:(NSString*)explanation {
    
    DKModifier* modifier = [DKModifierBuilder modifierWithClampBetween:min and:max];
    modifier.explanation = explanation;
    return modifier;
}

+ (NSExpression*)simpleAdditionModifierExpression {
    return [NSExpression expressionWithFormat:@"$input+$value"];
}

+ (id)modifierWithExplanation:(NSString*)explanation {
    
    DKModifier* modifier = [[DKModifier alloc] initWithValue:0
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

+ (NSExpression*)expressionForConstantValue:(int)value {
    return [NSExpression expressionForConstantValue:@(value)];
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

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isGreaterThanOrEqualTo:(int)threshold {
    
    // $dependencyName >= threshold
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForVariable:dependencyName]
                                              rightExpression:[NSExpression expressionForConstantValue:@(threshold)]
                                                     modifier:NSDirectPredicateModifier
                                                         type:NSGreaterThanOrEqualToPredicateOperatorType
                                                      options:0];
}

+ (NSPredicate*)enabledWhen:(NSString*)dependencyName isEqualToOrBetween:(int)lowThreshold and:(int)highThreshold {
    
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

@end