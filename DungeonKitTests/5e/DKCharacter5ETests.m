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
#import "DKModifierBuilder.h"

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
    character.abilities.dexterity.base = @14;
    character.armorClass = [[DKNumericStatistic alloc] initWithBase:10];
    [character.armorClass applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    XCTAssertEqualObjects(character.armorClass.value, @12, @"Character should start off with the correct armor class value.");
    
    DKDependentModifier* dependentModifier = [character.abilities.dexterity modifierFromAbilityScore];
    [character.armorClass applyModifier:dependentModifier];
    XCTAssertEqualObjects(character.armorClass.value, @14, @"Modifier should still be applied properly.");
}

- (void)testDependentModifier {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.abilities.dexterity = [[DKAbilityScore alloc] initWithBase:14];
    character.armorClass = [[DKNumericStatistic alloc] initWithBase:10];
    
    DKDependentModifier* dependentModifier = [character.abilities.dexterity modifierFromAbilityScore];
    [character.armorClass applyModifier:dependentModifier];
    XCTAssertEqualObjects(character.armorClass.value, @12, @"Dependant modifier should be applied correctly.");
    
    character.abilities.dexterity.base = @12;
    XCTAssertEqualObjects(character.armorClass.value, @11, @"Dependant modifier should be applied correctly after changing the owner's base value.");
    
    character.abilities.dexterity = [[DKAbilityScore alloc] initWithBase:16];
    XCTAssertEqualObjects(character.armorClass.value, @13, @"Dependant modifier should be applied correctly after changing the owner object.");
    
    character.abilities.dexterity = nil;
    XCTAssertEqualObjects(character.armorClass.value, @10, @"Dependant modifiers should be removed if the owner statistic is removed.");
}

- (void)testProficiencyBonus {
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    for (int i = 1; i < 5; i++) {
        character.level.base = @(i);
        XCTAssertEqualObjects(character.proficiencyBonus.value, @2, @"Proficiency bonus should start at +2 for a level 1-4 character.");
    }
    
    character.level.base = @5;
    XCTAssertEqualObjects(character.proficiencyBonus.value, @3, @"Proficiency bonus should go to +3 for a level 5 character.");
    
    character.level.base = @9;
    XCTAssertEqualObjects(character.proficiencyBonus.value, @4, @"Proficiency bonus should go to +4 for a level 9 character.");
}

- (void)testHitPoints {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.hitPointsMax.base = @10;
    XCTAssertEqualObjects(character.hitPointsCurrent.value, @10, @"Current hit points should reflect changes in maximum HP.");
    
    character.hitPointsTemporary.base = @5;
    XCTAssertEqualObjects(character.hitPointsCurrent.value, @15, @"Current hit points should reflect changes in temporary HP.");
}

- (void)testHitDice {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.level.base = @1;
    character.hitDiceMax.sides.base = @8;
    XCTAssertEqualObjects(character.hitDiceMax.quantity.value, character.level.value, @"Hit dice quantity should be equal to the character's level.");
    XCTAssertEqualObjects(character.hitDiceMax.quantity.value, character.hitDiceCurrent.quantity.value,
                   @"Max hit dice quantity should be equal the current hit dice quantity.");
    XCTAssertEqualObjects(character.hitDiceMax.sides.value, character.hitDiceCurrent.sides.value,
                   @"Max hit dice sides should be equal the current hit dice sides.");
}

- (void)testArmorClass {
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.abilities.dexterity.base = @10;
    XCTAssertEqualObjects(character.armorClass.value, @10, @"Armor class should default to 10.");
    
    character.abilities.dexterity.base = @14;
    XCTAssertEqualObjects(character.armorClass.value, @12, @"Armor class should get bonuses from dexterity.");
}

- (void)testInitiative {
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    character.abilities.dexterity.base = @10;
    XCTAssertEqualObjects(character.initiativeBonus.value, @0, @"Initiative should default to +0.");
    
    character.abilities.dexterity.base = @14;
    XCTAssertEqualObjects(character.initiativeBonus.value, @2, @"Initiative should get bonuses from dexterity.");
}

- (void)testDeathSaves {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    NSArray* statsToTest = @[character.deathSaveSuccesses, character.deathSaveFailures];
    for (DKNumericStatistic* statToTest in statsToTest) {
        statToTest.base = @0;
        XCTAssertEqualObjects(statToTest.value, @0, @"Death saves modifiers should not alter valid values.");
        statToTest.base = @1;
        XCTAssertEqualObjects(statToTest.value, @1, @"Death saves modifiers should not alter valid values.");
        statToTest.base = @3;
        XCTAssertEqualObjects(statToTest.value, @3, @"Death saves modifiers should not alter valid values.");
        
        statToTest.base = @(-1);
        XCTAssertEqualObjects(statToTest.value, @0, @"Death saves modifiers should clamp invalid values.");
        statToTest.base = @4;
        XCTAssertEqualObjects(statToTest.value, @3, @"Death saves modifiers should clamp invalid values.");
    }
}

- (void)testRaces {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    NSArray* racesToTest = @[[DKRace5EBuilder human], [DKRace5EBuilder elf], [DKRace5EBuilder dwarf], [DKRace5EBuilder halfling]];
    for (DKRace5E* newRace in racesToTest) {
        DKRace5E* oldRace = character.race;
        character.race = newRace;
        
        for (DKModifier* modifier in oldRace.modifiers) {
            XCTAssertNil(modifier.owner, @"Old race modifiers should get removed");
        }
        for (DKModifier* modifier in newRace.modifiers) {
            XCTAssertNotNil(modifier.owner, @"New race modifiers should get applied");
        }
    }
    
}

@end
