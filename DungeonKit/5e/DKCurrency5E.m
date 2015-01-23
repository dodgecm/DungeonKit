//
//  DKCurrency5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKCurrency5E.h"

@implementation DKCurrency5E

@synthesize copper = _copper;
@synthesize silver = _silver;
@synthesize electrum = _electrum;
@synthesize gold = _gold;
@synthesize platinum = _platinum;

- (id)init {
    self = [super init];
    if (self) {
        self.copper = [DKStatistic statisticWithBase:0];
        self.silver = [DKStatistic statisticWithBase:0];
        self.electrum = [DKStatistic statisticWithBase:0];
        self.gold = [DKStatistic statisticWithBase:0];
        self.platinum = [DKStatistic statisticWithBase:0];
    }
    return self;
}

- (NSString*) description {
    return [NSString stringWithFormat:@"PP: %i GP: %i EP: %i SP: %i CP: %i",
            _platinum.value, _gold.value, _electrum.value, _silver.value, _copper.value];
}

@end
