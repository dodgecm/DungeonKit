//
//  DKDependantModifierTests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/4/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKStatistic.h"


@interface DKDependentModifierTests : XCTestCase

@end

@implementation DKDependentModifierTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testDependentModifier {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:2];
    DKStatistic* secondStatistic = [[DKStatistic alloc] initWithBase:14];
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:firstStatistic
                                                                          value:^int(int valueToModify) {
                                                                              return valueToModify;
                                                                          }
                                                                       priority:kDKModifierPriority_Additive
                                                                          block:^int(int modifierValue, int valueToModify) {
                                                                              return modifierValue + valueToModify;
                                                                          }];
    [secondStatistic applyModifier:modifier];
    XCTAssertEqual(secondStatistic.value, 16, @"Dependant modifier should be applied correctly.");
    firstStatistic.base = 4;
    XCTAssertEqual(secondStatistic.value, 18, @"Dependant modifier should be updated correctl when owner statistic changes.");
    [modifier removeFromStatistic];
    XCTAssertEqual(secondStatistic.value, 14, @"Dependant modifier should be removed correctly.");
}

- (void)testSimpleCycle {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:1];
    DKDependentModifier* firstModifier = [[DKDependentModifier alloc] initWithSource:firstStatistic
                                                                               value:^int(int valueToModify) {
                                                                                   return valueToModify;
                                                                               }
                                                                            priority:kDKModifierPriority_Additive
                                                                               block:^int(int modifierValue, int valueToModify) {
                                                                                   return modifierValue + valueToModify;
                                                                               }];
    [firstStatistic applyModifier:firstModifier];
}

- (void)testModifierInfiniteCycle {
    
    DKStatistic* firstStatistic = [[DKStatistic alloc] initWithBase:1];
    DKStatistic* secondStatistic = [[DKStatistic alloc] initWithBase:2];
    DKDependentModifier* firstModifier = [[DKDependentModifier alloc] initWithSource:firstStatistic
                                                                          value:^int(int valueToModify) {
                                                                              return valueToModify;
                                                                          }
                                                                       priority:kDKModifierPriority_Additive
                                                                          block:^int(int modifierValue, int valueToModify) {
                                                                              return modifierValue + valueToModify;
                                                                          }];
    DKDependentModifier* secondModifier = [[DKDependentModifier alloc] initWithSource:secondStatistic
                                                                               value:^int(int valueToModify) {
                                                                                   return valueToModify;
                                                                               }
                                                                            priority:kDKModifierPriority_Additive
                                                                               block:^int(int modifierValue, int valueToModify) {
                                                                                   return modifierValue + valueToModify;
                                                                               }];
    [secondStatistic applyModifier:firstModifier];
    //[firstStatistic applyModifier:secondModifier];
}



@end
