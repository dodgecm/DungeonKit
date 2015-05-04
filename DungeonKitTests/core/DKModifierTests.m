//
//  DKModifierTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatistic.h"
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
    
    XCTAssertNotNil([DKModifierBuilder modifierWithAdditiveBonus:5], @"Constructors should return non-nil object.");
}

- (void)testModifying {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    XCTAssertEqualObjects(modifier.value, @5, @"Modifier fields should reflect its state properly.");
    XCTAssertNil(modifier.owner, @"Modifier fields should reflect its state properly.");
    [stat applyModifier:modifier];
    XCTAssertEqual(modifier.owner, stat, @"Modifier fields should reflect its state properly.");
    [modifier removeFromStatistic];
    XCTAssertNil(modifier.owner, @"Modifier fields should reflect its state properly.");
}

- (void)testValueChange {
    
    DKNumericStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @15, @"Statistic should update score when modifier value is changed.");
    modifier.value = @3;
    XCTAssertEqualObjects(stat.value, @13, @"Statistic should update score when modifier value is changed.");
}


- (void)testModifierOnTwoStatistics {
    
    //Modifier should only be allowed on one statistic at a time
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKStatistic* stat2 = [[DKNumericStatistic alloc] initWithInt:15];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    [stat2 applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @10, @"Modifier should only belong to one statistic at a time.");
    XCTAssertEqualObjects(stat2.value, @20, @"Modifier should only belong to one statistic at a time.");
}

- (void)testInformationalModifier {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithExplanation:@"This is a modifier that does not change a statistic's value."];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @10, @"Informational modifier should not change statistic's value.");
}

- (void)testEnabledModifier {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @15, @"Statistic should update score when modifier value is changed.");
    
    modifier.enabled = NO;
    XCTAssertEqualObjects(stat.value, @10, @"Statistic should update score when enabled value is changed.");
    modifier.enabled = YES;
    XCTAssertEqualObjects(stat.value, @15, @"Statistic should update score when enabled value is changed.");
}

@end
