//
//  DKDependentModifier+5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/5/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKDependentModifier+5E.h"

@implementation DKDependentModifierBuilder (FifthEdition)

+ (id)proficiencyBonusModifierFromLevel:(NSObject<DKDependentModifierOwner>*)source {
    
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:^int(int valueToModify) {
                                                                              return MAX(0, ((valueToModify-1) / 4));
                                                                          }
                                                                       priority:kDKModifierPriority_Additive
                                                                          block:[DKModifierBuilder simpleAdditionModifierBlock]];
    return modifier;
}

@end