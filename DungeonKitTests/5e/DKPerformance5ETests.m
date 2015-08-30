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

@interface DKPerformance5ETests : XCTestCase
@property (nonatomic, strong) DKCharacter5E* character;
@end

@implementation DKPerformance5ETests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _character = [[DKCharacter5E alloc] init];
}

- (void)testClassLevelUps {
    // This is an example of a performance test case.
    [self measureBlock:^{
        
        _character.classes = [[DKClasses5E alloc] initWithCharacter:_character];
        NSArray* allClasses = @[ _character.classes.cleric, _character.classes.fighter, _character.classes.rogue, _character.classes.wizard ];
        for (DKClass5E* class in allClasses) {
            for (int i = 1; i < 20; i++) {
                class.classLevel.base = @(i);
            }
        }
    }];
}

@end
