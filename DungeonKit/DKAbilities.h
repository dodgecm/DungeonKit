//
//  DKAbilities.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKAbilityScore : NSObject <NSCopying>

@property (nonatomic, assign) int score;
@property (nonatomic, readonly) int modifier;

+ (id) scoreWithScore: (int) score;
- (id) initWithScore: (int) score;

/** Returns the modifier with the proper prefix, ex: +4, +2, +0, -1 */
- (NSString*) formattedModifier;

@end

@interface DKAbilities : NSObject

@end
