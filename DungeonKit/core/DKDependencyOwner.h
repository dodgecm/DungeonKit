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
/** A method that enables or disables the modifier from the value of the source. */
@property (nonatomic, copy) NSPredicate* enabledPredicate;
/** A flag for whether the owner is currently enabled; equal to (enabledPredicate && active) */
@property (nonatomic, readonly) BOOL enabled;
/** An override flag for whether this owner is enabled, independent of enabledPredicate  */
@property (nonatomic, assign) BOOL active;

- (void)addDependency:(NSObject<DKDependency>*)dependency forKey:(NSString*)key;
- (void)removeDependencyforKey:(NSString*)key;
- (void)refresh;

@end
