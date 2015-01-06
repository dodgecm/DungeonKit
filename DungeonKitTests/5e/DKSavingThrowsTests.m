//
//  DKSavingThrowsTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/6/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKSavingThrows5E.h"

@interface DKSavingThrowsTests : XCTestCase

@end

@implementation DKSavingThrowsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    DKAbilities5E* abilities = [[DKAbilities5E alloc] initWithStr:12 dex:12 con:12 intel:12 wis:12 cha:12];
    XCTAssertNotNil([[DKSavingThrows5E alloc] initWithAbilities:abilities], @"Constructors should return non-nil object.");
}

- (void)testSaveValues {
    DKAbilities5E* abilities = [[DKAbilities5E alloc] initWithStr:10 dex:10 con:10 intel:10 wis:10 cha:10];
    DKSavingThrows5E* saves = [[DKSavingThrows5E alloc] initWithAbilities:abilities];
    XCTAssertEqual(saves.constitution.value, 0, @"Saving throw modifier should default to 0.");
    
    abilities.constitution.base = 14;
    XCTAssertEqual(saves.constitution.value, 2, @"Saving throw modifier should reflect changes to ability score.");
    
}


@end
