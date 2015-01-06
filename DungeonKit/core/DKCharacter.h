//
//  DKCharacter.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/23/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"

@interface DKCharacter : NSObject {
    
}

- (DKStatistic*)statisticForID:(NSString*)statID;
- (void)addKeyPath:(NSString*)keyPath forStatisticID:(NSString*)statID;
- (void)setStatistic:(DKStatistic*)statistic forStatisticID:(NSString*)statID;
- (void)removeStatisticWithID:(NSString*)statID;

@end
