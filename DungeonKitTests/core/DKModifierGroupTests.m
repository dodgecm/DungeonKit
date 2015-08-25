//
//  DKModifierGroupTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/24/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKModifierGroup.h"
#import "DKChoiceModifierGroup.h"
#import "DKModifierBuilder.h"
#import "DKStatisticGroup.h"
#import "DKStatistic.h"

@interface DKModifierGroupTests : XCTestCase

@end

@implementation DKModifierGroupTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil([[DKModifierGroup alloc] init], @"Constructors should return non-nil object.");
}

- (void)testAddModifier {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [group addModifier:modifier forStatisticID:@"test"];
    XCTAssertTrue([group.modifiers containsObject:modifier], @"Modifier should be added to the group");
    XCTAssertEqual(group.modifiers.count, 1, @"Modifier should be added to the group");
    XCTAssertEqualObjects([group statIDForModifier:modifier], @"test", @"Stat ID for modifier should be stored properly");
}

- (void)testRemoveModifier {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [group addModifier:modifier forStatisticID:@"test"];
    [group removeModifier:modifier];
    XCTAssertFalse([group.modifiers containsObject:modifier], @"Modifier should be removed from the group");
    XCTAssertEqual(group.modifiers.count, 0, @"Modifier should be removed from the group");
    XCTAssertNil([group statIDForModifier:modifier], @"Stat ID for modifier should be removed properly");
}

- (void)testAddSubgroup {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifierGroup* secondGroup = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [secondGroup addModifier:modifier forStatisticID:@"test"];
    [group addSubgroup:secondGroup];
    XCTAssertTrue([group.subgroups containsObject:secondGroup], @"Subgroup should be added to the group");
    XCTAssertEqual(group.subgroups.count, 1, @"Subgroup should be added to the group");
    XCTAssertEqual(secondGroup.owner, group, @"Subgroup's owner should be the parent group");
    XCTAssertTrue([group.modifiers containsObject:modifier], @"Modifier should be added to the group");
    XCTAssertEqual(group.modifiers.count, 1, @"Modifier should be added to the group");
    XCTAssertEqualObjects([group statIDForModifier:modifier], @"test", @"Stat ID for modifier should be stored properly");
}

- (void)testRemoveSubgroup {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifierGroup* secondGroup = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [secondGroup addModifier:modifier forStatisticID:@"test"];
    [group addSubgroup:secondGroup];
    [group removeSubgroup:secondGroup];
    XCTAssertFalse([group.subgroups containsObject:secondGroup], @"Subgroup should be removed from the group");
    XCTAssertEqual(group.subgroups.count, 0, @"Subgroup should be removed from the group");
    XCTAssertEqual(secondGroup.owner, nil, @"Removed subgroup's owner should be nil");
    XCTAssertFalse([group.modifiers containsObject:modifier], @"Modifier should be removed from the group");
    XCTAssertEqual(group.modifiers.count, 0, @"Modifier should be removed the group");
    XCTAssertNil([group statIDForModifier:modifier], @"Stat ID for modifier should be removed properly");
}

- (void)testMultipleSubgroupLevels {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifierGroup* secondGroup = [[DKModifierGroup alloc] init];
    DKModifierGroup* thirdGroup = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [thirdGroup addModifier:modifier forStatisticID:@"test"];
    [group addSubgroup:secondGroup];
    [secondGroup addSubgroup:thirdGroup];
    XCTAssertTrue([group.modifiers containsObject:modifier], @"Modifier should be added to the group");
    XCTAssertEqual(group.modifiers.count, 1, @"Modifier should be added to the group");
    XCTAssertEqualObjects([group statIDForModifier:modifier], @"test", @"Stat ID for modifier should be stored properly");
    
    [thirdGroup removeModifier:modifier];
    XCTAssertTrue([group.subgroups containsObject:secondGroup], @"Subgroup should be added to the group");
    XCTAssertEqual(group.subgroups.count, 1, @"Subgroup should be added to the group");
    XCTAssertEqual(secondGroup.owner, group, @"Subgroup's owner should be the parent group");
    XCTAssertFalse([group.modifiers containsObject:modifier], @"Modifier should be removed from the group");
    XCTAssertEqual(group.modifiers.count, 0, @"Modifier should be removed the group");
    XCTAssertNil([group statIDForModifier:modifier], @"Stat ID for modifier should be removed properly");
    
    [thirdGroup addModifier:modifier forStatisticID:@"test"];
    [secondGroup removeModifier:modifier];
    XCTAssertFalse([group.modifiers containsObject:modifier], @"Modifier should be removed from the group");
    XCTAssertEqual(group.modifiers.count, 0, @"Modifier should be removed the group");
    XCTAssertFalse([secondGroup.modifiers containsObject:modifier], @"Modifier should be removed from the group");
    XCTAssertEqual(secondGroup.modifiers.count, 0, @"Modifier should be removed the group");
    XCTAssertTrue([thirdGroup.modifiers containsObject:modifier], @"Modifier should be added to the group");
    XCTAssertEqual(thirdGroup.modifiers.count, 1, @"Modifier should be added to the group");
}

- (void)testRemoveFromOwner {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifierGroup* secondGroup = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [secondGroup addModifier:modifier forStatisticID:@"test"];
    [group addSubgroup:secondGroup];
    [secondGroup removeFromOwner];
    XCTAssertFalse([group.subgroups containsObject:secondGroup], @"Subgroup should be removed from the group");
    XCTAssertEqual(group.subgroups.count, 0, @"Subgroup should be removed from the group");
    XCTAssertEqual(secondGroup.owner, nil, @"Removed subgroup's owner should be nil");
    XCTAssertFalse([group.modifiers containsObject:modifier], @"Modifier should be removed from the group");
    XCTAssertEqual(group.modifiers.count, 0, @"Modifier should be removed the group");
    XCTAssertNil([group statIDForModifier:modifier], @"Stat ID for modifier should be removed properly");
}

- (void)testDestructiveModifiers {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [group addModifier:nil forStatisticID:@"test"];
    [group addModifier:modifier forStatisticID:nil];
    [group addModifier:nil forStatisticID:nil];
    [group removeModifier:nil];
    XCTAssertEqual(group.modifiers.count, 0, @"Modifier should not have been added to the group");
}

- (void)testDestructiveModifierGroups {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    [group addSubgroup:nil];
    [group removeSubgroup:nil];
    XCTAssertEqual(group.subgroups.count, 0, @"Subgroup should not have been added to the group");
}

- (void)testSubgroupTags {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifierGroup* groupTwo = [[DKModifierGroup alloc] init];
    DKModifierGroup* groupThree = [[DKModifierGroup alloc] init];
    DKModifierGroup* groupFour = [[DKModifierGroup alloc] init];
    [groupThree addSubgroup:groupFour];
    [group addSubgroup:groupTwo];
    [group addSubgroup:groupThree];
    
    groupTwo.tag = @"two";
    groupThree.tag = @"three";
    groupFour.tag = @"four";
    XCTAssertEqualObjects([groupThree allSubgroupsWithTag:@"four"], @[ groupFour ], @"Subgroup tags should be searched correctly.");
    XCTAssertEqualObjects([groupThree firstSubgroupWithTag:@"four"], groupFour, @"Subgroup tags should be searched correctly.");
    XCTAssertEqualObjects([group allSubgroupsWithTag:@"four"], @[ groupFour ], @"Subgroup tags should be searched correctly.");
    XCTAssertEqualObjects([group firstSubgroupWithTag:@"four"], groupFour, @"Subgroup tags should be searched correctly.");
    
    groupThree.tag = @"same";
    groupFour.tag = @"same";
    NSArray* sameGroups = @[ groupThree, groupFour ];
    XCTAssertEqualObjects([group allSubgroupsWithTag:@"same"], sameGroups, @"Subgroup tags should be searched correctly.");
    XCTAssertEqualObjects([group firstSubgroupWithTag:@"same"], groupThree, @"Subgroup tags should be searched correctly.");
    
    XCTAssertEqualObjects([group allSubgroupsWithTag:@"none"], @[], @"Subgroup tags should be searched correctly.");
    XCTAssertNil([group firstSubgroupWithTag:@"none"], @"Subgroup tags should be searched correctly.");
}

- (void)testSubgroupTypes {
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifierGroup* groupTwo = [[DKSingleChoiceModifierGroup alloc] initWithTag:@"single"];
    DKModifierGroup* groupThree = [[DKSubgroupChoiceModifierGroup alloc] initWithTag:@"subgroup"];
    DKModifierGroup* groupFour = [[DKModifierGroup alloc] init];
    [groupThree addSubgroup:groupFour];
    [group addSubgroup:groupTwo];
    [group addSubgroup:groupThree];
    
    NSArray* allChoices = [group allSubgroupsOfType:[DKChoiceModifierGroup class]];
    XCTAssertTrue([allChoices containsObject:groupTwo] && [allChoices containsObject:groupThree], @"Subgroup type should be searched correctly.");
    XCTAssertEqual(allChoices.count, 2, @"Subgroup type should be searched correctly.");
}

- (void)testDependencies {
    
    DKStatisticGroup* statGroup = [[DKStatisticGroup alloc] init];
    DKNumericStatistic* stat = [[DKNumericStatistic alloc] initWithInt:0];
    [statGroup setStatistic:stat forStatisticID:@"stat"];
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    
    [group addDependency:stat forKey:@"source"];
    group.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:3];
    [statGroup addModifierGroup:group forGroupID:@"group"];
    
    XCTAssertFalse(group.enabled, @"Group should not be enabled, since modifier is not added to the group yet.");
    
    [statGroup applyModifier:modifier toStatisticWithID:@"stat"];
    XCTAssertTrue(group.enabled, @"Group should be enabled, since source statistic is over the threshold.");
    
    stat.base = @(-5);
    XCTAssertFalse(group.enabled, @"Group should not be enabled, since source statistic is under the threshold.");
}

- (void)testMultiLevelDependencies {
    
    DKStatisticGroup* statGroup = [[DKStatisticGroup alloc] init];
    DKNumericStatistic* stat = [[DKNumericStatistic alloc] initWithInt:0];
    [statGroup setStatistic:stat forStatisticID:@"stat"];
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    [group addDependency:stat forKey:@"source"];
    group.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:3];
    [statGroup addModifierGroup:group forGroupID:@"group"];
    
    DKModifierGroup* subgroup = [[DKModifierGroup alloc] init];
    [subgroup addDependency:stat forKey:@"source"];
    subgroup.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:5];
    [group addSubgroup:subgroup];
    
    DKModifier* enableModifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [subgroup addModifier:enableModifier forStatisticID:@"irrelevant"];
    
    XCTAssertFalse(enableModifier.enabled, @"Neither group nor subgroup have their enabled condition met.");
    stat.base = @3;
    XCTAssertFalse(enableModifier.enabled, @"Subgroup does not have its enabled condition met.");
    stat.base = @5;
    XCTAssertTrue(enableModifier.enabled, @"Subgroup has its enabled condition met.");
    
    group.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:5];
    subgroup.enabledPredicate = [DKDependentModifierBuilder enabledWhen:@"source" isGreaterThanOrEqualTo:3];
    XCTAssertTrue(enableModifier.enabled, @"Subgroup has its enabled condition met.");
    stat.base = @3;
    XCTAssertFalse(enableModifier.enabled, @"Subgroup does not have its enabled condition met due to owner group being disabled.");
    stat.base = @0;
    XCTAssertFalse(enableModifier.enabled, @"Neither group nor subgroup have their enabled condition met.");
}

- (void)testEncoding {
    
    DKModifierGroup* group = [[DKModifierGroup alloc] init];
    DKModifierGroup* secondGroup = [[DKModifierGroup alloc] init];
    DKModifierGroup* thirdGroup = [[DKModifierGroup alloc] init];
    DKModifier* modifier = [DKModifierBuilder modifierWithAdditiveBonus:5];
    [thirdGroup addModifier:modifier forStatisticID:@"test"];
    [group addSubgroup:secondGroup];
    [secondGroup addSubgroup:thirdGroup];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    NSString* documentsDirectory = [paths objectAtIndex:0];
    NSString* filePath = [NSString stringWithFormat:@"%@%@", documentsDirectory, @"encodeModifierGroupTest"];
    [NSKeyedArchiver archiveRootObject:group toFile:filePath];
    
    DKModifierGroup* decodedGroup = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    XCTAssertEqual(decodedGroup.modifiers.count, group.modifiers.count, @"Decoded group should be identical");
    DKModifier* decodedModifier = decodedGroup.modifiers[0];
    XCTAssertEqualObjects([decodedGroup statIDForModifier:decodedModifier], [group statIDForModifier:modifier], @"Modifier ownership should be restored properly");
}

@end
