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
@property (nonatomic, strong) NSMutableDictionary* keyPaths;
@property (nonatomic, strong) NSMutableDictionary* statistics;
@end

@implementation DKCharacter

@synthesize keyPaths = _keyPaths;
@synthesize statistics = _statistics;

+ (NSDictionary*) buildKeyPaths {
    return @{};
}


- (NSArray*) allKeyPaths {
    
    return [_keyPaths allValues];
}

- (void)dealloc {

    for (id object in [_statistics allValues]) {
        if ([object isKindOfClass:[NSString class]]) {
            NSString* keyPath = (NSString*)object;
            [self removeObserver:self forKeyPath:keyPath];
        }
    }
}

- (id)init {
    self = [super init];
    if (self) {
        
        _statistics = [NSMutableDictionary dictionary];
        _keyPaths = [NSMutableDictionary dictionary];
    }
    return self;
}

- (DKStatistic*)statisticForID:(NSString*)statID {
    if (!statID) { return nil; }
    id statOrKeyPath = [_statistics objectForKey:statID];
    if ([statOrKeyPath isKindOfClass:[NSString class]]) {
        NSString* keyPath = (NSString*)statOrKeyPath;
        return [self valueForKeyPath:keyPath];
    }
    else if ([statOrKeyPath isKindOfClass:[DKStatistic class]]) {
        return statOrKeyPath;
    } else {
        return nil;
    }
}

- (void)addKeyPath:(NSString*)keyPath forStatisticID:(NSString*)statID {
    
    id oldStat = [self statisticForID:statID];
    if (!oldStat) { oldStat = [NSNull null]; }
    [self removeStatisticWithID:statID];
    
    [_statistics setObject:keyPath forKey:statID];
    [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew context:nil];
    id newStat = [self statisticForID:statID];
    if (!newStat) { newStat = [NSNull null]; }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                        object:oldStat
                                                      userInfo:@{@"old": oldStat,
                                                                 @"new": newStat}];
}

- (void)setStatistic:(DKStatistic*)statistic forStatisticID:(NSString*)statID {
    
    id oldStat = [self statisticForID:statID];
    if (!oldStat) { oldStat = [NSNull null]; }
    [self removeStatisticWithID:statID];
    
    [_statistics setObject:statistic forKey:statID];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                        object:oldStat
                                                      userInfo:@{@"old": oldStat,
                                                                 @"new": statistic}];
}

- (void)removeStatisticWithID:(NSString*)statID {
    
    if (!statID) { return; }
    id statisticToRemove = [_statistics objectForKey:statID];
    if (!statisticToRemove) { return; }
    
    if ([statisticToRemove isKindOfClass:[NSString class]]) {
        //If the object is a string, then this statistic is registered through its key path
        NSString* keyPath = (NSString*)statisticToRemove;
        [self removeObserver:self forKeyPath:keyPath];
        
    } else if ([statisticToRemove isKindOfClass:[DKStatistic class]]) {
        //Otherwise, it was just registered directly
    }
    [_statistics removeObjectForKey:statID];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    DKStatistic* oldStat = change[@"old"];
    //Send out a notification so all the DKDependantModifiers can update their parent objects
    [[NSNotificationCenter defaultCenter] postNotificationName:DKStatObjectChangedNotification
                                                        object:oldStat
                                                      userInfo:change];
}

@end
