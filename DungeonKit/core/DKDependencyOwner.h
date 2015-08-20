//
//  DKDependencyOwner.h
//  DungeonKit
//
//  Created by Christopher Dodge on 8/20/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DKDependencyOwner;
@protocol DKDependency
@required
- (id<NSObject>)value;
- (void)willBecomeSourceForOwner:(DKDependencyOwner*)owner;
@end

FOUNDATION_EXPORT NSString *const DKDependencyChangedNotification;

@interface DKDependencyOwner : NSObject <NSCoding>

/** A dictionary of strings to NSObject<DKDependency> objects that this owner can pull values from */
@property (nonatomic, strong, readonly) NSDictionary* dependencies;

- (void)addDependency:(NSObject<DKDependency>*)dependency forKey:(NSString*)key;
- (void)removeDependencyforKey:(NSString*)key;

@end
