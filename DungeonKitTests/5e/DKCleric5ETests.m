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

- (void)testTraits {
    XCTAssertTrue([_character.classes.cleric.classTraits.value containsObject:@"Channel Divinity"], @"Clerics have the Channel Divinity trait.");
    XCTAssertTrue([_character.classes.cleric.classTraits.value containsObject:@"Ritual Casting"], @"Clerics have the Channel Divinity trait.");
}

- (void)testSavingThrows {
    XCTAssertEqualObjects(_character.savingThrows.wisdom.proficiencyLevel.value, @1, @"Clerics have proficiency in wisdom saving throws.");
    XCTAssertEqualObjects(_character.savingThrows.charisma.proficiencyLevel.value, @1, @"Clerics have proficiency in charisma saving throws.");
    
    XCTAssertEqualObjects(_character.savingThrows.wisdom.value, @2, @"Clerics have proficiency in wisdom saving throws.");
    _character.abilities.wisdom.base = @12;
    XCTAssertEqualObjects(_character.savingThrows.wisdom.value, @3, @"Clerics have proficiency in wisdom saving throws.");
}

- (void)testWeaponProficiencies {
    XCTAssertTrue([_character.weaponProficiencies.value containsObject:@"Simple Weapons"], @"Clerics can use simple weapons.");
}

- (void)testArmorProficiencies {
    XCTAssertTrue([_character.armorProficiencies.value containsObject:@"Light Armor"], @"Clerics can wear light armor.");
    XCTAssertTrue([_character.armorProficiencies.value containsObject:@"Medium Armor"], @"Clerics can wear medium armor.");
    XCTAssertTrue([_character.armorProficiencies.value containsObject:@"Heavy Armor"], @"Clerics can wear heavy armor.");
}

- (void)testSkillProficiencies {
    
    NSArray* skillChoices = [_character allModifierGroupsWithTag:DKChoiceClericSkillProficiency];
    XCTAssertEqual(skillChoices.count, 2, @"Clerics get two skill proficiency choices.");
    
    XCTAssertEqualObjects(_character.skills.history.proficiencyLevel.value, @0, @"Clerics do not start out with history proficiency.");
    DKChoiceModifierGroup* skillChoice = (DKChoiceModifierGroup*) skillChoices[0];
    [skillChoice chooseModifier:skillChoice.modifiers[0]];
    XCTAssertEqualObjects(_character.skills.history.proficiencyLevel.value, @1, @"History proficiency should be granted.");
    
    XCTAssertEqualObjects(_character.skills.insight.proficiencyLevel.value, @0, @"Clerics do not start out with insight proficiency.");
    skillChoice = (DKChoiceModifierGroup*) skillChoices[1];
    [skillChoice chooseModifier:skillChoice.modifiers[1]];
    XCTAssertEqualObjects(_character.skills.insight.proficiencyLevel.value, @1, @"Insight proficiency should be granted.");
}

- (void)testChannelDivinity {
    XCTAssertEqualObjects(_character.classes.cleric.channelDivinityUsesMax.value, @0, @"Clerics start with 0 Channel Divinity uses.");
    _character.classes.cleric.classLevel.base = @2;
    XCTAssertEqualObjects(_character.classes.cleric.channelDivinityUsesMax.value, @1, @"Clerics get 1 Channel Divinity use at level 2.");
    _character.classes.cleric.classLevel.base = @6;
    XCTAssertEqualObjects(_character.classes.cleric.channelDivinityUsesMax.value, @2, @"Clerics get 2 Channel Divinity uses at level 6.");
    _character.classes.cleric.classLevel.base = @18;
    XCTAssertEqualObjects(_character.classes.cleric.channelDivinityUsesMax.value, @3, @"Clerics get 3 Channel Divinity uses at level 18.");
}

- (void)testTurnUndead
{
    XCTAssertFalse([_character.classes.cleric.classTraits.value containsObject:@"Channel Divinity - Turn Undead"], @"Cleric doesn't learn Turn Undead until level 2");
    _character.classes.cleric.classLevel.base = @2;
    XCTAssertTrue([_character.classes.cleric.classTraits.value containsObject:@"Channel Divinity - Turn Undead"], @"Cleric learns Turn Undead at level 2");
}

- (void)testDivineIntervention {
    
    XCTAssertFalse([_character.classes.cleric.classTraits.value containsObject:@"Divine Intervention"], @"Cleric doesn't learn Divine Intervention until level 2");
    _character.classes.cleric.classLevel.base = @10;
    XCTAssertTrue([_character.classes.cleric.classTraits.value containsObject:@"Divine Intervention"], @"Cleric learns Divine Intervention at level 10");
    _character.classes.cleric.classLevel.base = @20;
    XCTAssertTrue([_character.classes.cleric.classTraits.value containsObject:@"Divine Intervention"], @"Description for Divine Intervention changes at 20");
}

- (void)testCantrips {
    
    /*NSArray* cantripChoices = [_character allModifierGroupsWithTag:DKChoiceClericCantrip];
    XCTAssertEqual(cantripChoices.count, 3, @"Clerics get three cantrip choices.");
    
    XCTAssertEqual(_character.spells.spellbook.cantrips.value.count, 0, @"Clerics do not have cantrips until they are chosen.");
    DKChoiceModifierGroup* cantripChoice = (DKChoiceModifierGroup*) cantripChoices[0];
    [cantripChoice chooseModifier:cantripChoice.modifiers[0]];
    XCTAssertTrue([_character.spells.spellbook.cantrips.value containsObject:@"Guidance"], @"Cleric should be granted the cantrip.");*/
}

@end
