//
//  DKDependantModifierTests.m
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatistic.h"
#import "DKModifierBuilder.h"

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
    
    DKStatistic* statistic = [[DKNumericStatistic alloc] initWithInt:10];
    XCTAssertNotNil([DKModifier numericModifierAddedFromSource:statistic], @"Constructors should return non-nil object.");
}

- (void)testDependentModifier {
    
    DKNumericStatistic* firstStatistic = [[DKNumericStatistic alloc] initWithInt:2];
    DKNumericStatistic* secondStatistic = [[DKNumericStatistic alloc] initWithInt:14];
    DKModifier* modifier = [DKModifier numericModifierAddedFromSource:firstStatistic];
    [secondStatistic applyModifier:modifier];
    XCTAssertEqualObjects(secondStatistic.value, @16, @"Dependant modifier should be applied correctly.");
    firstStatistic.base = @4;
    XCTAssertEqualObjects(secondStatistic.value, @18, @"Dependant modifier should be updated correctl when owner statistic changes.");
    [modifier removeFromStatistic];
    XCTAssertEqualObjects(secondStatistic.value, @14, @"Dependant modifier should be removed correctly.");
}

- (void)testEnabled {
    
    DKNumericStatistic* firstStatistic = [[DKNumericStatistic alloc] initWithInt:2];
    DKNumericStatistic* secondStatistic = [[DKNumericStatistic alloc] initWithInt:14];
    DKModifier* modifier = [DKModifier numericModifierAddedFromSource:firstStatistic];
    [secondStatistic applyModifier:modifier];
    
}

- (void)testSimpleCycle {
    
    DKStatistic* firstStatistic = [[DKNumericStatistic alloc] initWithInt:1];
    DKModifier* firstModifier = [DKModifier numericModifierAddedFromSource:firstStatistic];
    [firstStatistic applyModifier:firstModifier];
    XCTAssert(![[firstStatistic modifiers] containsObject:firstModifier], @"Dependent modifier should not successfully add itself to its source statistic.");
}

- (void)testModifierInfiniteCycle {
    
    DKStatistic* firstStatistic = [[DKNumericStatistic alloc] initWithInt:1];
    DKStatistic* secondStatistic = [[DKNumericStatistic alloc] initWithInt:2];
    DKModifier* firstModifier = [DKModifier numericModifierAddedFromSource:firstStatistic];
    DKModifier* secondModifier = [DKModifier numericModifierAddedFromSource:secondStatistic];
    [secondStatistic applyModifier:firstModifier];
    [firstStatistic applyModifier:secondModifier];
    XCTAssert([[secondStatistic modifiers] containsObject:firstModifier], @"Dependent modifier should add itself as long as it doesn't create a cycle.");
    XCTAssert(![[firstStatistic modifiers] containsObject:secondModifier], @"Dependent modifier should not successfully add itself if it would create a cycle.");
}

- (void)testAutoEnable {
    
    DKNumericStatistic* firstStatistic = [[DKNumericStatistic alloc] initWithInt:0];
    DKNumericStatistic* secondStatistic = [[DKNumericStatistic alloc] initWithInt:5];
    DKModifier* modifier = [[DKModifier alloc] initWithSource:firstStatistic
                                                        value:[NSExpression expressionForConstantValue:@(5)]
                                                      enabled:[DKPredicateBuilder enabledWhen:@"source"
                                                                               isGreaterThanOrEqualTo:10]
                                                     priority:kDKModifierPriority_Additive
                                                   expression:[DKExpressionBuilder additionExpression]];
    
    [secondStatistic applyModifier:modifier];
    XCTAssertFalse(modifier.enabled, @"Modifier should be disabled since first statistic is below the threshold.");
    XCTAssertTrue([secondStatistic.disabledModifiers containsObject:modifier], @"Modifier should be disabled since first statistic is below the threshold.");
    
    firstStatistic.base = @10;
    XCTAssertTrue(modifier.enabled, @"Modifier should be enabled since first statistic is at the threshold.");
    XCTAssertTrue([secondStatistic.enabledModifiers containsObject:modifier], @"Modifier should be enabled since first statistic is at the threshold.");
    
    firstStatistic.base = @0;
    XCTAssertFalse(modifier.enabled, @"Modifier should be disabled since first statistic is below the threshold.");
    XCTAssertTrue([secondStatistic.disabledModifiers containsObject:modifier], @"Modifier should be disabled since first statistic is below the threshold.");
}

- (void)testMultipleDependencies {
    
    DKStatistic* firstStatistic = [[DKNumericStatistic alloc] initWithInt:1];
    DKStatistic* secondStatistic = [[DKNumericStatistic alloc] initWithInt:2];
    DKStatistic* thirdStatistic = [[DKNumericStatistic alloc] initWithInt:3];
    
    DKModifier* dependenciesModifier = [[DKModifier alloc] initWithDependencies: @{ @"abc": firstStatistic,
                                                                                    @"dfe": secondStatistic }
                                                                          value:[NSExpression expressionWithFormat:@"$abc+$dfe"]
                                                                        enabled:nil
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKExpressionBuilder additionExpression]];
    [thirdStatistic applyModifier:dependenciesModifier];
    XCTAssertEqualObjects(thirdStatistic.value, @6, @"Multiple dependency modifier should add proper value to its statistic.");
}

- (void)testReservedExpressionStrings {
    
    DKStatistic* statistic = [[DKNumericStatistic alloc] initWithInt:1];
    DKStatistic* badStatistic = [[DKNumericStatistic alloc] initWithInt:1];
    DKModifier* dependenciesModifier = [[DKModifier alloc] initWithDependencies: @{ @"abc": statistic }
                                                                          value:[NSExpression expressionWithFormat:@"$abc"]
                                                                        enabled:nil
                                                                       priority:kDKModifierPriority_Additive
                                                                     expression:[DKExpressionBuilder additionExpression]];
    XCTAssertThrows([dependenciesModifier addDependency:badStatistic forKey:@"first"], @"Should not be able to use the reserved key name.");
}

- (void)testPredicateBuilders {
    
    NSPredicate* predicate = [DKPredicateBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:10];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(10)}], @"Predicate should return correct result.");
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(15)}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(5)}], @"Predicate should return correct result.");
    
    predicate = [DKPredicateBuilder enabledWhen:@"source" isEqualToOrBetween:10 and:15];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(10)}], @"Predicate should return correct result.");
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(15)}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(5)}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @(20)}], @"Predicate should return correct result.");
    
    predicate = [DKPredicateBuilder enabledWhen:@"source" isEqualToString:@"thisvalue"];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @"thisvalue"}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @"notthisvalue"}], @"Predicate should return correct result.");
    
    predicate = [DKPredicateBuilder enabledWhen:@"source" isEqualToAnyFromStrings:@[@"thisvalue", @"thisvaluetoo"]];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @"thisvalue"}], @"Predicate should return correct result.");
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @"thisvaluetoo"}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": @"notthisvalue"}], @"Predicate should return correct result.");
    
    predicate = [DKPredicateBuilder enabledWhen:@"source" containsObject:@"thisvalue"];
    NSArray* trueValues = @[@"thisvalue", @"notthisvalue"];
    NSArray* falseValues = @[@"alsonotthisvalue", @"notthisvalue"];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": trueValues}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": falseValues}], @"Predicate should return correct result.");
    
    predicate = [DKPredicateBuilder enabledWhen:@"source" containsAnyFromObjects:@[@"thisvalue", @"thisonetoo"]];
    XCTAssertTrue([predicate evaluateWithObject:nil substitutionVariables:@{@"source": trueValues}], @"Predicate should return correct result.");
    XCTAssertFalse([predicate evaluateWithObject:nil substitutionVariables:@{@"source": falseValues}], @"Predicate should return correct result.");
}

- (void) testExpressionBuilders {
    
    NSDictionary* piecewiseFunction = @{ [NSValue valueWithRange:NSMakeRange(0, 2)] : @(2),
                                         [NSValue valueWithRange:NSMakeRange(2, 2)] : @(4),
                                         [NSValue valueWithRange:NSMakeRange(4, 2)] : @(6) };
    NSExpression* expression = [DKExpressionBuilder valueFromPiecewiseFunctionRanges:piecewiseFunction
                                                                     usingDependency:@"source"];
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    
    context[@"source"] = @(-1);
    XCTAssertNil([expression expressionValueWithObject:nil context:context], @"Piecewise function should return correct result.");
    
    context[@"source"] = @(0);
    XCTAssertEqualObjects([expression expressionValueWithObject:nil context:context], @(2), @"Piecewise function should return correct result.");
    context[@"source"] = @(1);
    XCTAssertEqualObjects([expression expressionValueWithObject:nil context:context], @(2), @"Piecewise function should return correct result.");
    
    context[@"source"] = @(2);
    XCTAssertEqualObjects([expression expressionValueWithObject:nil context:context], @(4), @"Piecewise function should return correct result.");
    context[@"source"] = @(3);
    XCTAssertEqualObjects([expression expressionValueWithObject:nil context:context], @(4), @"Piecewise function should return correct result.");
    
    context[@"source"] = @(4);
    XCTAssertEqualObjects([expression expressionValueWithObject:nil context:context], @(6), @"Piecewise function should return correct result.");
    context[@"source"] = @(5);
    XCTAssertEqualObjects([expression expressionValueWithObject:nil context:context], @(6), @"Piecewise function should return correct result.");
    
    context[@"source"] = @(6);
    XCTAssertNil([expression expressionValueWithObject:nil context:context], @"Piecewise function should return correct result.");
}

- (void)testExpressionBridgeBuilder {
    
    NSExpression* expression = [DKExpressionBuilder valueAsDiceCollectionFromNumericDependency:@"source"];
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    
    DKNumericStatistic* sourceStatistic = [DKNumericStatistic statisticWithInt:5];
    context[@"source"] = sourceStatistic.value;
    DKDiceCollection* collection = [expression expressionValueWithObject:nil context:context];
    XCTAssertTrue([collection isKindOfClass:[DKDiceCollection class]], @"Expression should evaluate to correct type.");
    XCTAssertEqual(collection.modifier, 5, @"Modifier should have the correct value.");
}

- (void)testEncoding {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier numericModifierAddedFromSource:stat];
    [stat applyModifier:modifier];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@%@", documentsDirectory, @"encodeDependentModifierTest"];
    [NSKeyedArchiver archiveRootObject:modifier toFile:filePath];
    
    DKModifier* decodedModifier = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    DKStatistic* owner = [DKNumericStatistic statisticWithInt:5];
    [owner applyModifier:decodedModifier];
    XCTAssertEqualObjects(owner.value, @15, @"Statistic should update value correctly after being decoded.");
}

@end