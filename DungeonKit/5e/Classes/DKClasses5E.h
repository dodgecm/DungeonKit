//
//  DKClasses5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/28/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatisticGroup5E.h"
#import "DKCleric5E.h"
#import "DKFighter5E.h"
#import "DKRogue5E.h"
#import "DKWizard5E.h"

@class DKCharacter5E;

@interface DKClasses5E : DKStatisticGroup5E

@property (nonatomic, strong) DKCleric5E* cleric;
@property (nonatomic, strong) DKFighter5E* fighter;
@property (nonatomic, strong) DKRogue5E* rogue;
@property (nonatomic, strong) DKWizard5E* wizard;

- (id)init __unavailable;
- (id)initWithCharacter:(DKCharacter5E*)character;

@end