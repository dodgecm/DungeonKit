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
    XCTAssertNotNil([[DKAbilityScore alloc] init], @"Constructors should return non-nil object.");
    XCTAssertNotNil([[DKAbilityScore alloc] initWithScore:10], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKAbilityScore scoreWithScore:10], @"Constructors should return non-nil object.");
}

- (void)testModifierCalculation {
    
    DKAbilityScore* ability = [[DKAbilityScore alloc] init];
    ability.score = 12;
    XCTAssertEqual(ability.modifier, 1, @"Normal modifier should be calculated properly.");
    ability.score = 11;
    XCTAssertEqual(ability.modifier, 0, @"Normal modifier should be calculated properly.");
    ability.score = 10;
    XCTAssertEqual(ability.modifier, 0, @"Normal modifier should be calculated properly.");
    ability.score = 9;
    XCTAssertEqual(ability.modifier, -1, @"Normal modifier should be calculated properly.");
}

- (void)testNegativeScores {
    
    DKAbilityScore* ability = [[DKAbilityScore alloc] initWithScore:10];
    XCTAssertEqual(ability.modifier, 0, @"Negative ability scores revert to 0.");
    ability.score = -10;
    XCTAssertEqual(ability.score, 0, @"Negative ability scores revert to 0.");
    XCTAssertEqual(ability.modifier, -5, @"Negative ability scores revert to 0.");
}

- (void)testModifierFormatting {
    
    XCTAssertEqualObjects(@"+0", [[DKAbilityScore scoreWithScore:10] formattedModifier], @"Modifier should be formatted with the correct prefix.");
    XCTAssertEqualObjects(@"+2", [[DKAbilityScore scoreWithScore:14] formattedModifier], @"Modifier should be formatted with the correct prefix.");
    XCTAssertEqualObjects(@"-2", [[DKAbilityScore scoreWithScore:6] formattedModifier], @"Modifier should be formatted with the correct prefix.");
}

@end
