//
//  DKStatisticTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/29/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatistic.h"

@interface DKStatisticTests : XCTestCase

@end

@implementation DKStatisticTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKStatistic alloc] init], @"Constructors should return non-nil object.");
    XCTAssertNotNil([[DKStatistic alloc] initWithBase:10], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKStatistic statisticWithBase:10], @"Constructors should return non-nil object.");
}

- (void)testModifiers {
    DKStatistic* stat = [[DKStatistic alloc] initWithBase:10];
    XCTAssertEqual(stat.base, 10, @"Unmodified statistic should start with correct score.");
    XCTAssertEqual(stat.score, 10 , @"Unmodified statistic should start with correct score.");
    
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqual(stat.base, 10, @"Modified statistic should calculate correct score.");
    XCTAssertEqual(stat.score, 15, @"Modified statistic should calculate correct score.");
    XCTAssert([[stat modifiers] containsObject:modifier], @"Modified statistic should update its fields properly.");
    
    modifier.value = 3;
    XCTAssertEqual(stat.score, 13, @"Modified statistic should update score when modifier value is changed.");
    [modifier removeFromStatistic];
    XCTAssertEqual(stat.score, 10, @"Modified statistic should update score when modifier is removed.");
    modifier.value = 5;
    XCTAssertEqual(stat.score, 10, @"Modified statistic should not update score when removed modifier is changed after the fact.");
}

- (void)testModifierAdditionErrorCase {
    
    DKStatistic* stat = [[DKStatistic alloc] initWithBase:10];
    [stat applyModifier:nil];
}

- (void)testModifierRemovalErrorCase {
    
    DKStatistic* stat = [[DKStatistic alloc] initWithBase:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat removeModifier:modifier];
    [stat removeModifier:nil];
}
@end
