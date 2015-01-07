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

@interface DKTestCharacter : DKCharacter
@property (nonatomic, strong) DKStatistic* testStatistic;
@property (nonatomic, strong) DKStatistic* testStatistic2;
@end

@implementation DKTestCharacter
@synthesize testStatistic = _testStatistic;
@synthesize testStatistic2 = _testStatistic2;
@end

@interface DKCharacterTests : XCTestCase

@end

@implementation DKCharacterTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
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
    DKStatistic* testStat = [DKStatistic statisticWithBase:10];
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
    DKStatistic* testStat = [DKStatistic statisticWithBase:10];
    XCTAssertNil([character statisticForID:@"test"], @"Statistic should be start off as nil.");
    
    [character setStatistic:testStat forStatisticID:@"test"];
    XCTAssertEqual(10, [character statisticForID:@"test"].value, @"Statistic should be registered with its identifier properly.");
    XCTAssertEqual(testStat, [character statisticForID:@"test"], @"Statistic should be registered with its identifier properly.");
}

- (void)testAddKeyPath {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    character.testStatistic = [DKStatistic statisticWithBase:10];
    [character.testStatistic applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];

    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    XCTAssertEqual(character.testStatistic.value, 12, @"Statistic should calculate modifier properly.");
}

- (void)testStatisticToKeyPath {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    character.testStatistic = [DKStatistic statisticWithBase:10];
    DKStatistic* secondStatistic = [DKStatistic statisticWithBase:8];
    [secondStatistic applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    
    [character setStatistic:secondStatistic forStatisticID:@"test"];
    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    XCTAssertEqual([character statisticForID:@"test"].value, 10, @"Statistic should transfer modifiers when a statistic ID is replaced.");
}

- (void)testModifierCycle {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    [character addKeyPath:@"testStatistic2" forStatisticID:@"test2"];
    character.testStatistic = [DKStatistic statisticWithBase:10];
    character.testStatistic2 = [DKStatistic statisticWithBase:10];
    [character.testStatistic applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:character.testStatistic2]];
    
    DKStatistic* newStatistic2 = [DKStatistic statisticWithBase:8];
    [newStatistic2 applyModifier:[DKDependentModifierBuilder simpleModifierFromSource:character.testStatistic]];
    character.testStatistic2 = newStatistic2;
    XCTAssertEqual(character.testStatistic2.modifiers.count, 0, @"Statistic should drop all its modifiers instead of creating a modifier cycle.");
}

@end
