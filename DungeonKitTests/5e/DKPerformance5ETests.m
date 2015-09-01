//
//  DKPerformance5ETests.m
//  DungeonKit
//
//  Created by Christopher Dodge on 8/29/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "DKCharacter5E.h"
#import "DKModifierGroupTags5E.h"

@interface DKPerformance5ETests : XCTestCase
@property (nonatomic, strong) DKCharacter5E* character;
@end

@implementation DKPerformance5ETests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testCharacterCreation {
    // This is an example of a performance test case.
    [self measureBlock:^{
        
        _character = [[DKCharacter5E alloc] init];
    }];
}

- (void)testClassLevelUps {
    // This is an example of a performance test case.
    [self measureBlock:^{
        
        _character = [[DKCharacter5E alloc] init];
        _character.experiencePoints.base = @(-1);
        DKChoiceModifierGroup* classChoice = (DKChoiceModifierGroup*) [_character firstUnallocatedChoiceWithTag:DKChoiceClass];
        for (int i = 0; i < classChoice.choices.count; i++) {
            [classChoice choose:classChoice.choices[i]];
            for (int j = 1; j < 20; j++) {
                _character.level.base = @(j);
            }
        }
    }];
}

@end
