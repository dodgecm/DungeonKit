//
//  DKAbilitiesTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKAbilities.h"

@interface DKAbilitiesTests : XCTestCase

@end

@implementation DKAbilitiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    DKAbilities* abilities = [[DKAbilities alloc] initWithStr:12 dex:12 con:12 intel:12 wis:12 cha:12];
    XCTAssertNotNil(abilities, @"Constructors should return non-nil object.");
    abilities = [[DKAbilities alloc] initWithScoreArray:@[@(12), @(12), @(12), @(12), @(12), @(12)]];
    XCTAssertNotNil(abilities, @"Constructors should return non-nil object.");
    abilities = [[DKAbilities alloc] initWithScores:@(12), @(12), @(12), @(12), @(12), @(12), nil];
    XCTAssertNotNil(abilities, @"Constructors should return non-nil object.");
    
    NSArray* wrongTypeArray = @[@"12", @"12", @"12", @"12", @"12", @"12"];
    XCTAssertThrows([[DKAbilities alloc] initWithScoreArray:wrongTypeArray],
                    @"Constructor should throw exception if input array contains invalid object types");
    NSArray* wrongCountArray = @[@"12", @"12", @"12", @"12", @"12"];
    XCTAssertThrows([[DKAbilities alloc] initWithScoreArray:wrongCountArray],
                    @"Constructor should throw exception if input array contains less than 6 scores");
    
}

@end
