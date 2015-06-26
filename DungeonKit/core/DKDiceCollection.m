//
//  DKDiceCollection.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKDiceCollection.h"
#import "DKModifierBuilder.h"

@interface DKDiceCollection()
@property (nonatomic, strong) NSDictionary* sidesToQuantityDict;
@end

@implementation DKDiceCollection

@synthesize sidesToQuantityDict = _sidesToQuantityDict;
@synthesize modifier = _modifier;

+ (id)diceCollection {
    DKDiceCollection* newCollection = [[[self class] alloc] init];
    return newCollection;
}

+ (id)diceCollectionWithQuantity:(NSInteger)quantity sides:(NSInteger)sides modifier:(NSInteger)modifier {
    
    DKDiceCollection* newCollection = [[[self class] alloc] initWithQuantity:quantity sides:sides modifier:modifier];
    return newCollection;
}

- (id)init {
    
    self = [super init];
    if (self) {
        _sidesToQuantityDict = [NSDictionary dictionary];
    }
    return self;
}

- (id)initWithQuantity:(NSInteger)quantity sides:(NSInteger)sides modifier:(NSInteger)modifier {
    
    self = [super init];
    if (self) {
        
        if (quantity != 0 && sides > 0) {
            _sidesToQuantityDict = @{ @(sides): @(quantity) };
        }
        else { _sidesToQuantityDict = @{}; }
        _modifier = modifier;
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary*)sidesToQuantity modifier:(NSInteger)modifier {
    self = [super init];
    if (self) {
        
        for (NSNumber* sides in sidesToQuantity.allKeys) {
            NSNumber* quantity = sidesToQuantity[sides];
            NSAssert1([quantity isKindOfClass:[NSNumber class]], @"Keys in dictionary should be of type NSNumber (invalid key: %@)", quantity);
            NSAssert1([sides isKindOfClass:[NSNumber class]], @"Values in dictionary should be of type NSNumber (invalid value: %@)", sides);
        }
        _sidesToQuantityDict = [sidesToQuantity copy];
        _modifier = modifier;
    }
    return self;
}

- (id)initWithDiceCollection:(DKDiceCollection*)collection {
    
    self = [super init];
    if (self) {

        NSMutableDictionary* mutableSidesToQuantity = [NSMutableDictionary dictionary];
        for (NSNumber* sides in collection.allSides) {
            NSInteger quantity = [collection quantityForSides:sides.integerValue];
            if (quantity && sides.integerValue > 0) { mutableSidesToQuantity[sides] = @(quantity); }
        }
        _sidesToQuantityDict = [mutableSidesToQuantity copy];
        _modifier = collection.modifier;
    }
    return self;
}

- (id)diceByAddingQuantity:(NSNumber*)quantity sides:(NSNumber*)sides {
    
    DKDiceCollection* diceToAdd = [DKDiceCollection diceCollectionWithQuantity:quantity.integerValue sides:sides.integerValue modifier:0];
    return [self diceByAddingDice:diceToAdd];
}

- (id)diceByAddingModifier:(NSNumber*)modifier {
    
    DKDiceCollection* modifierToAdd = [[DKDiceCollection alloc] initWithDictionary:@{} modifier:modifier.integerValue];
    return [self diceByAddingDice:modifierToAdd];
}

- (id)diceByAddingDice:(DKDiceCollection*)diceToAdd {
    
    NSMutableDictionary* mutableSidesToQuantity = [NSMutableDictionary dictionary];
    NSArray* combinedSides = [[diceToAdd allSides] arrayByAddingObjectsFromArray:[self allSides]];
    for (NSNumber* sides in combinedSides) {
        NSInteger quantity = [self quantityForSides:sides.integerValue] + [diceToAdd quantityForSides:sides.integerValue];
        if (quantity && sides.integerValue > 0) { mutableSidesToQuantity[sides] = @(quantity); }
    }
    NSInteger combinedModifier = self.modifier + diceToAdd.modifier;
    
    return [[DKDiceCollection alloc] initWithDictionary:[mutableSidesToQuantity copy] modifier:combinedModifier];
}

- (NSInteger)quantityForSides:(NSInteger)sides {
    return [_sidesToQuantityDict[@(sides)] integerValue];
}

- (NSArray*)allSides {
    return _sidesToQuantityDict.allKeys;
}

- (NSString*)stringValue {
    
    NSArray* sortedSides = [[self allSides] sortedArrayUsingSelector:@selector(compare:)];
    
    NSMutableString* string = [NSMutableString string];
    BOOL firstSides = YES;
    for (NSNumber* sides in [sortedSides reverseObjectEnumerator]) {
        NSNumber* quantity = _sidesToQuantityDict[sides];
        if (firstSides || quantity.integerValue < 0) {
            [string appendFormat:@"%@d%@", quantity, sides];
        } else {
            [string appendFormat:@"+%@d%@", quantity, sides];
        }
        firstSides = NO;
    }
    
    if (self.modifier != 0) {
        if (self.modifier > 0) {
            [string appendFormat:@"+%ld",  (long)self.modifier];
        } else {
            [string appendFormat:@"%ld",  (long)self.modifier];
        }
    }
    
    if (!string.length) {
        [string appendString:@"0"];
    }
    
    return string;
}

- (NSInteger)roll {
    
    //Shortcut exit for the edge case of a zero sided die
    int total = 0;
    for (NSNumber* sides in [self allSides]) {
        if (sides.integerValue <= 0) { continue; }
        NSInteger quantity = [self quantityForSides:sides.integerValue];
        for (int i = 0; i < quantity; i++) {
            total += arc4random_uniform(sides.intValue) + 1;
        }
    }

    return total + _modifier;
}

- (NSString*)description {
    return [self stringValue];
}

#pragma mark NSCopying
- (id)copyWithZone:(NSZone *)zone {
    
    DKDiceCollection* newCollection = [[self class] allocWithZone:zone];
    return [newCollection initWithDiceCollection:self];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.sidesToQuantityDict forKey:@"sidesToQuantityDict"];
    [aCoder encodeInteger:self.modifier forKey:@"modfiier"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _sidesToQuantityDict = [aDecoder decodeObjectForKey:@"sidesToQuantityDict"];
        _modifier = [aDecoder decodeIntegerForKey:@"modifier"];
    }
    return self;
}

@end
