//
//  DKDiceTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKDiceCollection.h"
#import "DKModifierBuilder.h"

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

/*
- (void)testRolls {
    DKDiceCollection* d6 = [[DKDiceCollection alloc] initWithQuantity:1 sides:6];
    NSMutableDictionary* frequency = [NSMutableDictionary dictionary];
    int result;
    for (int i = 0; i < 500; i++) {
        result = [d6 roll];
        frequency[@(result)] = @([frequency[@(result)] intValue] + 1);
    }
    
    for (NSNumber* result in [frequency allKeys]) {
        XCTAssert(result.intValue >= 1 && result.intValue <= d6.quantity.intValue * d6.sides.intValue, @"No rolls should fall outside the bounds.");
    }
}

- (void)testMoreRolls {
    DKDiceCollection* fiveD20 = [[DKDiceCollection alloc] initWithQuantity:5 sides:20];
    NSMutableDictionary* frequency = [NSMutableDictionary dictionary];
    int result;
    for (int i = 0; i < 2000; i++) {
        result = [fiveD20 roll];
        frequency[@(result)] = @([frequency[@(result)] intValue] + 1);
    }
    
    for (NSNumber* result in [frequency allKeys]) {
        XCTAssert(result.intValue >= 1 && result.intValue <= fiveD20.quantity.intValue * fiveD20.sides.intValue, @"No rolls should fall outside the bounds.");
    }
}

- (void)testStringValue {
    DKDiceCollection* d6 = [[DKDiceCollection alloc] initWithQuantity:1 sides:6];
    NSString* strValue = [d6 stringValue];
    XCTAssertEqualObjects(strValue, @"1d6", @"Dice string value should reflect numeric value.");
    
    [d6 applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:-5]];
    strValue = [d6 stringValue];
    XCTAssertEqualObjects(strValue, @"1d6-5", @"Dice string value should reflect numeric value.");
    
    [d6 applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:10]];
    strValue = [d6 stringValue];
    XCTAssertEqualObjects(strValue, @"1d6+5", @"Dice string value should reflect numeric value.");
}

- (void)testEdgeCases {
    DKDiceCollection* zeroD6 = [[DKDiceCollection alloc] initWithQuantity:0 sides:6];
    XCTAssertEqual([zeroD6 roll], 0, @"Zero dice should have a result of zero.");
    
    //Kind of undefined functionality, but let's be explicit with our expectations, shall we
    DKDiceCollection* d0 = [[DKDiceCollection alloc] initWithQuantity:1 sides:0];
    XCTAssertEqual([d0 roll], 0, @"Zero sided dice should have a result of zero.");
    
    //Modifiers solve this edge case...
    DKDiceCollection* dNegative = [[DKDiceCollection alloc] initWithQuantity:1 sides:-5];
    XCTAssertEqual([dNegative roll], 0, @"Negative sided dice should have a result of zero.");
}*/

@end
