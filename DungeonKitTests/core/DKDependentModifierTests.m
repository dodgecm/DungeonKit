//
//  DKDependantModifierTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/4/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatistic.h"


@interface DKDependentModifierTests : XCTestCase

@end

@implementation DKDependentModifierTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructor {
    
    DKStatistic* statistic = [[DKStatistic alloc] initWithBase:10];
    XCTAssertNotNil([DKDependentModifierBuilder simpleModifierFromSource:statistic], @"Constructors should return non-nil object.");
}

- (void)testDependentModifier {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:2];
    DKStatistic* secondStatistic = [[DKStatistic alloc] initWithBase:14];
    DKDependentModifier* modifier = [DKDependentModifierBuilder simpleModifierFromSource:firstStatistic];
    [secondStatistic applyModifier:modifier];
    XCTAssertEqual(secondStatistic.value, 16, @"Dependant modifier should be applied correctly.");
    firstStatistic.base = 4;
    XCTAssertEqual(secondStatistic.value, 18, @"Dependant modifier should be updated correctl when owner statistic changes.");
    [modifier removeFromStatistic];
    XCTAssertEqual(secondStatistic.value, 14, @"Dependant modifier should be removed correctly.");
}

- (void)testSimpleCycle {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:1];
    DKDependentModifier* firstModifier = [DKDependentModifierBuilder simpleModifierFromSource:firstStatistic];
    [firstStatistic applyModifier:firstModifier];
    XCTAssert(![[firstStatistic modifiers] containsObject:firstModifier], @"Dependent modifier should not successfully add itself to its source statistic.");
}

- (void)testModifierInfiniteCycle {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:1];
    DKStatistic* secondStatistic = [[DKStatistic alloc] initWithBase:2];
    DKDependentModifier* firstModifier = [DKDependentModifierBuilder simpleModifierFromSource:firstStatistic];
    DKDependentModifier* secondModifier = [DKDependentModifierBuilder simpleModifierFromSource:secondStatistic];
    [secondStatistic applyModifier:firstModifier];
    [firstStatistic applyModifier:secondModifier];
    XCTAssert([[secondStatistic modifiers] containsObject:firstModifier], @"Dependent modifier should add itself as long as it doesn't create a cycle.");
    XCTAssert(![[firstStatistic modifiers] containsObject:secondModifier], @"Dependent modifier should not successfully add itself if it would create a cycle.");
}

- (void)testAutoEnable {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:0];
    DKStatistic* secondStatistic = [[DKStatistic alloc] initWithBase:5];
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:firstStatistic
                                                                          value:[NSExpression expressionForConstantValue:@(5)]
                                                                        enabled:[DKDependentModifierBuilder enabledWhen:@"source"
                                                                                                 isGreaterThanOrEqualTo:10]
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    
    [secondStatistic applyModifier:modifier];
    XCTAssertFalse(modifier.enabled, @"Modifier should be disabled since first statistic is below the threshold.");
    XCTAssertTrue([secondStatistic.disabledModifiers containsObject:modifier], @"Modifier should be disabled since first statistic is below the threshold.");
    
    firstStatistic.base = 10;
    XCTAssertTrue(modifier.enabled, @"Modifier should be enabled since first statistic is at the threshold.");
    XCTAssertTrue([secondStatistic.enabledModifiers containsObject:modifier], @"Modifier should be enabled since first statistic is at the threshold.");
    
    firstStatistic.base = 0;
    XCTAssertFalse(modifier.enabled, @"Modifier should be disabled since first statistic is below the threshold.");
    XCTAssertTrue([secondStatistic.disabledModifiers containsObject:modifier], @"Modifier should be disabled since first statistic is below the threshold.");
}

- (void)testMultipleDependencies {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:1];
    DKStatistic* secondStatistic = [[DKStatistic alloc] initWithBase:2];
    DKStatistic* thirdStatistic = [[DKStatistic alloc] initWithBase:3];
    
    DKDependentModifier* dependenciesModifier = [[DKDependentModifier alloc] initWithDependencies: @{ @"abc": firstStatistic,
                                                                                                      @"dfe": secondStatistic }
                                                                                           value:[NSExpression expressionWithFormat:@"$abc+$dfe"]
                                                                                         enabled:nil
                                                                                        priority:kDKModifierPriority_Additive
                                                                                      expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    [thirdStatistic applyModifier:dependenciesModifier];
    XCTAssertEqual(thirdStatistic.value, 6, @"Multiple dependency modifier should add proper value to its statistic.");
}

- (void)testReservedExpressionStrings {
    
    DKStatistic* statistic = [[DKStatistic alloc] initWithBase:1];
    DKStatistic* badStatistic = [[DKStatistic alloc] initWithBase:1];
    DKDependentModifier* dependenciesModifier = [[DKDependentModifier alloc] initWithDependencies: @{ @"abc": statistic }
                                                                                            value:[NSExpression expressionWithFormat:@"$abc"]
                                                                                          enabled:nil
                                                                                         priority:kDKModifierPriority_Additive
                                                                                       expression:[DKModifierBuilder simpleAdditionModifierExpression]];
    XCTAssertThrows([dependenciesModifier addDependency:badStatistic forKey:@"first"], @"Should not be able to use the reserved key name.");
}

- (void)testPredicateBuilders {
    
    NSPredicate* predicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:10];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(10)}], @"Predicate should return correct result.");
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(15)}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(5)}], @"Predicate should return correct result.");
    
    predicate = [DKDependentModifierBuilder enabledWhen:@"source" isEqualToOrBetween:10 and:15];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(10)}], @"Predicate should return correct result.");
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(15)}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(5)}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(20)}], @"Predicate should return correct result.");
}

@end
