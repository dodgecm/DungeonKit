//
//  DKAbilities.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKAbilities.h"
#import "DKStatisticIdentifiers.h"

@implementation DKAbilityScore

@synthesize abilityModifier = _abilityModifier;

+ (id)scoreWithScore: (int) score {
    DKAbilityScore* newScore = [[[self class] alloc] initWithScore:score];
    return newScore;
}

- (id)initWithScore: (int) score {
    self = [super init];
    if (self) {
        self.base = score;
    }
    return self;
}

- (void)setBase:(int)base {
    [super setBase:MAX(0,base)]; //ability score base cannot go below 0
}

- (void)recalculateValue {
    [super recalculateValue];
    _abilityModifier = floor((self.value - 10) / 2.0);
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

@implementation DKAbilities

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
        NSAssert1([scoreArray count] == 6, @"Received score array with size %lu, expected 6", [scoreArray count]);
        for (NSNumber* score in scoreArray) {
            NSAssert2([score isKindOfClass:[NSNumber class]],
                      @"Received ability score of type %@ (%@), expected NSNumber", NSStringFromClass([score class]), score);
        }
        self.strength = [DKAbilityScore scoreWithScore:[scoreArray[0] intValue]];
        self.dexterity = [DKAbilityScore scoreWithScore:[scoreArray[1] intValue]];
        self.constitution = [DKAbilityScore scoreWithScore:[scoreArray[2] intValue]];
        self.intelligence = [DKAbilityScore scoreWithScore:[scoreArray[3] intValue]];
        self.wisdom = [DKAbilityScore scoreWithScore:[scoreArray[4] intValue]];
        self.charisma = [DKAbilityScore scoreWithScore:[scoreArray[5] intValue]];
    }
    
    return self;
}

- (id)initWithStr:(int)str dex:(int)dex con:(int)con intel:(int)intel wis:(int)wis cha:(int)cha {
    
    self = [super init];
    if (self) {

        self.strength = [DKAbilityScore scoreWithScore:str];
        self.dexterity = [DKAbilityScore scoreWithScore:dex];
        self.constitution = [DKAbilityScore scoreWithScore:con];
        self.intelligence = [DKAbilityScore scoreWithScore:intel];
        self.wisdom = [DKAbilityScore scoreWithScore:wis];
        self.charisma = [DKAbilityScore scoreWithScore:cha];
    }
    
    return self;
}

@end
