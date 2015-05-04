//
//  DKCharacterTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKCharacter.h"
#import "DKModifierBuilder.h"

@interface DKTestCharacter : DKCharacter
@property (nonatomic, strong) DKStatistic* testStatistic;
@property (nonatomic, strong) DKStatistic* testStatistic2;
@property (nonatomic, strong) DKModifierGroup* modifierGroup;
@property (nonatomic, strong) DKModifierGroup* modifierGroup2;
@end

@implementation DKTestCharacter
@synthesize testStatistic = _testStatistic;
@synthesize testStatistic2 = _testStatistic2;
@synthesize modifierGroup = _modifierGroup;
@synthesize modifierGroup2 = _modifierGroup2;
@end

@interface DKCharacterTests : XCTestCase

@property (nonatomic, strong) DKTestCharacter* testCharacter;
@property (nonatomic, strong) DKStatistic* testStatistic;
@property (nonatomic, strong) DKModifier* testModifier;
@property (nonatomic, strong) DKModifierGroup* testGroup;

@end

@implementation DKCharacterTests

@synthesize testCharacter = _testCharacter;
@synthesize testStatistic = _testStatistic;
@synthesize testModifier = _testModifier;
@synthesize testGroup = _testGroup;

- (void)setUp {
    [super setUp];
    
    self.testCharacter = [[DKTestCharacter alloc] init];
    self.testStatistic = [DKNumericStatistic statisticWithInt:10];
    self.testModifier = [DKModifierBuilder modifierWithAdditiveBonus:2];
    
    DKModifier* groupModifierOne = [DKModifierBuilder modifierWithAdditiveBonus:3];
    DKModifier* groupModifierTwo = [DKModifierBuilder modifierWithAdditiveBonus:1];
    self.testGroup = [[DKModifierGroup alloc] init];
    [_testGroup addModifier:groupModifierOne forStatisticID:@"test"];
    [_testGroup addModifier:groupModifierTwo forStatisticID:@"two"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKCharacter alloc] init], @"Constructors should return non-nil object.");
}

- (void)testDealloc {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
}

- (void)testStatisticGetters {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    DKStatistic* testStat = [DKNumericStatistic statisticWithInt:10];
    character.testStatistic = testStat;
    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    XCTAssertEqual(testStat, [character statisticForID:@"test"], @"Statistic should be registered with its identifier properly.");
    
    [character removeStatisticWithID:@"test"];
    XCTAssertNil([character statisticForID:@"test"], @"Statistic should be removed properly.");
    
    [character setStatistic:testStat forStatisticID:@"test"];
    XCTAssertEqual(testStat, [character statisticForID:@"test"], @"Statistic should be registered with its identifier properly.");
}

- (void)testStatisticSetter {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    DKStatistic* testStat = [DKNumericStatistic statisticWithInt:10];
    XCTAssertNil([character statisticForID:@"test"], @"Statistic should be start off as nil.");
    
    [character setStatistic:testStat forStatisticID:@"test"];
    XCTAssertEqual(@10, [character statisticForID:@"test"].value, @"Statistic should be registered with its identifier properly.");
    XCTAssertEqual(testStat, [character statisticForID:@"test"], @"Statistic should be registered with its identifier properly.");
}

- (void)testAddKeyPath {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    character.testStatistic = [DKNumericStatistic statisticWithInt:10];
    [character.testStatistic applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];

    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    XCTAssertEqualObjects(character.testStatistic.value, @12, @"Statistic should calculate modifier properly.");
}

- (void)testStatisticToKeyPath {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    character.testStatistic = [DKNumericStatistic statisticWithInt:10];
    DKStatistic* secondStatistic = [DKNumericStatistic statisticWithInt:8];
    [secondStatistic applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    
    [character setStatistic:secondStatistic forStatisticID:@"test"];
    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    XCTAssertEqualObjects([character statisticForID:@"test"].value, @10, @"Statistic should transfer modifiers when a statistic ID is replaced.");
}

- (void)testModifierCycle {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    [character addKeyPath:@"testStatistic2" forStatisticID:@"test2"];
    character.testStatistic = [DKNumericStatistic statisticWithInt:10];
    character.testStatistic2 = [DKNumericStatistic statisticWithInt:10];
    [character.testStatistic applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:character.testStatistic2]];
    
    DKStatistic* newStatistic2 = [DKNumericStatistic statisticWithInt:8];
    [newStatistic2 applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:character.testStatistic]];
    character.testStatistic2 = newStatistic2;
    XCTAssertEqual(character.testStatistic2.modifiers.count, 0, @"Statistic should drop all its modifiers instead of creating a modifier cycle.");
}

- (void)testModifierRouting {
    
    [_testCharacter addKeyPath:@"testStatistic" forStatisticID:@"test"];
    _testCharacter.testStatistic = _testStatistic;
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier has not been added yet.");
    
    [_testCharacter applyModifier:_testModifier toStatisticWithID:@"test"];
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @12, @"Modifier should be routed properly to the statistic.");
    
    [_testModifier removeFromStatistic];
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier should still be removed properly.");
}

- (void)testModifierGroupOperations {
    
    [_testCharacter addKeyPath:@"testStatistic" forStatisticID:@"test"];
    _testCharacter.testStatistic = _testStatistic;
    XCTAssertNil([_testCharacter modifierGroupForID:@"group"], @"Group has not been added yet.");
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier has not been added yet.");
    
    [_testCharacter addModifierGroup:_testGroup forGroupID:@"group"];
    XCTAssertEqual([_testCharacter modifierGroupForID:@"group"], _testGroup, @"Modifier group getter should return correct object.");
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @13, @"Modifier group should be applied properly.");
    
    [_testCharacter removeModifierGroup:_testGroup];
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier group should be removed properly.");
}

- (void)testModifierGroupKeypathOperations {
    
    [_testCharacter addKeyPath:@"testStatistic" forStatisticID:@"test"];
    _testCharacter.testStatistic = _testStatistic;
    
    [_testCharacter addKeyPath:@"modifierGroup" forModifierGroupID:@"group1"];
    DKModifierGroup* firstGroup = [[DKModifierGroup alloc] init];
    [firstGroup addModifier:_testModifier forStatisticID:@"test"];
    _testCharacter.modifierGroup = firstGroup;
    
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @12, @"Modifier group should be applied properly.");
    
    _testCharacter.modifierGroup = nil;
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier group should be removed properly.");
    
    _testCharacter.modifierGroup = firstGroup;
    [_testCharacter removeModifierGroupWithID:@"group1"];
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier group should be removed properly.");
}

@end
