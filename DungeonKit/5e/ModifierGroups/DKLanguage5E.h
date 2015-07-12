//
//  DKLanguage5E.h
//  DungeonKit
//
//  Created by Christopher Dodge on 7/8/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKChoiceModifierGroup.h"

@interface DKLanguageBuilder5E : NSObject

+ (DKChoiceModifierGroup*)languageChoiceWithExplanation:(NSString*)explanation;

@end
