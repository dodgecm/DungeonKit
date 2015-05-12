//
//  DKDiceCollection.h
//  DungeonKit
//
//  Created by Christopher Dodge on 1/23/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DKDiceCollection : NSObject <NSCopying, NSCoding>

/** A modifier appended on the dice.  For example, the +3 in 2d6+3. */
@property (nonatomic, readonly) NSInteger modifier;

#pragma mark -
/** Convenience constructor for an empty dice collection. */
+ (id)diceCollection;
/** Convenience constructor for a dice collection with a single die type.
    @param quantity The number of dice in this collection.  In 2d6+3, the quantity is 2.
    @param sides The number of sides on the dice in this collection.  In 2d6+3, the sides are 6.
    @param modifier A modifier that gets added to the value of the dice.  In 2d6+3, the modifier is 3. */
+ (id)diceCollectionWithQuantity:(NSInteger)quantity sides:(NSInteger)sides modifier:(NSInteger)modifier;

#pragma mark -
/** Creates an empty dice collection. */
- (id)init;
/** Creates a dice collection with a single die type.
 @param quantity The number of dice in this collection.  In 2d6+3, the quantity is 2.
 @param sides The number of sides on the dice in this collection.  In 2d6+3, the sides are 6.
 @param modifier A modifier that gets added to the value of the dice.  In 2d6+3, the modifier is 3. */
- (id)initWithQuantity:(NSInteger)quantity sides:(NSInteger)sides modifier:(NSInteger)modifier;
/** Creates a single dice collection containing multiple numbers of sides.
 @param sidesToQuantity A dictionary of NSNumbers mapped to NSNumbers representing the sides and quantity of the dice, respectively.  For example, { @20:@1, @6:@2, @2:@5 } would produce 1d20 + 2d6 + 5d2.
 @param modifier A modifier that gets added to the value of the dice.  In 2d6+3, the modifier is 3. */
- (id)initWithDictionary:(NSDictionary*)sidesToQuantity modifier:(NSInteger)modifier;
/** Copy constructor that performs a deep copy on the collection.
 @param collection The collection to be copied. */
- (id)initWithDiceCollection:(DKDiceCollection*)collection;

#pragma mark -
/** Creates a dice collection by adding a single die type to the current collection.
 @param quantity The number of dice to add to this collection.
 @param sides The number of sides on the dice to add to this collection. */
- (id)diceByAddingQuantity:(NSNumber*)quantity sides:(NSNumber*)sides;
/** Creates a dice collection by adding a value to the modifier of the current collection.
 @param modifier The value to add to the current collection's modifier. */
- (id)diceByAddingModifier:(NSNumber*)modifier;
/** Creates a dice collection by the dice and modifier of a collection to current collection.
 @param diceToAdd The collection to add to the current collection. */
- (id)diceByAddingDice:(DKDiceCollection*)diceToAdd;

#pragma mark -
/** Returns an array containing the sides of dice in the collection.  5d10 + 3d6 + 2d4 would return @[10, 6, 4]
 @return An array of NSNumbers. */
- (NSArray*)allSides;
/** Returns number of dice in the collection for the given sides. Passing 10 into the collection 5d10 + 3d6 + 2d4 would return 5. */
- (NSInteger)quantityForSides:(NSInteger)sides;

/** Formats the collection into a string. */
- (NSString*)stringValue;

/** Rolls the dice in the collection. */
- (NSInteger)roll;

@end
