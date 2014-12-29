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


@end
