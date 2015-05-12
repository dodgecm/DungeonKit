//
//  DKDependantModifier.h
//  DungeonKit
//
//  Created by Christopher Dodge on 12/31/14.
//  Copyright (c) 2014 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DKModifier.h"

@class DKDependentModifier;
@protocol DKDependentModifierOwner <DKModifierOwner>
@required
- (void)willBecomeSourceForModifier:(DKDependentModifier*)modifier;
@end

/** The DKDependentModifier class represents a modifier whose value is dependent on another statistic.  For example, the
 initiative statistic is modified by the character's dexterity score, most skills are modified by the proficiency bonus, etc.
 
 For most use cases, it's best to generate DKDependantModifier objects from the owner DKStatistic class directly, or from DKModifierBuilder.
 */
@interface DKDependentModifier : DKModifier <NSCoding>

- (id)initWithValue:(id<NSObject>)value
           priority:(DKModifierPriority)priority
         expression:(NSExpression*)expression __unavailable;

/** @param source The object that this modifier's value will be calculated from.  Assigned the dependency key of "source" by default.
 @param valueExpression An expression that calculates the value of the modifier from the value of the source.  If nil, the modifier will have a value of 0.
 @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
 @param expression An expression that applies the modifier's value to the owner statistic. */
- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(NSExpression*)valueExpression
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression;

/** @param source The object that this modifier's value will be calculated from.  Assigned the dependency key of "source" by default.
 @param valueExpression An expression that calculates the value of the modifier from the value of the source.  If nil, the modifier will have a value of 0.
 @param enabledPredicate A predicate that evaluates based on its dependencies whether this modifier should apply its value to its owner statistic.
 @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
 @param expression An expression that applies the modifier's value to the owner statistic. */
- (id)initWithSource:(NSObject<DKDependentModifierOwner>*)source
               value:(NSExpression*)valueExpression
             enabled:(NSPredicate*)enabledPredicate
            priority:(DKModifierPriority)priority
          expression:(NSExpression*)expression;

/** @param dependencies A dictionary of strings mapped to DKDependentModifierOwner objects.  The value of each statistic this modifier depends on can be referenced by its key string inside the value expression and the enabled expression.
 @param valueExpression An expression that calculates the value of the modifier from the value of the source.  If nil, the modifier will have a value of 0.
 @param enabledPredicate A predicate that evaluates based on its dependencies whether this modifier should apply its value to its owner statistic.
 @param priority Describes when this modifier should be applied relative to other modifiers applied to the same statistic.
 @param expression An expression that applies the modifier's value to the owner statistic. */
- (id)initWithDependencies:(NSDictionary*)dependencies
                     value:(NSExpression*)valueExpression
                   enabled:(NSPredicate*)enabledPredicate
                  priority:(DKModifierPriority)priority
                expression:(NSExpression*)expression;

/** A dictionary of strings to DKDependentModifierOwner objects that this modifier can pull values from */
@property (nonatomic, strong, readonly) NSDictionary* dependencies;
/** A method that calculates the value of the modifier from the value of the source. */
@property (nonatomic, copy, readonly) NSExpression* valueExpression;
/** A method that enables or disables the modifier from the value of the source. */
@property (nonatomic, copy, readonly) NSPredicate* enabledPredicate;

- (void)addDependency:(NSObject<DKDependentModifierOwner>*)dependency forKey:(NSString*)key;
- (void)removeDependencyforKey:(NSString*)key;

@end