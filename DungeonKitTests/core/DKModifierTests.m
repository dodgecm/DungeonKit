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
    
    DKStatistic* stat = [[DKStatistic alloc] initWithBase:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    XCTAssertEqual(modifier.value, 5, @"Modifier fields should reflect its state properly.");
    XCTAssertNil(modifier.owner, @"Modifier fields should reflect its state properly.");
    [stat applyModifier:modifier];
    XCTAssertEqual(modifier.owner, stat, @"Modifier fields should reflect its state properly.");
    [modifier removeFromStatistic];
    XCTAssertNil(modifier.owner, @"Modifier fields should reflect its state properly.");
}

- (void)testValueChange {
    
    DKStatistic* stat = [[DKStatistic alloc] initWithBase:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqual(stat.value, 15, @"Statistic should update score when modifier value is changed.");
    modifier.value = 3;
    XCTAssertEqual(stat.value, 13, @"Statistic should update score when modifier value is changed.");
}


- (void)testModifierOnTwoStatistics {
    
    //Modifier should only be allowed on one statistic at a time
    DKStatistic* stat = [[DKStatistic alloc] initWithBase:10];
    DKStatistic* stat2 = [[DKStatistic alloc] initWithBase:15];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    [stat2 applyModifier:modifier];
    XCTAssertEqual(stat.value, 10, @"Modifier should only belong to one statistic at a time.");
    XCTAssertEqual(stat2.value, 20, @"Modifier should only belong to one statistic at a time.");
}

- (void)testInformationalModifier {
    
    DKStatistic* stat = [[DKStatistic alloc] initWithBase:10];
    DKModifier* modifier = [DKModifierBuilder modifierWithExplanation:@"This is a modifier that does not change a statistic's value."];
    [stat applyModifier:modifier];
    XCTAssertEqual(stat.value, 10, @"Informational modifier should not change statistic's value.");
}

@end
