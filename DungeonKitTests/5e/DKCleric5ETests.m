//
//  DKCleric5ETests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 8/13/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKCharacter5E.h"
#import "DKModifierGroupTags5E.h"

@interface DKCleric5ETests : XCTestCase
@property (nonatomic, strong) DKCharacter5E* character;
@end

@implementation DKCleric5ETests

@synthesize character = _character;

- (void)setUp {
    [super setUp];
    
    _character = [[DKCharacter5E alloc] init];
    _character.classes = [[DKClasses5E alloc] init];
    _character.classes.cleric = [[DKCleric5E alloc] initWithAbilities:_character.abilities];
    _character.classes.cleric.classLevel.base = @1;
    _character.abilities = [[DKAbilities5E alloc] initWithStr:10 dex:10 con:10 intel:10 wis:10 cha:10];
    _character.race = nil;
    _character.subrace = nil;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testHitDice {
    
    XCTAssertEqualObjects(_character.hitDiceMax.value.stringValue, @"1d8", @"Cleric should have 1d8 hit dice at level 1.");
    _character.classes.cleric.classLevel.base = @5;
    XCTAssertEqualObjects(_character.hitDiceMax.value.stringValue, @"5d8", @"Cleric should have 5d8 hit dice at level 5.");
}

- (void)testSpellSaveDC {
    
    XCTAssertEqualObjects(_character.spells.spellSaveDC.value, @10, @"Spell save DC starts out at 10 (8 + proficiency).");
    _character.abilities.wisdom.base = @14;
    XCTAssertEqualObjects(_character.spells.spellSaveDC.value, @12, @"Spell save DC should increase with wisdom.");
    _character.classes.cleric.classLevel.base = @9;
    XCTAssertEqualObjects(_character.spells.spellSaveDC.value, @14, @"Spell save DC should increase with proficiency bonus.");
}

- (void)testSpellAttackBonus {
    
    XCTAssertEqualObjects(_character.spells.spellAttackBonus.value, @2, @"Spell attack bonus starts out at 2 (proficiency).");
    _character.abilities.wisdom.base = @14;
    XCTAssertEqualObjects(_character.spells.spellAttackBonus.value, @4, @"Spell attack bonus should increase with wisdom.");
    _character.classes.cleric.classLevel.base = @9;
    XCTAssertEqualObjects(_character.spells.spellAttackBonus.value, @6, @"Spell attack bonus should increase with proficiency bonus.");
}

- (void)testPreparedSpells {
    
    XCTAssertEqualObjects(_character.spells.preparedSpellsMax.value, @1, @"Prepared spells limit starts out at 1 (level).");
    _character.abilities.wisdom.base = @14;
    XCTAssertEqualObjects(_character.spells.preparedSpellsMax.value, @3, @"Prepared spells limit should increase with wisdom.");
    _character.classes.cleric.classLevel.base = @9;
    XCTAssertEqualObjects(_character.spells.preparedSpellsMax.value, @11, @"Prepared spells limit should increase with level.");
    _character.abilities.wisdom.base = @1;
    _character.classes.cleric.classLevel.base = @1;
    XCTAssertEqualObjects(_character.spells.preparedSpellsMax.value, @1, @"Prepared spells limit cannot go below 1.");
}

@end
