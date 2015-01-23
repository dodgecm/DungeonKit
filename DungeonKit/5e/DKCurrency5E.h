//
//  DKCurrency5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"

@interface DKCurrency5E : NSObject

@property (nonatomic, strong) DKStatistic* copper;
@property (nonatomic, strong) DKStatistic* silver;
@property (nonatomic, strong) DKStatistic* electrum;
@property (nonatomic, strong) DKStatistic* gold;
@property (nonatomic, strong) DKStatistic* platinum;

@end
