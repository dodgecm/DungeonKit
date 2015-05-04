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
    
    self = [super initWithBase:0];
    if (self) {
        _quantity = [DKNumericStatistic statisticWithBase:quantity];
        _sides = [DKNumericStatistic statisticWithBase:sides];
        
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

@end
