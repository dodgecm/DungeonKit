//
//  DKRace5ETests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 7/7/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKCharacter5E.h"
#import "DKModifierGroupTags5E.h"

@interface DKRace5ETests : XCTestCase
@property (nonatomic, strong) DKCharacter5E* character;
@end

@implementation DKRace5ETests

@synthesize character = _character;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _character = [[DKCharacter5E alloc] init];
    //Override the class information, so there's no class modifiers messing with the stats
    _character.classes = [[DKClasses5E alloc] init];
    _character.abilities = [[DKAbilities5E alloc] initWithStr:10 dex:10 con:10 intel:10 wis:10 cha:10];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark -

- (void)testDwarf {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[0]];
    XCTAssertEqualObjects(_character.abilities.constitution.value, @12, @"Dwarves get +2 bonus to Constitution.");
    XCTAssertEqualObjects(_character.size.value, @"Medium", @"Dwarves are size Medium creatures.");
    
    XCTAssertEqualObjects(_character.movementSpeed.value, @25, @"Dwarves have a base movement speed of 25 feet.");
    [_character.equipment equipArmor:[DKArmorBuilder5E armorOfType:kDKArmorType5E_Plate forCharacter:_character]];
    XCTAssertEqualObjects(_character.movementSpeed.value, @25, @"Dwarves are not slowed by wearing heavy armor.");
    _character.equipment.armor = nil;
    
    XCTAssertEqualObjects(_character.darkvisionRange.value, @60, @"Dwarves have darkvision range of 60 feet.");
    XCTAssertTrue([_character.resistances.value containsObject:@"Poison"], @"Dwarves have resistance to poison damage.");
    
    NSArray* weaponProficiencies = @[ [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Battleaxe],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Handaxe],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_LightHammer],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Warhammer]];
    for (NSString* weaponProficiency in weaponProficiencies) {
        XCTAssertTrue([_character.weaponProficiencies.value containsObject:weaponProficiency],
                      @"Dwarves have axe and hammer weapon proficiencies.");
    }
    
    DKChoiceModifierGroup* toolChoice = (DKChoiceModifierGroup*) [_character firstModifierGroupWithTag:DKChoiceDwarfToolProficiency];
    [toolChoice choose:toolChoice.modifiers[0]];
    XCTAssertGreaterThan(_character.toolProficiencies.value.count, 0, @"Dwarves have one tool proficiency of their choice.");
    XCTAssertTrue([_character.languages.value containsObject:@"Common"], @"Dwarves can speak Common.");
    XCTAssertTrue([_character.languages.value containsObject:@"Dwarvish"], @"Dwarves can speak Dwarvish.");
}

- (void)testHillDwarf {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[0]];
    DKChoiceModifierGroup* subraceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceSubrace];
    [subraceChoice choose:subraceChoice.choices[0]];
    
    XCTAssertEqualObjects(_character.abilities.wisdom.value, @11, @"Hill Dwarves get +1 bonus to Wisdom.");
    _character.level.base = @1;
    XCTAssertEqualObjects(_character.hitPointsMax.value, @1, @"Hill Dwarves get +1 HP to their maximum for every level gained.");
    _character.level.base = @5;
    XCTAssertEqualObjects(_character.hitPointsMax.value, @5, @"Hill Dwarves get +1 HP to their maximum for every level gained.");
}

- (void)testMountainDwarf {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[0]];
    DKChoiceModifierGroup* subraceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceSubrace];
    [subraceChoice choose:subraceChoice.choices[1]];
    
    XCTAssertEqualObjects(_character.abilities.strength.value, @12, @"Mountain Dwarves get +2 bonus to Strength.");
    XCTAssertTrue([_character.armorProficiencies.value containsObject:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Light]],
                  @"Mountain Dwarves are proficient with light armor.");
    XCTAssertTrue([_character.armorProficiencies.value containsObject:[DKArmorBuilder5E proficiencyNameForArmorCategory:kDKArmorCategory5E_Medium]],
                  @"Mountain Dwarves are proficient with medium armor.");
    
}

#pragma mark -

- (void)testElf {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[1]];
    XCTAssertEqualObjects(_character.abilities.dexterity.value, @12, @"Elves get +2 bonus to Dexterity.");
    XCTAssertEqualObjects(_character.size.value, @"Medium", @"Elves are size Medium creatures.");
    
    XCTAssertEqualObjects(_character.movementSpeed.value, @30, @"Elves have a base movement speed of 30 feet.");
    XCTAssertEqualObjects(_character.darkvisionRange.value, @60, @"Elves have darkvision range of 60 feet.");
    XCTAssertEqualObjects(_character.skills.perception.proficiencyLevel.value, @1, @"Elves are proficient in the Perception skill.");
    XCTAssertTrue([_character.immunities.value containsObject:@"Sleep"], @"Elves cannot be put to sleep through magical means.");
    XCTAssertTrue([_character.otherTraits.value containsObject:@"Elven Trance"], @"Elves enter a trance instead of sleeping.");
    XCTAssertTrue([_character.languages.value containsObject:@"Common"], @"Elves can speak Common.");
    XCTAssertTrue([_character.languages.value containsObject:@"Elvish"], @"Elves can speak Elvish.");
}

- (void)testHighElf {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[1]];
    DKChoiceModifierGroup* subraceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceSubrace];
    [subraceChoice choose:subraceChoice.choices[0]];
    
    XCTAssertEqualObjects(_character.abilities.intelligence.value, @11, @"High Elves get +1 bonus to Intelligence.");
    
    NSArray* weaponProficiencies = @[ [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longsword],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortsword],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longbow],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortbow]];
    for (NSString* weaponProficiency in weaponProficiencies) {
        XCTAssertTrue([_character.weaponProficiencies.value containsObject:weaponProficiency],
                      @"High Elves have sword and bow weapon proficiencies.");
    }
    
    DKChoiceModifierGroup* cantripChoice = (DKChoiceModifierGroup*) [_character firstModifierGroupWithTag:DKChoiceHighElfCantrip];
    [cantripChoice choose:cantripChoice.modifiers[0]];
    XCTAssertGreaterThan(_character.spells.spellbook.cantrips.value.count, 0, @"High Elves know one cantrip from the Wizard spell list.");
    
    DKChoiceModifierGroup* languageChoice = (DKChoiceModifierGroup*) [_character firstModifierGroupWithTag:DKChoiceHighElfBonusLanguage];
    [languageChoice choose:languageChoice.modifiers[0]];
    XCTAssertGreaterThan(_character.languages.value.count, 0, @"High Elves know one extra language of their choice.");
}

- (void)testWoodElf {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[1]];
    DKChoiceModifierGroup* subraceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceSubrace];
    [subraceChoice choose:subraceChoice.choices[1]];
    
    XCTAssertEqualObjects(_character.abilities.wisdom.value, @11, @"Wood Elves get +1 bonus to Wisdom.");
    
    NSArray* weaponProficiencies = @[ [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longsword],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortsword],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Longbow],
                                      [DKWeaponBuilder5E proficiencyNameForWeapon:kDKWeaponType5E_Shortbow]];
    for (NSString* weaponProficiency in weaponProficiencies) {
        XCTAssertTrue([_character.weaponProficiencies.value containsObject:weaponProficiency],
                      @"Wood Elves have sword and bow weapon proficiencies.");
    }
    
    XCTAssertEqualObjects(_character.movementSpeed.value, @35, @"Wood elves have a 5 foot bonus to movement speed.");
}

#pragma mark -

- (void)testHalfling {
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[2]];
    
    XCTAssertEqualObjects(_character.abilities.dexterity.value, @12, @"Halflings get +2 bonus to Dexterity.");
    XCTAssertEqualObjects(_character.size.value, @"Small", @"Halflings are size Small creatures.");
    
    XCTAssertEqualObjects(_character.movementSpeed.value, @25, @"Halflings have a base movement speed of 25 feet.");
    XCTAssertTrue([_character.otherTraits.value containsObject:@"Lucky"], @"Halflings have the lucky trait.");
    XCTAssertTrue([_character.otherTraits.value containsObject:@"Halfling Nimbleness"], @"Halflings have the nimbleness trait.");
    XCTAssertTrue([_character.languages.value containsObject:@"Common"], @"Halflings can speak Common.");
    XCTAssertTrue([_character.languages.value containsObject:@"Halfling"], @"Halflings can speak Halfling.");
}

- (void)testLightfootHalfling {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[2]];
    DKChoiceModifierGroup* subraceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceSubrace];
    [subraceChoice choose:subraceChoice.choices[0]];
    
    XCTAssertEqualObjects(_character.abilities.charisma.value, @11, @"Lightfoot Halflings get +1 bonus to Charisma.");
    XCTAssertTrue([_character.otherTraits.value containsObject:@"Naturally Stealthy"], @"Lightfoot Halflings have the Naturally Stealthy trait.");
}

- (void)testStoutHalfling {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[2]];
    DKChoiceModifierGroup* subraceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceSubrace];
    [subraceChoice choose:subraceChoice.choices[1]];
    
    XCTAssertEqualObjects(_character.abilities.constitution.value, @11, @"Stout Halflings get +1 bonus to Constitution.");
    XCTAssertTrue([_character.resistances.value containsObject:@"Poison"], @"Stout Halflings have resistance to poison damage.");
}

#pragma mark -

- (void)testHuman {
    
    DKChoiceModifierGroup* raceChoice = [_character firstUnallocatedChoiceWithTag:DKChoiceRace];
    [raceChoice choose:raceChoice.choices[3]];
    
    XCTAssertEqualObjects(_character.abilities.strength.value, @11, @"Humans get +1 bonus to Strength.");
    XCTAssertEqualObjects(_character.abilities.dexterity.value, @11, @"Humans get +1 bonus to Dexterity.");
    XCTAssertEqualObjects(_character.abilities.constitution.value, @11, @"Humans get +1 bonus to Constitution.");
    XCTAssertEqualObjects(_character.abilities.intelligence.value, @11, @"Humans get +1 bonus to Intelligence.");
    XCTAssertEqualObjects(_character.abilities.wisdom.value, @11, @"Humans get +1 bonus to Wisdom.");
    XCTAssertEqualObjects(_character.abilities.charisma.value, @11, @"Humans get +1 bonus to Charisma.");
    XCTAssertEqualObjects(_character.size.value, @"Medium", @"Humans are size Medium creatures.");
    XCTAssertEqualObjects(_character.movementSpeed.value, @30, @"Humans have a base movement speed of 30 feet.");
    
    DKChoiceModifierGroup* languageChoice = (DKChoiceModifierGroup*) [_character firstModifierGroupWithTag:DKChoiceHumanBonusLanguage];
    [languageChoice choose:languageChoice.choices[1]];
    XCTAssertGreaterThan(_character.languages.value.count, 0, @"Humans know one extra language of their choice.");
    XCTAssertTrue([_character.languages.value containsObject:@"Common"], @"Humans can speak Common.");
    
    XCTAssertGreaterThanOrEqual(_character.languages.value.count, 2, @"Humans can speak an extra language of their choice.");
    
}

@end