//
//  DKDependantModifier.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKDependantModifier.h"

@interface DKDependantModifier()
@end

@implementation DKDependantModifier

@synthesize source = _source;
@synthesize valueBlock = _valueBlock;

- (id)initWithSource:(NSObject<DKModifierOwner>*)source
               value:(DKDependantModifierBlockType)valueBlock
            priority:(DKModifierPriority)priority
               block:(DKModifierBlockType)block {
    
    NSAssert(source, @"Source for dependant modifier must not be nil.");
    
    //Set the value block to grab the owner's value directly if an explicit function wasn't provided
    if (!valueBlock) {
        valueBlock = ^int(int valueToModify) {
            return valueToModify;
        };
    }
    int startingValue = valueBlock([source value]);
    
    self = [super initWithValue:startingValue
                       priority:priority
                          block:block];
    if (self) {
        
        _source = source;
        _valueBlock = valueBlock;
        
        [_source addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)setSource:(NSObject<DKModifierOwner>*)source {
    
    [_source removeObserver:self forKeyPath:@"value"];
    _source = source;
    [_source addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //The value of our source statistic changed, so we need to recalculate our value
    if (_valueBlock) {
        self.value = _valueBlock([_source value]);
    } else {
        self.value = [_source value];
    }
}

@end
