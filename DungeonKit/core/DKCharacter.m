//
//  DKCharacter.m
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import "DKCharacter.h"
#import "DKStatisticIdentifiers.h"
#import "DKConstants.h"


@interface DKCharacter()
@property (nonatomic, strong) NSDictionary* keyPaths;
@end

@implementation DKCharacter

@synthesize keyPaths = _keyPaths;

+ (NSDictionary*) buildKeyPaths {
    return @{};
}


- (NSArray*) allKeyPaths {
    
    return [_keyPaths allValues];
}

- (void)dealloc {
    for (NSString* keyPath in [self allKeyPaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        
        _keyPaths = [[self class] buildKeyPaths];
        
        for (NSString* keyPath in [self allKeyPaths]) {
            [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
        }
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //One of our statistics got replaced, so transfer the modifiers from the old object to the new object
    DKStatistic* oldStat = change[@"old"];
    DKStatistic* newStat = change[@"new"];
    
    //If one of the values is NSNull, skip modifier application
    if (![oldStat isEqual:[NSNull null]] && ![newStat isEqual:[NSNull null]]) {
    
        for (DKModifier* modifier in oldStat.modifiers) {
            [newStat applyModifier:modifier];
        }
    }
        
    //Send out a notification so all the DKDependantModifiers can update their parent objects
    [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                        object:oldStat
                                                      userInfo:change];
}

@end
