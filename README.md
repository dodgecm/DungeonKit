## DungeonKit

DungeonKit makes it easy to create character sheets for tabletop games.

You define the statistics and their interactions with one another, and DungeonKit handles updating the entire graph's values automatically.  DungeonKit also implements NSCoding so that character sheets can be persisted.

If you're a 5E player, the [DungeonKit5E](https://github.com/dodgecm/DungeonKit5E) module provides an implementation of the entire 5E basic [ruleset](https://dnd.wizards.com/articles/features/basicrules).

### DungeonKit Objects

DungeonKit provides three primary objects as the building blocks of a character sheet: [Statistics](https://github.com/dodgecm/DungeonKit/blob/master/DungeonKit/DKStatistic.h), [Modifiers](https://github.com/dodgecm/DungeonKit/blob/master/DungeonKit/DKModifier.h), and [Statistic Groups](https://github.com/dodgecm/DungeonKit/blob/master/DungeonKit/DKStatisticGroup.h).  

#### Statistics
DKStatistic represents a statistic on the character sheet (ex: intellect, hotness, brawnyness).  Its value can be numeric, a string, a set of strings, or a group of dice.  
```objc
#import <DungeonKit/DungeonKit.h>
DKDiceCollection* oneD6 = [DKDiceCollection diceCollectionWithQuantity:1 sides:6 modifier:0];
DKStatistic* diceStatistic = [DKDiceStatistic statisticWithDice:oneD6];
NSLog(@"%@", diceStatistic.value);
// 1d6
```

You may set an intrinsic value for the statistic, and then apply modifiers to it that change its value.
```objc
DKNumericStatistic* ten = [DKNumericStatistic statisticWithInt:10];
NSLog(@"%@", ten.value);
// 10
DKModifier* plusFive = [DKModifier numericModifierWithAdditiveBonus:5];
[ten applyModifier:plusFive];
NSLog(@"%@", ten.value);
// 15
```

#### Modifiers
Modifiers change the value of a statistic (ex: +2 to intellect).  A modifier can  have a static value, or it can use the value of a second statistic when performing a modification.  
```objc
DKNumericStatistic* two = [DKNumericStatistic statisticWithInt:2];
DKNumericStatistic* fourteen = [DKNumericStatistic statisticWithInt:14];
DKModifier* plusTwo = [DKModifier numericModifierAddedFromSource:two];
[fourteen applyModifier:plusTwo];
NSLog(@"%@", fourteen.value);
// 16
two.base = @6;
NSLog(@"%@", fourteen.value);
// 20
```

#### Statistic Groups
Statistic groups are the top level object (ex: a character sheet) responsible for serializing the statistic and modifier graph.  Statistic groups may also own other statistic groups.
