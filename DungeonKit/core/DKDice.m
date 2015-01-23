//
//  DKDice.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKDice.h"

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
        _quantity = [DKStatistic statisticWithBase:quantity];
        _sides = [DKStatistic statisticWithBase:sides];
        
        [self roll];
    }
    return self;
}

- (int)roll {
    
    //Shortcut exit for the edge case of a zero sided die
    if (_quantity.value == 0 || _sides.value == 0) {
        self.base = 0;
        return 0;
    }
    
    int total = 0;
    for (int i = 0; i < _quantity.value; i++) {
        total += arc4random_uniform(_sides.value) + 1;
    }
    self.base = total;
    return total;
}

@end
