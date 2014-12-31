//
//  DKCharacter.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKAbilities.h"
#import "DKStatistic.h"

@interface DKCharacter : NSObject {
    
}

@property (nonatomic, strong) DKAbilities* abilities;
@property (nonatomic, strong) DKStatistic* level;
@property (nonatomic, strong) DKStatistic* proficiencyBonus;
@property (nonatomic, strong) DKStatistic* armorClass;
@property (nonatomic, strong) DKStatistic* initiativeBonus;
@property (nonatomic, strong) DKStatistic* movementSpeed;

@end
