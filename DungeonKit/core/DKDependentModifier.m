//
//  DKDependantModifier.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKDependentModifier.h"
#import "DKConstants.h"

@interface DKDependentModifier()
@end

@implementation DKDependentModifier

@synthesize source = _source;
@synthesize valueBlock = _valueBlock;

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DKStatObjectChangedNotification object:nil];
    [_source removeObserver:self forKeyPath:@"value"];
}

- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(DKDependentModifierBlockType)valueBlock
            priority:(DKModifierPriority)priority
               block:(DKModifierBlockType)block {
    
    NSAssert(source, @"Source for dependent modifier must not be nil.");
    
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceChanged:) name:DKStatObjectChangedNotification object:_source];
        [_source addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        
    }
    return self;
}

- (void)sourceChanged:(NSNotification*)notif {
    
    NSObject<DKDependentModifierOwner>* newSource = notif.userInfo[@"new"];
    //Catch the case where the new value is null at this entry point to simplify the handling
    if ([newSource isEqual:[NSNull null]]) {
        newSource = nil;
    }
    
    [self setSource:newSource];
}

- (void)setSource:(NSObject<DKDependentModifierOwner>*)source {

    [[NSNotificationCenter defaultCenter] removeObserver:self name:DKStatObjectChangedNotification object:_source];
    [_source removeObserver:self forKeyPath:@"value"];
    _source = source;
    
    if (_source) {
        [_source willBecomeSourceForModifier:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sourceChanged:) name:DKStatObjectChangedNotification object:_source];
        [_source addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
        [self refreshValue];
        
    } else {
        [self removeFromStatistic];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //The value of our source statistic changed, so we need to recalculate our value
    [self refreshValue];
}

- (void)refreshValue {
    
    if (_valueBlock) {
        self.value = _valueBlock([_source value]);
    } else {
        self.value = [_source value];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Dependent modifier with source: %@, value: %i", _source, _source.value];
}

@end

@implementation DKDependentModifierBuilder

+ (id)simpleModifierFromSource:(NSObject<DKDependentModifierOwner>*)source {
    DKDependentModifier* modifier = [[DKDependentModifier alloc] initWithSource:source
                                                                          value:[DKDependentModifierBuilder simpleValueBlock]
                                                                       priority:kDKModifierPriority_Additive
                                                                          block:[DKModifierBuilder simpleAdditionModifierBlock]];
    return modifier;
}

+ (DKDependentModifierBlockType)simpleValueBlock {
    return ^int(int valueToModify) {
        return valueToModify;
    };
}

@end
