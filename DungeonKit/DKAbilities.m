//
//  DKAbilities.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKAbilities.h"

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

- (void)recalculateScore {
    [super recalculateScore];
    _abilityModifier = floor((self.score - 10) / 2.0);
}

- (NSString*) formattedAbilityModifier {
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositivePrefix:@"+"];
    [numberFormatter setZeroSymbol:@"+0"];
    return [numberFormatter stringFromNumber:@(_abilityModifier)];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@(%i)", [self formattedAbilityModifier], self.score];
}

@end

@implementation DKAbilities {
    NSMutableDictionary* _abilityNamesToScores;
}

+ (NSArray*) allAbilities {
    return @[@(kDKAbility_Strength), @(kDKAbility_Dexterity), @(kDKAbility_Constitution),
             @(kDKAbility_Intelligence), @(kDKAbility_Wisdom), @(kDKAbility_Charisma)];
}

+ (NSString*) descriptionForAbility: (DKAbility) ability {
    static NSDictionary* descriptions;
    if (!descriptions) {
        descriptions = @{ @(kDKAbility_Strength): @"STR",
                          @(kDKAbility_Dexterity): @"DEX",
                          @(kDKAbility_Constitution): @"CON",
                          @(kDKAbility_Intelligence): @"INT",
                          @(kDKAbility_Wisdom): @"WIS",
                          @(kDKAbility_Charisma): @"CHA"};
    }
    
    return [descriptions objectForKey:@(ability)];
}

- (id)init {
    NSAssert(false, @"Direct use of init is disable, please use one of the public constuctors instead");
    return nil;
}

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
        _abilityNamesToScores = [NSMutableDictionary dictionary];
        [self setScore:[scoreArray[0] intValue] ability:kDKAbility_Strength];
        [self setScore:[scoreArray[1] intValue] ability:kDKAbility_Dexterity];
        [self setScore:[scoreArray[2] intValue] ability:kDKAbility_Constitution];
        [self setScore:[scoreArray[3] intValue] ability:kDKAbility_Intelligence];
        [self setScore:[scoreArray[4] intValue] ability:kDKAbility_Wisdom];
        [self setScore:[scoreArray[5] intValue] ability:kDKAbility_Charisma];
    }
    
    return self;
}

- (id)initWithStr:(int)str dex:(int)dex con:(int)con intel:(int)intel wis:(int)wis cha:(int)cha {
    
    self = [super init];
    if (self) {

        _abilityNamesToScores = [NSMutableDictionary dictionary];
        [self setScore:str ability:kDKAbility_Strength];
        [self setScore:dex ability:kDKAbility_Dexterity];
        [self setScore:con ability:kDKAbility_Constitution];
        [self setScore:intel ability:kDKAbility_Intelligence];
        [self setScore:wis ability:kDKAbility_Wisdom];
        [self setScore:cha ability:kDKAbility_Charisma];
    }
    
    return self;
}

- (DKAbilityScore*)scoreObjectForAbility:(DKAbility)ability {
    return _abilityNamesToScores[[NSString stringWithFormat:@"%i", ability]];
}

- (int)scoreForAbility:(DKAbility)ability {
    return [[self scoreObjectForAbility:ability] score];
}

- (int)modifierForAbility:(DKAbility)ability {
    return [[self scoreObjectForAbility:ability] abilityModifier];
}

- (void)setScore:(int)score ability:(DKAbility)ability {
    _abilityNamesToScores[[NSString stringWithFormat:@"%i", ability]] = [DKAbilityScore scoreWithScore:score];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@:%@\t%@:%@\t%@:%@\t%@:%@\t%@:%@\t%@:%@",
            [DKAbilities descriptionForAbility:kDKAbility_Strength], [self scoreObjectForAbility:kDKAbility_Strength],
            [DKAbilities descriptionForAbility:kDKAbility_Dexterity], [self scoreObjectForAbility:kDKAbility_Dexterity],
            [DKAbilities descriptionForAbility:kDKAbility_Constitution], [self scoreObjectForAbility:kDKAbility_Constitution],
            [DKAbilities descriptionForAbility:kDKAbility_Intelligence], [self scoreObjectForAbility:kDKAbility_Intelligence],
            [DKAbilities descriptionForAbility:kDKAbility_Wisdom], [self scoreObjectForAbility:kDKAbility_Wisdom],
            [DKAbilities descriptionForAbility:kDKAbility_Charisma], [self scoreObjectForAbility:kDKAbility_Charisma]];
}

@end
