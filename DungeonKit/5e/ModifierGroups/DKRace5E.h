//
//  DKRace5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifierGroup.h"

typedef DKModifierGroup DKRace5E;
typedef DKModifierGroup DKSubrace5E;

@interface DKRace5EBuilder : NSObject

+ (DKRace5E*)dwarf;
+ (DKRace5E*)elf;
+ (DKRace5E*)halfling;
+ (DKRace5E*)human;

@end

@interface DKSubrace5EBuilder : NSObject

+ (DKSubrace5E*)hillDwarf;
+ (DKSubrace5E*)mountainDwarf;

+ (DKSubrace5E*)highElf;
+ (DKSubrace5E*)woodElf;

+ (DKSubrace5E*)lightfootHalfling;
+ (DKSubrace5E*)stoutHalfling;

@end