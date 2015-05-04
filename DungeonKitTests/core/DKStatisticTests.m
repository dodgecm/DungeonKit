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
#import "DKModifierBuilder.h"

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
    
    XCTAssertNotNil([[DKNumericStatistic alloc] initWithBase:10], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKNumericStatistic statisticWithBase:10], @"Constructors should return non-nil object.");
}

- (void)testModifiers {
    DKNumericStatistic* stat = [[DKNumericStatistic alloc] initWithBase:10];
    XCTAssertEqualObjects(stat.base, @10, @"Unmodified statistic should start with correct score.");
    XCTAssertEqualObjects(stat.value, @10 , @"Unmodified statistic should start with correct score.");
    
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.base, @10, @"Modified statistic should calculate correct score.");
    XCTAssertEqualObjects(stat.value, @15, @"Modified statistic should calculate correct score.");
    XCTAssert([[stat modifiers] containsObject:modifier], @"Modified statistic should update its fields properly.");
    
    modifier.value = 3;
    XCTAssertEqualObjects(stat.value, @13, @"Modified statistic should update score when modifier value is changed.");
    [modifier removeFromStatistic];
    XCTAssertEqualObjects(stat.value, @10, @"Modified statistic should update score when modifier is removed.");
    modifier.value = 5;
    XCTAssertEqualObjects(stat.value, @10, @"Modified statistic should not update score when removed modifier is changed after the fact.");
}

- (void)testModifierSorting {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithBase:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    DKModifier* secondModifier = [DKModifierBuilder modifierWithMinimum:18];
    [stat applyModifier:secondModifier];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @18, @"Modifiers should be applied in the correct value.");
}

- (void)testModifierFiltering {
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithBase:10];
    DKModifier* firstModifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    DKModifier* secondModifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    DKModifier* thirdModifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    DKModifier* fourthModifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:firstModifier];
    [stat applyModifier:secondModifier];
    [stat applyModifier:thirdModifier];
    [stat applyModifier:fourthModifier];
    firstModifier.enabled = NO;
    thirdModifier.enabled = NO;
    
    NSArray* enabledModifiers = [stat enabledModifiers];
    XCTAssertFalse([enabledModifiers containsObject:firstModifier], @"Modifiers should get filtered correctly.");
    XCTAssertFalse([enabledModifiers containsObject:thirdModifier], @"Modifiers should get filtered correctly.");
    XCTAssertTrue([enabledModifiers containsObject:secondModifier], @"Modifiers should get filtered correctly.");
    XCTAssertTrue([enabledModifiers containsObject:fourthModifier], @"Modifiers should get filtered correctly.");
    
    NSArray* disabledModifiers = [stat disabledModifiers];
    XCTAssertTrue([disabledModifiers containsObject:firstModifier], @"Modifiers should get filtered correctly.");
    XCTAssertTrue([disabledModifiers containsObject:thirdModifier], @"Modifiers should get filtered correctly.");
    XCTAssertFalse([disabledModifiers containsObject:secondModifier], @"Modifiers should get filtered correctly.");
    XCTAssertFalse([disabledModifiers containsObject:fourthModifier], @"Modifiers should get filtered correctly.");
}

- (void)testModifierAdditionErrorCase {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithBase:10];
    [stat applyModifier:nil];
}

- (void)testModifierRemovalErrorCase {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithBase:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat removeModifier:modifier];
    [stat removeModifier:nil];
}
@end
