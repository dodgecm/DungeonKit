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

- (void)testMultipleModifiers {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.abilities.dexterity.base = 14;
    character.armorClass = [[DKStatistic alloc] initWithBase:10];
    [character.armorClass applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    XCTAssertEqual(character.armorClass.value, 12, @"Character should start off with the correct armor class value.");
    
    DKDependentModifier* dependentModifier = [character.abilities.dexterity modifierFromAbilityScore];
    [character.armorClass applyModifier:dependentModifier];
    XCTAssertEqual(character.armorClass.value, 14, @"Modifier should still be applied properly.");
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

- (void)testProficiencyBonus {
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    for (int i = 1; i < 5; i++) {
        character.level.base = i;
        XCTAssertEqual(character.proficiencyBonus.value, 2, @"Proficiency bonus should start at +2 for a level 1-4 character.");
    }
    
    character.level.base = 5;
    XCTAssertEqual(character.proficiencyBonus.value, 3, @"Proficiency bonus should go to +3 for a level 5 character.");
    
    character.level.base = 9;
    XCTAssertEqual(character.proficiencyBonus.value, 4, @"Proficiency bonus should go to +4 for a level 9 character.");
}

- (void)testHitPoints {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.hitPointsMax.base = 10;
    XCTAssertEqual(character.hitPointsCurrent.value, 10, @"Current hit points should reflect changes in maximum HP.");
    
    character.hitPointsTemporary.base = 5;
    XCTAssertEqual(character.hitPointsCurrent.value, 15, @"Current hit points should reflect changes in temporary HP.");
}

- (void)testArmorClass {
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.abilities.dexterity.base = 10;
    XCTAssertEqual(character.armorClass.value, 10, @"Armor class should default to 10.");
    
    character.abilities.dexterity.base = 14;
    XCTAssertEqual(character.armorClass.value, 12, @"Armor class should get bonuses from dexterity.");
}

- (void)testInitiative {
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.abilities.dexterity.base = 10;
    XCTAssertEqual(character.initiativeBonus.value, 0, @"Initiative should default to +0.");
    
    character.abilities.dexterity.base = 14;
    XCTAssertEqual(character.initiativeBonus.value, 2, @"Initiative should get bonuses from dexterity.");
}

@end
