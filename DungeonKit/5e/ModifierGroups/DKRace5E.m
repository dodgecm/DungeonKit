//
//  DKRace5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKRace5E.h"
#import "DKStatisticIDs5E.h"

@implementation DKRace5EBuilder

+ (DKRace5E*)dwarf {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2] forStatisticID:DKStatIDConstitution];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:25] forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:60] forStatisticID:DKStatIDDarkvision];
    return race;
}

+ (DKRace5E*)elf {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2] forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1] forStatisticID:DKStatIDSkillPerceptionProficiency];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:30] forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:60] forStatisticID:DKStatIDDarkvision];
    return race;
}

+ (DKRace5E*)halfling {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2] forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:25] forStatisticID:DKStatIDMoveSpeed];
    return race;
}

+ (DKRace5E*)human {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDStrength];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDConstitution];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDIntelligence];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDWisdom];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDCharisma];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:30] forStatisticID:DKStatIDMoveSpeed];
    return race;
}

@end


@implementation DKSubrace5EBuilder

+ (DKSubrace5E*)hillDwarf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDWisdom];
    return subrace;
}

+ (DKSubrace5E*)mountainDwarf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2] forStatisticID:DKStatIDStrength];
    return subrace;
}

+ (DKSubrace5E*)highElf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDIntelligence];
    return subrace;
}

+ (DKSubrace5E*)woodElf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDWisdom];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:5] forStatisticID:DKStatIDMoveSpeed];
    return subrace;
}

+ (DKSubrace5E*)lightfootHalfling {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDCharisma];
    return subrace;
}

+ (DKSubrace5E*)stoutHalfling {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1] forStatisticID:DKStatIDConstitution];
    return subrace;
}

@end