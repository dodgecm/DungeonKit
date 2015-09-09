//
//  DKBranchingModifierGroupTests.m
//  DungeonKit
//
//  Copyright (c) 2015 Chris Dodge
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKChoiceModifierGroup.h"
#import "DKModifierBuilder.h"

@interface DKChoiceModifierGroupTests : XCTestCase
@property (nonatomic, strong) DKChoiceModifierGroup* group;
@end

@implementation DKChoiceModifierGroupTests

@synthesize group = _group;

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _group = [[DKSingleChoiceModifierGroup alloc] initWithTag:@"ExampleChoiceGroup"];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testConstructors {
    
    XCTAssertNotNil(_group, @"Constructors should return non-nil object.");
}

- (void)testChoosingModifiers {

    [_group addModifier:[DKModifier numericModifierWithAdditiveBonus:1] forStatisticID:@"stat1"];
    [_group addModifier:[DKModifier numericModifierWithAdditiveBonus:2] forStatisticID:@"stat2"];
    [_group addModifier:[DKModifier numericModifierWithAdditiveBonus:3] forStatisticID:@"stat3"];
    DKModifier* modifierToChoose = [DKModifier numericModifierWithAdditiveBonus:4];
    [_group addModifier:modifierToChoose forStatisticID:@"stat4"];
    
    for (DKModifier* modifier in _group.modifiers) {
        XCTAssertFalse(modifier.enabled, @"Modifiers added to the group should be disabled unless they are chosen.");
    }
    
    [_group choose:modifierToChoose];
    XCTAssertTrue(modifierToChoose.enabled, @"Modifier that is chosen should be enabled.");
    XCTAssertEqual(modifierToChoose, _group.choice);
    
    [_group choose:nil];
    XCTAssertFalse(modifierToChoose.enabled, @"Chosen modifier should be cleared.");
}

- (void)testChoosingModifierNotInGroup {
    
    DKModifier* modifierToChoose = [DKModifier numericModifierWithAdditiveBonus:4];
    [_group choose:modifierToChoose];
    XCTAssertTrue(modifierToChoose.enabled, @"Modifier that is not in the group should be ignored.");
    XCTAssertNil(_group.choice, @"Modifier that is not in the group should be ignored.");
}


@end
