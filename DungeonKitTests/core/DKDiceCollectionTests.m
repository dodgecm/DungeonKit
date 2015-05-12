//
//  DKDiceCollectionTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 5/10/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKDiceCollection.h"

@interface DKDiceCollectionTests : XCTestCase

@end

@implementation DKDiceCollectionTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    XCTAssertNotNil([DKDiceCollection diceCollection], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKDiceCollection diceCollectionWithQuantity:2 sides:2 modifier:0], @"Constructors should return non-nil object.");
    XCTAssertNotNil([[DKDiceCollection alloc] init], @"Constructors should return non-nil object.");
    XCTAssertNotNil([[DKDiceCollection alloc] initWithQuantity:1 sides:4 modifier:4], @"Constructors should return non-nil object.");
    NSDictionary* dice = @{ @20:@6, @4:@2 };
    XCTAssertNotNil([[DKDiceCollection alloc] initWithDictionary:dice modifier:-2], @"Constructors should return non-nil object.");
    XCTAssertNotNil([[DKDiceCollection alloc] initWithDiceCollection:[DKDiceCollection diceCollection]], @"Constructors should return non-nil object.");
}

- (void)testConstructorValues {
    
    DKDiceCollection* collection = [DKDiceCollection diceCollection];
    XCTAssertEqualObjects(collection.stringValue, @"", @"Collection should have empty string with no dice.");
    collection = [[DKDiceCollection alloc] init];
    XCTAssertEqualObjects(collection.stringValue, @"", @"Collection should have empty string with no dice.");
    
    collection = [DKDiceCollection diceCollectionWithQuantity:2 sides:6 modifier:3];
    XCTAssertEqualObjects(collection.stringValue, @"2d6+3", @"Collection should have values initialized properly.");
    collection = [[DKDiceCollection alloc] initWithQuantity:2 sides:6 modifier:-3];
    XCTAssertEqualObjects(collection.stringValue, @"2d6-3", @"Collection should have values initialized properly.");
    
    NSDictionary* dice = @{ @20:@6,
                            @4:@2 };
    collection = [[DKDiceCollection alloc] initWithDictionary:dice modifier:-1];
    XCTAssertEqualObjects(collection.stringValue, @"6d20+2d4-1", @"Collection should have values initialized properly.");
    collection = [[DKDiceCollection alloc] initWithDiceCollection:collection];
    XCTAssertEqualObjects(collection.stringValue, @"6d20+2d4-1", @"Collection should have values initialized properly.");
}

- (void)testAdders {
    
    NSDictionary* dice = @{ @20:@6,
                            @4:@2 };
    DKDiceCollection* collection = [[DKDiceCollection alloc] initWithDictionary:dice modifier:-1];
    DKDiceCollection* sumCollection = [collection diceByAddingModifier:@4];
    XCTAssertEqualObjects(sumCollection.stringValue, @"6d20+2d4+3", @"Collection should be added properly.");
    
    sumCollection = [collection diceByAddingQuantity:@(-2) sides:@20];
    XCTAssertEqualObjects(sumCollection.stringValue, @"4d20+2d4-1", @"Collection should be added properly.");
    
    sumCollection = [collection diceByAddingDice:collection];
    XCTAssertEqualObjects(sumCollection.stringValue, @"12d20+4d4-2", @"Collection should be added properly.");
}

- (void)testStringValue {
    
    DKDiceCollection* collection = [DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0];
    XCTAssertEqualObjects(@"1d6", [collection stringValue], @"Dice collection should serialize itself properly.");
    
    collection = [collection diceByAddingModifier:@(3)];
    XCTAssertEqualObjects(@"1d6+3", [collection stringValue], @"Dice collection should serialize itself properly.");
    
    collection = [collection diceByAddingModifier:@(-6)];
    XCTAssertEqualObjects(@"1d6-3", [collection stringValue], @"Dice collection should handle negative modifiers properly.");
    
    collection = [collection diceByAddingQuantity:@(2) sides:@(3)];
    XCTAssertEqualObjects(@"1d6+2d3-3", [collection stringValue], @"Dice collection should handle multiple dice groups properly.");
    
    collection = [collection diceByAddingQuantity:@(-4) sides:@(3)];
    XCTAssertEqualObjects(@"1d6-2d3-3", [collection stringValue], @"Dice collection should handle negative dice groups properly.");
    
    collection = [collection diceByAddingQuantity:@(2) sides:@(3)];
    XCTAssertEqualObjects(@"1d6-3", [collection stringValue], @"Dice collection should handle removing groups properly.");
    
    collection = [collection diceByAddingQuantity:@(2) sides:@(3)];
    collection = [collection diceByAddingQuantity:@(2) sides:@(10)];
    XCTAssertEqualObjects(@"2d10+1d6+2d3-3", [collection stringValue], @"Dice collection should order the dice in descending order.");
}

- (void)testEdgeCases {
    DKDiceCollection* zeroD6 = [[DKDiceCollection alloc] initWithQuantity:0 sides:6 modifier:0];
    XCTAssertEqual([zeroD6 roll], 0, @"Zero dice should have a result of zero.");
    
    //Kind of undefined functionality, but let's be explicit with our expectations, shall we
    DKDiceCollection* d0 = [[DKDiceCollection alloc] initWithQuantity:1 sides:0 modifier:0];
    XCTAssertEqual([d0 roll], 0, @"Zero sided dice should have a result of zero.");
    
    //Modifiers solve this edge case...
    DKDiceCollection* dNegative = [[DKDiceCollection alloc] initWithQuantity:1 sides:-5 modifier:0];
    XCTAssertEqual([dNegative roll], 0, @"Negative sided dice should have a result of zero.");
}

@end
