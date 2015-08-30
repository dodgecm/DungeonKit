//
//  DKCharacterTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatisticGroup.h"
#import "DKModifierBuilder.h"

@interface DKTestCharacter : DKStatisticGroup
@property (nonatomic, strong) DKStatistic* testStatistic;
@property (nonatomic, strong) DKStatistic* testStatistic2;
@property (nonatomic, strong) DKModifierGroup* modifierGroup;
@property (nonatomic, strong) DKModifierGroup* modifierGroup2;
@property (nonatomic, strong) DKTestCharacter* statGroup;
@end

@implementation DKTestCharacter
@synthesize testStatistic = _testStatistic;
@synthesize testStatistic2 = _testStatistic2;
@synthesize modifierGroup = _modifierGroup;
@synthesize modifierGroup2 = _modifierGroup2;
@synthesize statGroup = _statGroup;
@end

@interface DKCharacterTests : XCTestCase

@property (nonatomic, strong) DKTestCharacter* testCharacter;
@property (nonatomic, strong) DKTestCharacter* testStatGroup;
@property (nonatomic, strong) DKStatistic* testStatistic;
@property (nonatomic, strong) DKModifier* testModifier;
@property (nonatomic, strong) DKModifierGroup* testGroup;

@end

@implementation DKCharacterTests

@synthesize testCharacter = _testCharacter;
@synthesize testStatGroup = _testStatGroup;
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
    
    self.testStatGroup = [[DKTestCharacter alloc] init];
    [_testStatGroup addKeyPath:@"testStatistic" forStatisticID:@"subgroupStatistic"];
    _testStatGroup.testStatistic = [DKNumericStatistic statisticWithInt:12];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKStatisticGroup alloc] init], @"Constructors should return non-nil object.");
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
    XCTAssertEqualObjects([character statisticForID:@"test"].value, @12, @"Statistic should transfer modifiers when a statistic ID is replaced.");
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
    XCTAssertNil(firstGroup.owner, @"Owner should start off as nil");
    [firstGroup addModifier:_testModifier forStatisticID:@"test"];
    _testCharacter.modifierGroup = firstGroup;
    XCTAssertEqual(firstGroup.owner, _testCharacter, @"Owner should be set when modifier group is set.");
    
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @12, @"Modifier group should be applied properly.");
    
    _testCharacter.modifierGroup = nil;
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier group should be removed properly.");
    
    _testCharacter.modifierGroup = firstGroup;
    [_testCharacter removeModifierGroupWithID:@"group1"];
    XCTAssertEqualObjects(_testCharacter.testStatistic.value, @10, @"Modifier group should be removed properly.");
    XCTAssertNil(firstGroup.owner, @"Owner should be nil after it's removed");
    
    [_testCharacter addKeyPath:@"modifierGroup" forModifierGroupID:@"group1"];
    XCTAssertEqual(firstGroup.owner, _testCharacter, @"Owner should be set when modifier group is set.");
}

- (void)testStatisticGroupOperations {
    
    XCTAssertNil([_testCharacter statisticForID:@"subgroupStatistic"], @"Statistic group has not been added yet.");
    XCTAssertNil(self.testStatGroup.owner, @"Owner should start off as nil.");
    
    [_testCharacter addKeyPath:@"statGroup" forStatisticGroupID:@"testGroup"];
    _testCharacter.statGroup = self.testStatGroup;
    
    XCTAssertEqual(self.testStatGroup.owner, _testCharacter, @"Owner should be set correctly.");
    XCTAssertEqualObjects(_testCharacter.statGroup.testStatistic, [_testCharacter statisticForID:@"subgroupStatistic"], @"Parent group should be able to find the statistic.");
    XCTAssertEqualObjects([_testCharacter statisticForID:@"subgroupStatistic"].value, @12, @"Statistic should have the right value.");
    
    [_testCharacter applyModifier:self.testModifier toStatisticWithID:@"subgroupStatistic"];
    XCTAssertEqualObjects([_testCharacter statisticForID:@"subgroupStatistic"].value, @14, @"Modifier should be applied properly.");
    
    [_testCharacter removeStatisticGroupWithID:@"testGroup"];
    XCTAssertNil([_testCharacter statisticForID:@"subgroupStatistic"], @"Statistic group was removed.");
    XCTAssertNil(self.testStatGroup.owner, @"Owner should be removed properly.");
    
    [_testCharacter addKeyPath:@"statGroup" forStatisticGroupID:@"testGroup"];
    XCTAssertEqual(self.testStatGroup.owner, _testCharacter, @"Owner should be set correctly.");
}

- (void)testEncoding {
    
    DKTestCharacter* character = [[DKTestCharacter alloc] init];
    character.testStatistic = [DKNumericStatistic statisticWithInt:10];
    DKStatistic* secondStatistic = [DKNumericStatistic statisticWithInt:8];
    [secondStatistic applyModifier:[DKModifierBuilder modifierWithAdditiveBonus:2]];
    
    [character setStatistic:secondStatistic forStatisticID:@"test2"];
    [character addKeyPath:@"testStatistic" forStatisticID:@"test"];
    
    DKModifierGroup* group1 = [[DKModifierGroup alloc] init];
    DKModifier* group1Modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [group1 addModifier:group1Modifier forStatisticID:@"test"];
    [character addModifierGroup:group1 forGroupID:@"group1"];
    
    DKModifierGroup* group2 = [[DKModifierGroup alloc] init];
    DKModifier* group2Modifier = [DKModifierBuilder modifierWithAdditiveBonus:15];
    [group2 addModifier:group2Modifier forStatisticID:@"test2"];
    character.modifierGroup2 = group2;
    [character addKeyPath:@"modifierGroup2" forModifierGroupID:@"group2"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@%@", documentsDirectory, @"encodeCharacterTest"];
    [NSKeyedArchiver archiveRootObject:character toFile:filePath];
    
    DKTestCharacter* decodedCharacter = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    XCTAssertNotNil([decodedCharacter statisticForID:@"test"], @"Character should be decoded with all its statistics.");
    XCTAssertNotNil([decodedCharacter statisticForID:@"test2"], @"Character should be decoded with all its statistics.");
    XCTAssertNotNil(decodedCharacter.testStatistic, @"Character should be decoded with all its statistics.");
    
    XCTAssertNotNil([decodedCharacter modifierGroupForID:@"group1"], @"Character should be decoded with all its modifier groups.");
    XCTAssertNotNil([decodedCharacter modifierGroupForID:@"group2"], @"Character should be decoded with all its modifier groups.");
    XCTAssertNotNil(decodedCharacter.modifierGroup2, @"Character should be decoded with all its modifier groups.");
}

@end
