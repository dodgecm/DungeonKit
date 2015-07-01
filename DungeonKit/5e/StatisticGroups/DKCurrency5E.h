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

@property (nonatomic, strong) DKNumericStatistic* copper;
@property (nonatomic, strong) DKNumericStatistic* silver;
@property (nonatomic, strong) DKNumericStatistic* electrum;
@property (nonatomic, strong) DKNumericStatistic* gold;
@property (nonatomic, strong) DKNumericStatistic* platinum;

@end
