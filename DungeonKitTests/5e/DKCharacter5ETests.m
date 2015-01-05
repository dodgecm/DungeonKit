//
//  DKCharacter5ETests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/3/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKCharacter5E.h"

@interface DKCharacter5ETests : XCTestCase

@end

@implementation DKCharacter5ETests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKCharacter5E alloc] init], @"Constructors should return non-nil object.");
}

- (void)testStatisticChange {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.armorClass = [[DKStatistic alloc] initWithBase:10];
    [character.armorClass applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    XCTAssertEqual(character.armorClass.value, 12, @"Character should start off with the correct armor class value.");
    character.armorClass = [[DKStatistic alloc] initWithBase:8];
    XCTAssertEqual(character.armorClass.value, 10, @"Modifier should still be applied after the armor class gets replaced.");
    
    DKDependentModifier* dependentModifier = [character.abilities.dexterity modifierFromAbilityScore];
    [character.armorClass applyModifier:dependentModifier];
    XCTAssertEqual(character.armorClass.value, 11, @"Modifier should still be applied after the armor class gets replaced.");
}

- (void)testDependentModifier {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.abilities.dexterity = [[DKAbilityScore alloc] initWithBase:14];
    character.armorClass = [[DKStatistic alloc] initWithBase:10];
    
    DKDependentModifier* dependentModifier = [character.abilities.dexterity modifierFromAbilityScore];
    [character.armorClass applyModifier:dependentModifier];
    XCTAssertEqual(character.armorClass.value, 12, @"Dependant modifier should be applied correctly.");
    
    character.abilities.dexterity.base = 12;
    XCTAssertEqual(character.armorClass.value, 11, @"Dependant modifier should be applied correctly after changing the owner's base value.");
    
    character.abilities.dexterity = [[DKAbilityScore alloc] initWithBase:16];
    XCTAssertEqual(character.armorClass.value, 13, @"Dependant modifier should be applied correctly after changing the owner object.");
    
    character.abilities.dexterity = nil;
    XCTAssertEqual(character.armorClass.value, 10, @"Dependant modifiers should be removed if the owner statistic is removed.");
}

@end
