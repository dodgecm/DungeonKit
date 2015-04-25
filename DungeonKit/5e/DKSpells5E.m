//
//  DKSpells5E.m
//  DungeonKit
//
//  Created by Christopher Dodge on 4/25/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKSpells5E.h"

@implementation DKSpells5E

- (id)initWithProficiencyBonus:(DKStatistic*)proficiencyBonus {
    
    self = [super init];
    if (self) {
        
        if (!proficiencyBonus) {
            NSLog(@"DKSkills5E: Expected non-nil proficiency bonus: %@", proficiencyBonus);
            return nil;
        }
    }
    
    return self;
}

@end
