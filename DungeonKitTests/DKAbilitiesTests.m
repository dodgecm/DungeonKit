//
//  DKAbilitiesTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKAbilities.h"

@interface DKAbilitiesTests : XCTestCase

@end

@implementation DKAbilitiesTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testAllAbilities {
    
    NSArray* allAbilities = [DKAbilities allAbilities];
    XCTAssertEqual([allAbilities count], 6, @"Ability array should have 6 objects");
    for (NSNumber* ability in allAbilities) {
        XCTAssert([ability isKindOfClass:[NSNumber class]], @"Abilities should be NSNumbers");
    }
}

- (void)testAbilityDescriptions {
    
    for (NSNumber* ability in [DKAbilities allAbilities]) {
        XCTAssert([[DKAbilities descriptionForAbility:[ability intValue]] length] > 0, @"Ability description should return a non-empty string");
    }
}

- (void)testConstructors {
    
    DKAbilities* abilities = [[DKAbilities alloc] initWithStr:12 dex:12 con:12 intel:12 wis:12 cha:12];
    XCTAssertNotNil(abilities, @"Constructors should return non-nil object.");
    abilities = [[DKAbilities alloc] initWithScoreArray:@[@(12), @(12), @(12), @(12), @(12), @(12)]];
    XCTAssertNotNil(abilities, @"Constructors should return non-nil object.");
    abilities = [[DKAbilities alloc] initWithScores:@(12), @(12), @(12), @(12), @(12), @(12), nil];
    XCTAssertNotNil(abilities, @"Constructors should return non-nil object.");
    
    NSArray* wrongTypeArray = @[@"12", @"12", @"12", @"12", @"12", @"12"];
    XCTAssertThrows([[DKAbilities alloc] initWithScoreArray:wrongTypeArray],
                    @"Constructor should throw exception if input array contains invalid object types");
    NSArray* wrongCountArray = @[@"12", @"12", @"12", @"12", @"12"];
    XCTAssertThrows([[DKAbilities alloc] initWithScoreArray:wrongCountArray],
                    @"Constructor should throw exception if input array contains less than 6 scores");
    XCTAssertThrows([[DKAbilities alloc] init],
                    @"Constructor should throw exception if using disabled constuctor");
    
}

- (void)testGetters {
    
    NSArray* scoreArray = @[@(6), @(8), @(10), @(12), @(14), @(16)];
    DKAbilities* abilities = [[DKAbilities alloc] initWithScoreArray:scoreArray];
    int i = 0;
    for (NSNumber* ability in [DKAbilities allAbilities]) {
        DKAbilityScore* abilityScore = [abilities scoreObjectForAbility:[ability intValue]];
        XCTAssertNotNil(abilityScore, @"Abilities object should return a non-nil AbilityScore object");
        XCTAssertEqual([abilities scoreForAbility:[ability intValue]], [scoreArray[i] intValue], @"AbilityScore object should match the input values");
        XCTAssertEqual([abilities scoreForAbility:[ability intValue]], abilityScore.score, @"Getter methods should return internally consistent values");
        XCTAssertEqual([abilities modifierForAbility:[ability intValue]], abilityScore.abilityModifier, @"Getter methods should return internally consistent values");
        i++;
    }
}

- (void)testSetters {
    
    NSArray* scoreArray = @[@(6), @(8), @(10), @(12), @(14), @(16)];
    DKAbilities* abilities = [[DKAbilities alloc] initWithScoreArray:scoreArray];
    [abilities setScore:18 ability:kDKAbility_Strength];
    XCTAssertEqual([abilities scoreForAbility:kDKAbility_Strength], 18, @"AbilityScore object should be updated with the new score");
    XCTAssertEqual([abilities modifierForAbility:kDKAbility_Strength], 4, @"AbilityScore object should be updated with the new score");
    XCTAssertEqual([[abilities scoreObjectForAbility:kDKAbility_Strength] score], 18, @"AbilityScore object should be updated with the new score");
    XCTAssertEqual([[abilities scoreObjectForAbility:kDKAbility_Strength] abilityModifier], 4, @"AbilityScore object should be updated with the new score");
}

@end
