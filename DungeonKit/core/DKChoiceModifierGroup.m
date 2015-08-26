//
//  DKChoiceModifierGroup.h
//  DungeonKit
//
//  Created by Christopher Dodge on 7/7/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKChoiceModifierGroup.h"

@implementation DKChoiceModifierGroup

- (id<NSObject>)choice { return nil; }
- (NSArray*)choices { return @[]; }

- (void)choose:(id)choice { }

@end

#pragma mark -

@interface DKSingleChoiceModifierGroup()
@end

@implementation DKSingleChoiceModifierGroup

@synthesize chosenModifier = _chosenModifier;

- (void)chooseModifier:(DKModifier*)chosenModifier {
    [self choose:chosenModifier];
}

#pragma DKChoiceModifierGroup override
- (id<NSObject>)choice {
    return _chosenModifier;
}

- (NSArray*)choices {
    return self.modifiers;
}

- (void)choose:(id)choice {
    
    if (choice && ![choice isKindOfClass:[DKModifier class]]) {
        NSLog(@"DKSingleChoiceModifierGroup: Attempted to choose an object: %@ that is not of type DKModifier.", choice);
        return;
    }
    
    DKModifier* chosenModifier = (DKModifier*)choice;
    if (chosenModifier && ![self.modifiers containsObject:chosenModifier]) {
        NSLog(@"DKChoiceModifierGroup: Attempted to choose a modifier (%@) that does not belong to the modifier group: %@.", chosenModifier, self);
        return;
    }
    
    _chosenModifier = chosenModifier;
    [self refresh];
}

#pragma DKModifierGroup override
- (BOOL)shouldModifierBeActive:(DKModifier*)modifier {
    return self.enabled && (modifier == _chosenModifier);
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

@interface DKSubgroupChoiceModifierGroup()
@end

@implementation DKSubgroupChoiceModifierGroup

@synthesize chosenGroup = _chosenGroup;

- (void)chooseModifierGroup:(DKModifierGroup*)chosenModifierGroup {
    [self choose:chosenModifierGroup];
}

#pragma DKChoiceModifierGroup override
- (id<NSObject>)choice {
    return _chosenGroup;
}

- (NSArray*)choices {
    return [self.subgroups array];
}

- (void)choose:(id)choice {
    
    if (choice && ![choice isKindOfClass:[DKModifierGroup class]]) {
        NSLog(@"DKMultipleChoiceModifierGroup: Attempted to choose an object: %@ that is not of type DKModifierGroup.", choice);
        return;
    }
    
    DKModifierGroup* chosenModifierGroup = (DKModifierGroup*)choice;
    if (chosenModifierGroup && ![self.subgroups containsObject:chosenModifierGroup]) {
        NSLog(@"DKMultipleChoiceModifierGroup: Attempted to choose a modifier group (%@) that is not a subgroup of the modifier group: %@.", chosenModifierGroup, self);
        return;
    }
    
    [_chosenGroup setActive:NO];
    _chosenGroup = chosenModifierGroup;
    [_chosenGroup setActive:YES];
}

#pragma DKModifierGroup override
- (void)addSubgroup:(DKModifierGroup*)subgroup {
    
    subgroup.active = NO;
    [super addSubgroup:subgroup];
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
