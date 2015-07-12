//
//  DKChoiceModifierGroup.h
//  DungeonKit
//
//  Created by Christopher Dodge on 7/7/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKChoiceModifierGroup.h"

@implementation DKChoiceModifierGroup

@synthesize chosenModifier = _chosenModifier;

- (id)initWithTag:(NSString*)tag {
    self = [super init];
    if (self) {
        self.tag = tag;
    }
    return self;
}

- (void)chooseModifier:(DKModifier*)chosenModifier {
    
    if (!chosenModifier) {
        _chosenModifier.enabled = NO;
        _chosenModifier = nil;
        return;
    }
    
    if (![self.modifiers containsObject:chosenModifier]) {
        NSLog(@"DKBranchingModifierGroup: Attempted to choose a modifier (%@) that does not belong to the modifier group: %@.", chosenModifier, self);
        return;
    }
    
    for (DKModifier* modifier in self.modifiers) {
        if (modifier != chosenModifier) {
            modifier.enabled = NO;
        }
    }
    _chosenModifier = chosenModifier;
    _chosenModifier.enabled = YES;
}

#pragma DKModifierGroup Override
- (void)addModifier:(DKModifier*)modifier forStatisticID:(NSString*)statID {
    
    modifier.enabled = NO;
    [super addModifier:modifier forStatisticID:statID];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_chosenModifier forKey:@"chosenModifier"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _chosenModifier = [aDecoder decodeObjectForKey:@"chosenModifier"];
    }
    return self;
}

@end
