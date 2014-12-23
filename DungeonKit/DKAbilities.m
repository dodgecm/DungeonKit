//
//  DKAbilities.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKAbilities.h"

@implementation DKAbilityScore

@synthesize score = _score;
@synthesize modifier = _modifier;

+ (id) scoreWithScore: (int) score {
    DKAbilityScore* newScore = [[[self class] alloc] initWithScore:score];
    return newScore;
}

- (id) initWithScore: (int) score {
    self = [super init];
    if (self) {
        self.score = score;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    DKAbilityScore* newAbilityScore = [[self class] allocWithZone:zone];
    newAbilityScore.score = self.score;
    return newAbilityScore;
}

- (void)setScore:(int)score {
    _score = MAX(0,score); //ability scores cannot go below 0
    _modifier = floor((_score - 10) / 2.0);
}

- (NSString*) formattedModifier {
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositivePrefix:@"+"];
    [numberFormatter setZeroSymbol:@"+0"];
    return [numberFormatter stringFromNumber:@(_modifier)];
}

@end

@implementation DKAbilities

@end
