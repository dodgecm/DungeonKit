//
//  DKStatisticTests.m
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatistic.h"
#import "DKModifierBuilder.h"
#import "DKDiceCollection.h"

@interface DKStatisticTests : XCTestCase

@end

@implementation DKStatisticTests

- (void)testConstructors {
    
    XCTAssertNotNil([[DKNumericStatistic alloc] initWithInt:10], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKNumericStatistic statisticWithInt:10], @"Constructors should return non-nil object.");
}

- (void)testModifiers {
    DKNumericStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    XCTAssertEqualObjects(stat.base, @10, @"Unmodified statistic should start with correct score.");
    XCTAssertEqualObjects(stat.value, @10 , @"Unmodified statistic should start with correct score.");
    
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.base, @10, @"Modified statistic should calculate correct score.");
    XCTAssertEqualObjects(stat.value, @15, @"Modified statistic should calculate correct score.");
    XCTAssert([[stat modifiers] containsObject:modifier], @"Modified statistic should update its fields properly.");
    
    modifier.value = @3;
    XCTAssertEqualObjects(stat.value, @13, @"Modified statistic should update score when modifier value is changed.");
    [modifier removeFromStatistic];
    XCTAssertEqualObjects(stat.value, @10, @"Modified statistic should update score when modifier is removed.");
    modifier.value = @5;
    XCTAssertEqualObjects(stat.value, @10, @"Modified statistic should not update score when removed modifier is changed after the fact.");
}

- (void)testModifierSorting {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    DKModifier* secondModifier = [DKModifier numericModifierWithMin:18];
    [stat applyModifier:secondModifier];
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @18, @"Modifiers should be applied in the correct value.");
}

- (void)testModifierFiltering {
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* firstModifier = [DKModifier numericModifierWithAdditiveBonus:5];
    DKModifier* secondModifier = [DKModifier numericModifierWithAdditiveBonus:5];
    DKModifier* thirdModifier = [DKModifier numericModifierWithAdditiveBonus:5];
    DKModifier* fourthModifier = [DKModifier numericModifierWithAdditiveBonus:5];
    [stat applyModifier:firstModifier];
    [stat applyModifier:secondModifier];
    [stat applyModifier:thirdModifier];
    [stat applyModifier:fourthModifier];
    firstModifier.active = NO;
    thirdModifier.active = NO;
    
    NSArray* enabledModifiers = [stat enabledModifiers];
    XCTAssertFalse([enabledModifiers containsObject:firstModifier], @"Modifiers should get filtered correctly.");
    XCTAssertFalse([enabledModifiers containsObject:thirdModifier], @"Modifiers should get filtered correctly.");
    XCTAssertTrue([enabledModifiers containsObject:secondModifier], @"Modifiers should get filtered correctly.");
    XCTAssertTrue([enabledModifiers containsObject:fourthModifier], @"Modifiers should get filtered correctly.");
    
    NSArray* disabledModifiers = [stat disabledModifiers];
    XCTAssertTrue([disabledModifiers containsObject:firstModifier], @"Modifiers should get filtered correctly.");
    XCTAssertTrue([disabledModifiers containsObject:thirdModifier], @"Modifiers should get filtered correctly.");
    XCTAssertFalse([disabledModifiers containsObject:secondModifier], @"Modifiers should get filtered correctly.");
    XCTAssertFalse([disabledModifiers containsObject:fourthModifier], @"Modifiers should get filtered correctly.");
}

- (void)testModifierAdditionErrorCase {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    [stat applyModifier:nil];
}

- (void)testModifierRemovalErrorCase {
    
    DKStatistic* stat = [[DKNumericStatistic alloc] initWithInt:10];
    DKModifier* modifier = [DKModifier numericModifierWithAdditiveBonus:5];
    [stat removeModifier:modifier];
    [stat removeModifier:nil];
}

@end

@interface DKStringStatisticTests : XCTestCase
@end
@implementation DKStringStatisticTests

- (void)testConstructors {
    XCTAssertNotNil([[DKStringStatistic alloc] initWithString:@"test"], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKStringStatistic statisticWithString:@"test"], @"Constructors should return non-nil object.");
}

- (void)testModifierBuilder {
    
    DKStringStatistic* stat = [[DKStringStatistic alloc] initWithString:@"test"];
    DKModifier* modifier = [DKModifier stringModifierWithNewString:@"test2"];
    
    XCTAssertEqualObjects(stat.value, @"test", @"Object should start off with the correct value.");
    
    [stat applyModifier:modifier];
    XCTAssertEqualObjects(stat.value, @"test2", @"Object should replace the original value properly.");
    
    [modifier removeFromStatistic];
    XCTAssertEqualObjects(stat.value, @"test", @"Object should get removed from the statistic properly.");
}

@end

@interface DKSetStatisticTests : XCTestCase
@end
@implementation DKSetStatisticTests

- (void)testConstructors {
    XCTAssertNotNil([[DKSetStatistic alloc] initWithSet:[NSSet set]], @"Constructors should return non-nil object.");
    XCTAssertNotNil([DKSetStatistic statisticWithSet:[NSSet set]], @"Constructors should return non-nil object.");
}

- (void)testModifiers {
    
    NSExpression* expression = [NSExpression expressionForFunction:[NSExpression expressionForVariable:@"input"]
                                  selectorName:@"setByAddingObject:"
                                     arguments:@[ [NSExpression expressionForVariable:@"value"] ] ];
    
    DKSetStatistic* stat = [DKSetStatistic statisticWithSet:[NSSet set]];
    DKModifier* modifier = [[DKModifier alloc] initWithValue:@"something"
                                                    priority:kDKModifierPriority_Additive
                                                  expression:expression];
    [stat applyModifier:modifier];
    XCTAssertTrue([stat.value containsObject:@"something"], @"Object should get added to the set properly.");
}

- (void)testModifierBuilder {

    DKSetStatistic* stat = [DKSetStatistic statisticWithSet:[NSSet set]];
    DKModifier* modifier = [DKModifier setModifierWithAppendedObject:@"value1"];
    DKModifier* modifier2 = [DKModifier setModifierWithAppendedObject:@"value2"];
    DKModifier* modifier3 = [DKModifier setModifierWithAppendedObject:@"value3"];
    
    [stat applyModifier:modifier];
    [stat applyModifier:modifier2];
    [stat applyModifier:modifier3];
    XCTAssertTrue([stat.value containsObject:@"value1"], @"Object should get added to the set properly.");
    XCTAssertTrue([stat.value containsObject:@"value2"], @"Object should get added to the set properly.");
    XCTAssertTrue([stat.value containsObject:@"value3"], @"Object should get added to the set properly.");
    XCTAssertEqual(3, stat.value.count, @"There shouldn't be extra objects in the set.");
    
    [modifier2 removeFromStatistic];
    XCTAssertTrue([stat.value containsObject:@"value1"], @"Object should get removed from the set properly.");
    XCTAssertFalse([stat.value containsObject:@"value2"], @"Object should get removed from the set properly.");
    XCTAssertTrue([stat.value containsObject:@"value3"], @"Object should get removed from the set properly.");
    XCTAssertEqual(2, stat.value.count, @"There shouldn't be extra objects in the set.");
}

@end