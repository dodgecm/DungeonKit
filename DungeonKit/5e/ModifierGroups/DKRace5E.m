//
//  DKRace5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/26/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKRace5E.h"
#import "DKStatisticIDs5E.h"
#import "DKCharacter5E.h"

@implementation DKRace5EBuilder

+ (DKRace5E*)dwarf {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Dwarven racial trait"]
       forStatisticID:DKStatIDConstitution];
    
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:25 explanation:@"Dwarven base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:60 explanation:@"Dwarven darkvision range"]
       forStatisticID:DKStatIDDarkvision];
    
    return race;
}

+ (DKRace5E*)elf {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Elven racial dexterity bonus"]
       forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithClampBetween:1 and:1 explanation:@"Elven keen senses trait"]
       forStatisticID:DKStatIDSkillPerceptionProficiency];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:30 explanation:@"Elven base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:60 explanation:@"Elven darkvision range"]
       forStatisticID:DKStatIDDarkvision];
    return race;
}

+ (DKRace5E*)halfling {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Halfling racial dexterity bonus"]
       forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:25 explanation:@"Halfling base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    return race;
}

+ (DKRace5E*)human {
    
    DKRace5E* race = [[DKRace5E alloc] init];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial strength bonus"]
       forStatisticID:DKStatIDStrength];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial dexterity bonus"]
       forStatisticID:DKStatIDDexterity];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial constitution bonus"]
       forStatisticID:DKStatIDConstitution];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial intelligence bonus"]
       forStatisticID:DKStatIDIntelligence];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial wisdom bonus"]
       forStatisticID:DKStatIDWisdom];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Human racial charisma bonus"]
       forStatisticID:DKStatIDCharisma];
    [race addModifier:[DKModifierBuilder modifierWithAdditiveBonus:30  explanation:@"Human base movement speed"]
       forStatisticID:DKStatIDMoveSpeed];
    return race;
}

@end


@implementation DKSubrace5EBuilder

+ (DKSubrace5E*)hillDwarfFromCharacter:(DKCharacter5E*)character {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Hill dwarf racial wisdom bonus"] forStatisticID:DKStatIDWisdom];
    
    DKModifier* hpModifier = [DKDependentModifierBuilder simpleModifierFromSource:character.level];
    hpModifier.explanation = @"Hill dwarf racial hit point bonus";
    [subrace addModifier:hpModifier forStatisticID:DKStatIDHitPointsMax];
    
    return subrace;
}

+ (DKSubrace5E*)mountainDwarf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:2 explanation:@"Mountain dwarf racial strength bonus"] forStatisticID:DKStatIDStrength];
    return subrace;
}

+ (DKSubrace5E*)highElf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"High elf racial intelligence bonus"] forStatisticID:DKStatIDIntelligence];
    return subrace;
}

+ (DKSubrace5E*)woodElf {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Wood elf racial wisdom bonus"] forStatisticID:DKStatIDWisdom];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:5 explanation:@"Wood elf racial movement speed bonus"] forStatisticID:DKStatIDMoveSpeed];
    return subrace;
}

+ (DKSubrace5E*)lightfootHalfling {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Lightfoot halfling racial charisma bonus"] forStatisticID:DKStatIDCharisma];
    return subrace;
}

+ (DKSubrace5E*)stoutHalfling {
    
    DKSubrace5E* subrace = [[DKSubrace5E alloc] init];
    [subrace addModifier:[DKModifierBuilder modifierWithAdditiveBonus:1 explanation:@"Stout halfling racial constitution bonus"] forStatisticID:DKStatIDConstitution];
    return subrace;
}

@end