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
@property (nonatomic, strong) DKCharacter5E* character;
@end

@implementation DKCharacter5ETests

@synthesize character = _character;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _character = [[DKCharacter5E alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKCharacter5E alloc] init], @"Constructors should return non-nil object.");
}

- (void)testMultipleModifiers {
    
    _character.abilities.dexterity.base = @14;
    _character.armorClass = [[DKNumericStatistic alloc] initWithInt:10];
    [_character.armorClass applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    XCTAssertEqualObjects(_character.armorClass.value, @12, @"Character should start off with the correct armor class value.");
    
    DKModifier* dependentModifier = [_character.abilities.dexterity modifierFromAbilityScore];
    [_character.armorClass applyModifier:dependentModifier];
    XCTAssertEqualObjects(_character.armorClass.value, @14, @"Modifier should still be applied properly.");
}

- (void)testDependentModifier {
    
    _character.abilities.dexterity = [[DKAbilityScore alloc] initWithInt:14];
    _character.armorClass = [[DKNumericStatistic alloc] initWithInt:10];
    
    DKModifier* dependentModifier = [_character.abilities.dexterity modifierFromAbilityScore];
    [_character.armorClass applyModifier:dependentModifier];
    XCTAssertEqualObjects(_character.armorClass.value, @12, @"Dependant modifier should be applied correctly.");
    
    _character.abilities.dexterity.base = @12;
    XCTAssertEqualObjects(_character.armorClass.value, @11, @"Dependant modifier should be applied correctly after changing the owner's base value.");
    
    _character.abilities.dexterity = [[DKAbilityScore alloc] initWithInt:16];
    XCTAssertEqualObjects(_character.armorClass.value, @13, @"Dependant modifier should be applied correctly after changing the owner object.");
    
    _character.abilities.dexterity = nil;
    XCTAssertEqualObjects(_character.armorClass.value, @10, @"Dependant modifiers should be removed if the owner statistic is removed.");
}

- (void)testProficiencyBonus {
    for (int i = 1; i < 5; i++) {
        _character.level.base = @(i);
        XCTAssertEqualObjects(_character.proficiencyBonus.value, @2, @"Proficiency bonus should start at +2 for a level 1-4 character.");
    }
    
    _character.level.base = @5;
    XCTAssertEqualObjects(_character.proficiencyBonus.value, @3, @"Proficiency bonus should go to +3 for a level 5 character.");
    
    _character.level.base = @9;
    XCTAssertEqualObjects(_character.proficiencyBonus.value, @4, @"Proficiency bonus should go to +4 for a level 9 character.");
}

- (void)testHitPoints {
    
    _character.hitPointsMax.base = @10;
    XCTAssertEqualObjects(_character.hitPointsCurrent.value, @10, @"Current hit points should reflect changes in maximum HP.");
    
    _character.hitPointsTemporary.base = @5;
    XCTAssertEqualObjects(_character.hitPointsCurrent.value, @15, @"Current hit points should reflect changes in temporary HP.");
}

- (void)testHitDice {
    
    _character.classes.fighter = [[DKFighter5E alloc] initWithAbilities:_character.abilities
                                                                 skills:_character.skills
                                                              equipment:_character.equipment
                                                       proficiencyBonus:_character.proficiencyBonus];
    _character.classes.fighter.classLevel.base = @0;
    XCTAssertEqualObjects(_character.classes.fighter.classHitDice.value.stringValue, @"0", @"Class hit dice should be empty at level 0");
    _character.classes.fighter.classLevel.base = @2;
    XCTAssertEqualObjects(_character.classes.fighter.classHitDice.value.stringValue, @"2d10", @"Class hit dice should scale with level");
    _character.classes.fighter.classLevel.base = @10;
    XCTAssertEqualObjects(_character.classes.fighter.classHitDice.value.stringValue, @"10d10", @"Class hit dice should scale with level");
    
    _character.classes.cleric = [[DKCleric5E alloc] initWithAbilities:_character.abilities];
    _character.classes.cleric.classLevel.base = @2;
    XCTAssertEqualObjects(_character.classes.cleric.classHitDice.value.stringValue, @"2d8", @"Class hit dice should scale with level");
    _character.classes.cleric.classLevel.base = @10;
    XCTAssertEqualObjects(_character.classes.cleric.classHitDice.value.stringValue, @"10d8", @"Class hit dice should scale with level");
    
    _character.classes.cleric.classLevel.base = @5;
    XCTAssertEqualObjects(_character.hitDiceMax.value.stringValue, @"10d10+5d8", @"Multiclass hit die should get combined properly.");
}

- (void)testArmorClass {
    _character.abilities.dexterity.base = @10;
    XCTAssertEqualObjects(_character.armorClass.value, @10, @"Armor class should default to 10.");
    
    _character.abilities.dexterity.base = @14;
    XCTAssertEqualObjects(_character.armorClass.value, @12, @"Armor class should get bonuses from dexterity.");
}

- (void)testInitiative {
    _character.abilities.dexterity.base = @10;
    XCTAssertEqualObjects(_character.initiativeBonus.value, @0, @"Initiative should default to +0.");
    
    _character.abilities.dexterity.base = @14;
    XCTAssertEqualObjects(_character.initiativeBonus.value, @2, @"Initiative should get bonuses from dexterity.");
}

- (void)testDeathSaves {
    
    NSArray* statsToTest = @[_character.deathSaveSuccesses, _character.deathSaveFailures];
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

@end
