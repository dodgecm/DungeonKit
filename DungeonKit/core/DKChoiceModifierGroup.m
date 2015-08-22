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

- (void)chooseModifier:(DKModifier*)chosenModifier {
    
    if (!chosenModifier) {
        _chosenModifier.active = NO;
        _chosenModifier = nil;
        return;
    }
    
    if (![self.modifiers containsObject:chosenModifier]) {
        NSLog(@"DKChoiceModifierGroup: Attempted to choose a modifier (%@) that does not belong to the modifier group: %@.", chosenModifier, self);
        return;
    }
    
    for (DKModifier* modifier in self.modifiers) {
        if (modifier != chosenModifier) {
            modifier.active = NO;
        }
    }
    _chosenModifier = chosenModifier;
    _chosenModifier.active = YES;
}

#pragma DKModifierGroup Override
- (void)addModifier:(DKModifier*)modifier forStatisticID:(NSString*)statID {
    
    modifier.active = NO;
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

#pragma mark -

@implementation DKMultipleChoiceModifierGroup

@synthesize chosenGroup = _chosenGroup;

- (void)setSubgroup:(DKModifierGroup*)subgroup
          toEnabled:(BOOL)enabled {
    for (DKModifier* modifier in subgroup.modifiers) {
        modifier.active = enabled;
    }
}

- (void)chooseModifierGroup:(DKModifierGroup*)chosenModifierGroup {
    
    if (!chosenModifierGroup) {
        [self setSubgroup:_chosenGroup toEnabled:NO];
        _chosenGroup = nil;
        return;
    }
    
    if (![self.subgroups containsObject:chosenModifierGroup]) {
        NSLog(@"DKMultipleChoiceModifierGroup: Attempted to choose a modifier group (%@) that is not a subgroup of the modifier group: %@.", chosenModifierGroup, self);
        return;
    }
    
    for (DKModifierGroup* subgroup in self.subgroups) {
        if (subgroup != chosenModifierGroup) {
            [self setSubgroup:subgroup toEnabled:NO];
        }
    }
    _chosenGroup = chosenModifierGroup;
    [self setSubgroup:_chosenGroup toEnabled:YES];
}

#pragma DKModifierGroupOwner

- (void)group:(DKModifierGroup*)modifierGroup willAddModifier:(DKModifier*)modifier forStatID:(NSString*)statID {
    if (modifierGroup != _chosenGroup) {
        modifier.active = NO;
    }
    [super group:modifierGroup willAddModifier:modifier forStatID:statID];
}

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [super encodeWithCoder:aCoder];
    [aCoder encodeObject:_chosenGroup forKey:@"chosenGroup"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        _chosenGroup = [aDecoder decodeObjectForKey:@"chosenGroup"];
    }
    return self;
}

@end
