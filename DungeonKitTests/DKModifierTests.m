//
//  DKModifierTests.m
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatistic.h"
#import "DKStatisticGroup.h"
#import "DKModifierBuilder.h"

@interface DKModifierTests : XCTestCase

@end

@implementation DKModifierTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([DKModifier numericModifierWithAdditiveBonus:5], @"Constructors should return non-nil object.");
}

- (void)testModifying {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    XCTAssertEqualObjects(modifier.value, @5, @"Modifier fields should reflect its state properly.");
    XCTAssertNil(modifier.owner, @"Modifier fields should reflect its state properly.");
    [stat applyModifier:modifier];
    XCTAssertEqual(modifier.owner, stat, @"Modifier fields should reflect its state properly.");
    [modifier removeFromStatistic];
    XCTAssertNil(modifier.owner, @"Modifier fields should reflect its state properly.");
}

- (void)testValueChange {
    
    DKNumericStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @15, @"Statistic should update score when modifier value is changed.");
    modifier.value = @3;
    XCTAssertEqualObjects(stat.value, @13, @"Statistic should update score when modifier value is changed.");
}


- (void)testModifierOnTwoStatistics {
    
    //Modifier should only be allowed on one statistic at a time
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKStatistic* stat2 = [[DKNumericStatistic alloc] initWithInt:15];
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    [stat2 applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @10, @"Modifier should only belong to one statistic at a time.");
    XCTAssertEqualObjects(stat2.value, @20, @"Modifier should only belong to one statistic at a time.");
}

- (void)testInformationalModifier {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier modifierWithExplanation:@"This is a modifier that does not change a statistic's value."];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @10, @"Informational modifier should not change statistic's value.");
}


- (void)testStatisticUpdates {
    
    DKStatisticGroup* statGroup = [[DKStatisticGroup alloc] init];
    DKNumericStatistic* stat = [[DKNumericStatistic alloc] initWithInt:0];
    [statGroup setStatistic:stat forStatisticID:@"stat"];
    
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    
    [statGroup setStatistic:[[DKNumericStatistic alloc] initWithInt:5] forStatisticID:@"stat"];
    XCTAssertEqualObjects([statGroup statisticForID:@"stat"].value, @10, @"Modifier should get transferred over to the new statistic");
}

- (void)testActiveModifier {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @15, @"Statistic should update score when modifier value is changed.");
    
    modifier.active = NO;
    XCTAssertEqualObjects(stat.value, @10, @"Statistic should update score when enabled value is changed.");
    modifier.active = YES;
    XCTAssertEqualObjects(stat.value, @15, @"Statistic should update score when enabled value is changed.");
}

- (void)testTypeChecking {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [[DKModifier alloc] initWithSource:stat
                                                        value:[DKExpressionBuilder valueFromDependency:@"source"]
                                                     priority:kDKModifierPriority_Additive
                                                   expression:[DKExpressionBuilder additionExpression]];
    modifier.expectedInputType = [NSNumber class];
    modifier.expectedValueType = [NSNumber class];
    
    DKStatistic* target = [[DKNumericStatistic alloc] initWithInt:10];
    XCTAssertNoThrow([modifier modifyStatistic:target.base], @"Modifier should verify the input and value types correctly.");
    
    target = [DKSetStatistic statisticWithEmptySet];
    XCTAssertThrows([modifier modifyStatistic:target.base], @"Modifier should verify the input types correctly.");
    
    modifier.expectedValueType = [NSSet class];
    XCTAssertThrows([modifier refresh], @"Modifier should verify the value types correctly.");
}

- (void)testEncoding {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@%@", documentsDirectory, @"encodeModifierTest"];
    [NSKeyedArchiver archiveRootObject:modifier toFile:filePath];
    
    DKModifier* decodedModifier = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    [stat applyModifier:decodedModifier];
    XCTAssertEqualObjects(stat.value, @15, @"Statistic should update value correctly after being decoded.");
}

@end
