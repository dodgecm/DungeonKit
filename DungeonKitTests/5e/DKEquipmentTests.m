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

@end

@implementation DKEquipmentTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    DKCharacter5E* character = [[DKCharacter5E alloc] init];
    XCTAssertNotNil([[DKEquipment5E alloc] initWithAbilities:character.abilities
                                            proficiencyBonus:character.proficiencyBonus
                                               characterSize:character.size
                                         weaponProficiencies:character.weaponProficiencies
                                          armorProficiencies:character.armorProficiencies], @"Constructors should return non-nil object.");
}

@end
