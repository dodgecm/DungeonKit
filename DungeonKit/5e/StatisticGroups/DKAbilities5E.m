//
//  DKAbilities.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKAbilities5E.h"
#import "DKModifierBuilder.h"

@implementation DKAbilityScore

@synthesize abilityModifier = _abilityModifier;

+ (NSExpression*)abilityScoreValueForDependency:(NSString*)dependency {
    
    NSExpression* subtract = [NSExpression expressionForFunction:@"from:subtract:" arguments:@[[NSExpression expressionForVariable:dependency],
                                                                                               [NSExpression expressionForConstantValue:@(10.0)]]];
    NSExpression* divide = [NSExpression expressionForFunction:@"divide:by:" arguments:@[subtract,
                                                                                         [NSExpression expressionForConstantValue:@(2.0)]]];
    return [NSExpression expressionForFunction:@"floor:" arguments:@[divide]];
}

+ (NSExpression*)diceCollectionValueFromAbilityScoreDependency:(NSString*)dependency {

    NSExpression* abilityScoreValue = [DKAbilityScore abilityScoreValueForDependency:dependency];
    
    return [NSExpression expressionForFunction:[NSExpression expressionForConstantValue:[DKDiceCollection diceCollection]]
                                  selectorName:@"diceByAddingModifier:"
                                     arguments:@[ abilityScoreValue ] ];
}

- (void)setBase:(NSNumber*)base {
    [super setBase:@(MAX(0,base.integerValue))]; //ability score base cannot go below 0
}

- (void)recalculateValue {
    [super recalculateValue];
    _abilityModifier = floor((self.value.integerValue - 10) / 2.0);
}

- (DKDependentModifier*) modifierFromAbilityScore {
    
    static NSExpression* abilityExpression;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        abilityExpression = [NSExpression expressionWithFormat: @"$input + floor:( ($value-10)/2.0 )"];
    });
    
    //Use the copy of abilityExpression so that we only have to do the expensive string parsing once
    DKDependentModifier* dependentModifier = [[DKDependentModifier alloc] initWithSource:self
                                                                                   value:[DKDependentModifierBuilder valueFromDependency:@"source"]
                                                                                priority:kDKModifierPriority_Additive
                                                                              expression:[abilityExpression copy]];
    return dependentModifier;
}

- (DKDependentModifier*) modifierFromAbilityScoreWithExplanation:(NSString*)explanation {
    DKDependentModifier* modifier = [self modifierFromAbilityScore];
    modifier.explanation = explanation;
    return modifier;
}

- (DKDependentModifier*)diceCollectionModifierFromAbilityScore {
    
    return [DKDependentModifierBuilder addedDiceModifierFromSource:self
                                                             value:[DKAbilityScore diceCollectionValueFromAbilityScoreDependency:@"source"]
                                                           enabled:nil
                                                       explanation:nil];
}

- (NSString*) formattedAbilityModifier {
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositivePrefix:@"+"];
    [numberFormatter setZeroSymbol:@"+0"];
    return [numberFormatter stringFromNumber:@(_abilityModifier)];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"%@(%i)", [self formattedAbilityModifier], self.value.intValue];
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
        self.strength = [DKAbilityScore statisticWithInt:[scoreArray[0] intValue]];
        self.dexterity = [DKAbilityScore statisticWithInt:[scoreArray[1] intValue]];
        self.constitution = [DKAbilityScore statisticWithInt:[scoreArray[2] intValue]];
        self.intelligence = [DKAbilityScore statisticWithInt:[scoreArray[3] intValue]];
        self.wisdom = [DKAbilityScore statisticWithInt:[scoreArray[4] intValue]];
        self.charisma = [DKAbilityScore statisticWithInt:[scoreArray[5] intValue]];
    }
    
    return self;
}

- (id)initWithStr:(int)str dex:(int)dex con:(int)con intel:(int)intel wis:(int)wis cha:(int)cha {
    
    return [self initWithScoreArray:@[ @(str), @(dex), @(con), @(intel), @(wis), @(cha) ]];
}

- (NSString*) description {
    return [NSString stringWithFormat:@"Abilities - STR:%@ DEX:%@ CON:%@ INT:%@ WIS:%@ CHA:%@",
            _strength, _dexterity, _constitution, _intelligence, _wisdom, _charisma];
}

@end
