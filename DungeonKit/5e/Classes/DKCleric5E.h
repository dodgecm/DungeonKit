//
//  DKCleric5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 4/27/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKStatistic.h"
#import "DKChoiceModifierGroup.h"
#import "DKClass5E.h"

@class DKAbilities5E;

@interface DKCleric5E : DKClass5E

@property (nonatomic, strong) DKNumericStatistic* channelDivinityUsesCurrent;
@property (nonatomic, strong) DKNumericStatistic* channelDivinityUsesMax;
@property (nonatomic, strong) DKNumericStatistic* turnUndead;
@property (nonatomic, strong) DKNumericStatistic* divineIntervention;
@property (nonatomic, strong) DKModifierGroup* divineDomain;

- (id)init __unavailable;
- (id)initWithAbilities:(DKAbilities5E*)abilities;

@end

@interface DKClericSpellBuilder5E : NSObject
+ (DKChoiceModifierGroup*)cantripChoiceWithLevel:(DKNumericStatistic*)level
                                       threshold:(NSInteger)threshold
                                     explanation:(NSString*)explanation;
+ (DKModifierGroup*)spellListForSpellLevel:(NSInteger)spellLevel
                               clericLevel:(DKNumericStatistic*)level;

@end
