//
//  DKDiceTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKDice.h"

@interface DKDiceTests : XCTestCase

@end

@implementation DKDiceTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKDice alloc] initWithQuantity:2 sides:6], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKDice diceWithQuantity:4 sides:20], @"Constructors should return non-nil object.");
}

- (void)testRolls {
    DKDice* d6 = [[DKDice alloc] initWithQuantity:1 sides:6];
    NSMutableDictionary* frequency = [NSMutableDictionary dictionary];
    int result;
    for (int i = 0; i < 500; i++) {
        result = [d6 roll];
        frequency[@(result)] = @([frequency[@(result)] intValue] + 1);
    }
    
    for (NSNumber* result in [frequency allKeys]) {
        XCTAssert(result.intValue >= 1 && result.intValue <= d6.quantity.value * d6.sides.value, @"No rolls should fall outside the bounds.");
    }
}

- (void)testMoreRolls {
    DKDice* fiveD20 = [[DKDice alloc] initWithQuantity:5 sides:20];
    NSMutableDictionary* frequency = [NSMutableDictionary dictionary];
    int result;
    for (int i = 0; i < 2000; i++) {
        result = [fiveD20 roll];
        frequency[@(result)] = @([frequency[@(result)] intValue] + 1);
    }
    
    for (NSNumber* result in [frequency allKeys]) {
        XCTAssert(result.intValue >= 1 && result.intValue <= fiveD20.quantity.value * fiveD20.sides.value, @"No rolls should fall outside the bounds.");
    }
}

- (void)testEdgeCases {
    DKDice* zeroD6 = [[DKDice alloc] initWithQuantity:0 sides:6];
    XCTAssertEqual([zeroD6 roll], 0, @"Zero dice should have a result of zero.");
    
    //Kind of undefined functionality, but let's be explicit with our expectations, shall we
    DKDice* d0 = [[DKDice alloc] initWithQuantity:1 sides:0];
    XCTAssertEqual([d0 roll], 0, @"Zero sided dice should have a result of zero.");
}

@end
