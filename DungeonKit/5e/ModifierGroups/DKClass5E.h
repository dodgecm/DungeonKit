//
//  DKClass5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifierGroup.h"

//Normally I would just use a typedef here, but KVO explodes after the use of C style unions.  Beware.
@compatibility_alias DKClass5E DKModifierGroup;

@interface DKClass5EBuilder : NSObject

+ (DKClass5E*)cleric;

@end