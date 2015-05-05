//
//  DKDice.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKDice.h"
#import "DKModifierBuilder.h"

@implementation DKDice

@synthesize quantity = _quantity;
@synthesize sides = _sides;

+ (id)diceWithQuantity:(int)quantity sides:(int)sides {
    
    DKDice* newStat = [[[self class] alloc] initWithQuantity:quantity sides:sides];
    return newStat;
}

- (id)initWithQuantity:(int)quantity sides:(int)sides {
    
    self = [super initWithInt:0];
    if (self) {
        _quantity = [DKNumericStatistic statisticWithInt:quantity];
        _sides = [DKNumericStatistic statisticWithInt:sides];
        
        [_quantity applyModifier:[DKModifierBuilder modifierWithMinimum:0]];
        [_sides applyModifier:[DKModifierBuilder modifierWithMinimum:0]];
        
        [self roll];
    }
    return self;
}

- (int)roll {
    
    //Shortcut exit for the edge case of a zero sided die
    if (_quantity.intValue == 0 || _sides.intValue == 0) {
        self.base = 0;
        return 0;
    }
    
    int total = 0;
    for (int i = 0; i < _quantity.value.intValue; i++) {
        total += arc4random_uniform(_sides.value.intValue) + 1;
    }
    self.base = @(total);
    return total;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%id%i", _quantity.value.intValue, _sides.value.intValue];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:self.quantity forKey:@"quantity"];
    [aCoder encodeObject:self.sides forKey:@"sides"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _quantity = [aDecoder decodeObjectForKey:@"quantity"];
        _sides = [aDecoder decodeObjectForKey:@"sides"];
    }
    return self;
}

@end
