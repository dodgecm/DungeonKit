//
//  DKDependentModifier+5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/5/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKDependentModifier.h"

/** The DKDependentModifierBuilder class provides convenience initialization methods for generating common modifiers from statistics. */
@interface DKDependentModifierBuilder (FifthEdition)

+ (id)proficiencyBonusModifierFromLevel:(NSObject<DKModifierOwner>*)source;

@end