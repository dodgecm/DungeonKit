//
//  DKEquipmentTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 6/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKCharacter5E.h"
#import "DKEquipment5E.h"

@interface DKEquipmentTests : XCTestCase
@property (nonatomic, strong) DKCharacter5E* character;
@end

@implementation DKEquipmentTests

@synthesize character = _character;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _character = [[DKCharacter5E alloc] init];
    //Override the class information, so there's no class modifiers messing with the stats
    _character.classes = [[DKClasses5E alloc] init];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKEquipment5E alloc] initWithAbilities:_character.abilities
                                            proficiencyBonus:_character.proficiencyBonus
                                               characterSize:_character.size
                                         weaponProficiencies:_character.weaponProficiencies
                                          armorProficiencies:_character.armorProficiencies], @"Constructors should return non-nil object.");
}

- (void)testAttackBonus {
    _character.equipment.mainHandWeapon = [DKWeaponBuilder5E weaponOfType:kDKWeaponType5E_Mace
                                                             forCharacter:_character
                                                               isMainHand:YES];
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponAttackBonus.value, @(0), "Non proficient, +0 STR character should have no attack bonus.");
    
    _character.abilities.strength.base = @12;
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponAttackBonus.value, @(1), "Non proficient, +1 STR character should have +1 attack bonus.");
}

- (void)testDamage {
    _character.equipment.mainHandWeapon = [DKWeaponBuilder5E weaponOfType:kDKWeaponType5E_Morningstar
                                                             forCharacter:_character
                                                               isMainHand:YES];
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponDamage.value.stringValue, @"1d8", "Morningstars deal 1d8 damage.");
}

- (void)testDamageBonus {
    
    _character.equipment.mainHandWeapon = [DKWeaponBuilder5E weaponOfType:kDKWeaponType5E_Flail
                                                             forCharacter:_character
                                                               isMainHand:YES];
    XCTAssertEqual(_character.equipment.mainHandWeaponDamage.value.modifier, 0, "+0 STR character should have no damage bonus.");
    
    _character.abilities.strength.base = @12;
    XCTAssertEqual(_character.equipment.mainHandWeaponDamage.value.modifier, 1, "+1 STR character should have +1 damage bonus.");
}

- (void)testVersatileWeapon {
    
    _character.equipment.mainHandWeapon = [DKWeaponBuilder5E weaponOfType:kDKWeaponType5E_Quarterstaff
                                                             forCharacter:_character
                                                               isMainHand:YES];
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponDamage.value.stringValue, @"1d8", "Quarterstaves deal 1d8 damage if used with both hands.");
    
    _character.equipment.shield = [DKArmorBuilder5E shieldWithEquipment:_character.equipment
                                                     armorProficiencies:_character.armorProficiencies];
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponDamage.value.stringValue, @"1d6", "Quarterstaves deal 1d6 damage if used with one hand.");
}

- (void)testWeaponProficiency {
    
    _character.equipment.mainHandWeapon = [DKWeaponBuilder5E weaponOfType:kDKWeaponType5E_WarPick
                                                             forCharacter:_character
                                                               isMainHand:YES];
    
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponAttackBonus.value, @(0), "Non-proficient character should have +0 attack bonus.");
    
    _character.weaponProficiencies.base = [NSSet setWithObject:@"Picks"];
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponAttackBonus.value, @(2), "Proficient character should have +2 attack bonus.");
    
    _character.weaponProficiencies.base = [NSSet setWithObject:@"Martial Weapons"];
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponAttackBonus.value, @(2), "Proficient character should have +2 attack bonus.");
}

- (void)testReachWeapon {
    
    _character.equipment.mainHandWeapon = [DKWeaponBuilder5E weaponOfType:kDKWeaponType5E_Lance
                                                             forCharacter:_character
                                                               isMainHand:YES];
    
    XCTAssertEqualObjects(_character.equipment.mainHandWeaponRange.value, @(10), "Weapon with reach should have range of 10 feet.");
}

- (void)testAmmunitionWeapon {
    
}

- (void)testFinesseWeapon {
    
}

- (void)testTwoHandedWeapon {
    
}

- (void)testLightWeapon {
    
}

- (void)testNonProficientOffhand {
    
}

- (void)testHeavyWeapon {
    
}

- (void)testLoadingWeapon {
    
}

@end
