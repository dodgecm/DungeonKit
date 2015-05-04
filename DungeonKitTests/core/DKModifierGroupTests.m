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
#import "DKModifierBuilder.h"

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

@end
