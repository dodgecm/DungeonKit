//
//  DKCharacterTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKCharacter.h"

@interface DKCharacterTests : XCTestCase

@end

@implementation DKCharacterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKCharacter alloc] init], @"Constructors should return non-nil object.");
}

- (void)testStatisticChange {
    
    /*DKCharacter* character = [[DKCharacter alloc] init];
    character.armorClass = [[DKStatistic alloc] initWithBase:10];
    [character.armorClass applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    XCTAssertEqual(character.armorClass.value, 12, @"Character should start off with the correct armor class value.");
    character.armorClass = [[DKStatistic alloc] initWithBase:8];
    XCTAssertEqual(character.armorClass.value, 10, @"Modifier should still be applied after the armor class gets replaced.");*/
}

@end
