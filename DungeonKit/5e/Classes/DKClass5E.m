//
//  DKClass5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKClass5E.h"

@implementation DKClass5E

@synthesize classLevel = _classLevel;
@synthesize classModifiers = _classModifiers;

- (id)init {
    
    self = [super init];
    if (self) {
        self.classLevel = [DKStatistic statisticWithBase:0];
    }
    
    return self;
}

@end