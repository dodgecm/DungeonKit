//
//  DKAbilities.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKAbilities5E.h"

@implementation DKAbilityScore

@synthesize abilityModifier = _abilityModifier;

- (void)setBase:(int)base {
    [super setBase:MAX(0,base)]; //ability score base cannot go below 0
}

- (void)recalculateValue {
    [super recalculateValue];
    _abilityModifier = floor((self.value - 10) / 2.0);
}

- (DKDependentModifier*) modifierFromAbilityScore {
    
    DKDependentModifier* dependentModifier = [[DKDependentModifier alloc] initWithSource:self
                                                                                   value:^int(int valueToModify) {
                                                                                       return valueToModify;
                                                                                   }
                                                                                priority:kDKModifierPriority_Additive
                                                                                   block:^int(int modifierValue, int valueToModify) {
                                                                                       return valueToModify + floor((modifierValue - 10) / 2.0);
                                                                                   }];
    return dependentModifier;
}

- (DKDependentModifier*) modifierFromAbilityScoreWithExplanation:(NSString*)explanation {
    DKDependentModifier* modifier = [self modifierFromAbilityScore];
    modifier.explanation = explanation;
    return modifier;
}

- (NSString*) formattedAbilityModifier {
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositivePrefix:@"+"];
    [numberFormatter setZeroSymbol:@"+0"];
    return [numberFormatter stringFromNumber:@(_abilityModifier)];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@(%i)", [self formattedAbilityModifier], self.value];
}

@end

@implementation DKAbilities5E

@synthesize strength = _strength;
@synthesize dexterity = _dexterity;
@synthesize constitution = _constitution;
@synthesize intelligence = _intelligence;
@synthesize wisdom = _wisdom;
@synthesize charisma = _charisma;

- (id)initWithScores:(NSNumber*)firstScore, ... NS_REQUIRES_NIL_TERMINATION {
    
    NSMutableArray* abilityScores = [NSMutableArray array];
    va_list args;
    int i;
    NSNumber* arg;
    va_start(args, firstScore);
    //Only parse the first 6 arguments; characters only have 6 abilities!
    for (arg = firstScore, i = 0; (arg != nil) && (i < 6); arg = va_arg(args, NSNumber*), i++)
    {
        NSAssert2([arg isKindOfClass:[NSNumber class]],
                  @"Received ability score of type %@ (%@), expected NSNumber", NSStringFromClass([arg class]), arg);
        [abilityScores addObject:arg];
    }
    va_end(args);
    
    return [self initWithScoreArray:abilityScores];
}

- (id)initWithScoreArray:(NSArray*)scoreArray {
    self = [super init];
    if (self) {
        //Input checking
        NSAssert1([scoreArray count] == 6, @"Received score array with size %lu, expected 6", (unsigned long) [scoreArray count]);
        for (NSNumber* score in scoreArray) {
            NSAssert2([score isKindOfClass:[NSNumber class]],
                      @"Received ability score of type %@ (%@), expected NSNumber", NSStringFromClass([score class]), score);
        }
        self.strength = [DKAbilityScore statisticWithBase:[scoreArray[0] intValue]];
        self.dexterity = [DKAbilityScore statisticWithBase:[scoreArray[1] intValue]];
        self.constitution = [DKAbilityScore statisticWithBase:[scoreArray[2] intValue]];
        self.intelligence = [DKAbilityScore statisticWithBase:[scoreArray[3] intValue]];
        self.wisdom = [DKAbilityScore statisticWithBase:[scoreArray[4] intValue]];
        self.charisma = [DKAbilityScore statisticWithBase:[scoreArray[5] intValue]];
    }
    
    return self;
}

- (id)initWithStr:(int)str dex:(int)dex con:(int)con intel:(int)intel wis:(int)wis cha:(int)cha {
    
    self = [super init];
    if (self) {

        self.strength = [DKAbilityScore statisticWithBase:str];
        self.dexterity = [DKAbilityScore statisticWithBase:dex];
        self.constitution = [DKAbilityScore statisticWithBase:con];
        self.intelligence = [DKAbilityScore statisticWithBase:intel];
        self.wisdom = [DKAbilityScore statisticWithBase:wis];
        self.charisma = [DKAbilityScore statisticWithBase:cha];
    }
    
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Abilities - STR:%@ DEX:%@ CON:%@ INT:%@ WIS:%@ CHA:%@",
            _strength, _dexterity, _constitution, _intelligence, _wisdom, _charisma];
}

@end
