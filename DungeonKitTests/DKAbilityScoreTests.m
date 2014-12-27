//
//  DKAbilityScoreTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/27/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKAbilities.h"

@interface DKAbilityScoreTests : XCTestCase

@end

@implementation DKAbilityScoreTests

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
    XCTAssertNotNil([[DKAbilityScore alloc] initWithBase:10], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKAbilityScore statisticWithBase:10], @"Constructors should return non-nil object.");
}

- (void)testModifierCalculation {
    
    DKAbilityScore* ability = [[DKAbilityScore alloc] init];
    ability.base = 12;
    XCTAssertEqual(ability.abilityModifier, 1, @"Normal modifier should be calculated properly.");
    ability.base = 11;
    XCTAssertEqual(ability.abilityModifier, 0, @"Normal modifier should be calculated properly.");
    ability.base = 10;
    XCTAssertEqual(ability.abilityModifier, 0, @"Normal modifier should be calculated properly.");
    ability.base = 9;
    XCTAssertEqual(ability.abilityModifier, -1, @"Normal modifier should be calculated properly.");
}

- (void)testNegativeScores {
    
    DKAbilityScore* ability = [[DKAbilityScore alloc] initWithBase:10];
    XCTAssertEqual(ability.abilityModifier, 0, @"Negative ability scores revert to 0.");
    ability.base = -10;
    XCTAssertEqual(ability.score, 0, @"Negative ability scores revert to 0.");
    XCTAssertEqual(ability.abilityModifier, -5, @"Negative ability scores revert to 0.");
}

- (void)testModifierFormatting {
    
    XCTAssertEqualObjects(@"+0", [[DKAbilityScore statisticWithBase:10] formattedAbilityModifier], @"Modifier should be formatted with the correct prefix.");
    XCTAssertEqualObjects(@"+2", [[DKAbilityScore statisticWithBase:14] formattedAbilityModifier], @"Modifier should be formatted with the correct prefix.");
    XCTAssertEqualObjects(@"-2", [[DKAbilityScore statisticWithBase:6] formattedAbilityModifier], @"Modifier should be formatted with the correct prefix.");
}

@end
