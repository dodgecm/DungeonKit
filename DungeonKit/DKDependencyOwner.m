//
//  DKDependencyOwner.m
//  DungeonKit
//
//  Created by Christopher Dodge on 8/20/15.
//  Copyright (c) 2015 Dodge. All rights reserved.
//

#import "DKDependencyOwner.h"

NSString *const DKDependencyChangedNotification = @"DKDependencyChangedNotification";

@interface DKDependencyOwner()
@property (nonatomic, assign) BOOL enabled;
@end

@implementation DKDependencyOwner {
    NSMutableDictionary* _dependencies;
}

@synthesize dependencies = _dependencies;
@synthesize enabledPredicate = _enabledPredicate;
@synthesize enabled = _enabled;
@synthesize active = _active;

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DKDependencyChangedNotification object:nil];
    for (NSObject<DKDependency>* dependency in _dependencies.allValues) {
        [dependency removeObserver:self forKeyPath:@"value"];
    }
}

- (id)init {
    self = [super init];
    if (self) {
        _dependencies = [NSMutableDictionary dictionary];
        _enabled = YES;
        _active = YES;
    }
    return self;
}

- (void)setActive:(BOOL)active {
    if (_active != active) {
        _active = active;
        [self refresh];
    }
}

- (void)setEnabledPredicate:(NSPredicate*)enabledPredicate {
    _enabledPredicate = [enabledPredicate copy];
    [self refresh];
}

- (void)addDependency:(NSObject<DKDependency>*)dependency forKey:(NSString*)key {
    
    static NSArray* reservedKeys;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        //These keys are reserved by the NSExpression string parser; see the very bottom of
        //https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/Predicates/Articles/pSyntax.html
        reservedKeys = @[@"AND", @"OR", @"IN", @"NOT", @"ALL", @"ANY", @"SOME", @"NONE", @"LIKE", @"CASEINSENSITIVE", @"CI", @"MATCHES", @"CONTAINS", @"BEGINSWITH", @"ENDSWITH", @"BETWEEN", @"NULL", @"NIL", @"SELF", @"TRUE", @"YES", @"FALSE", @"NO", @"FIRST", @"LAST", @"SIZE", @"ANYKEY", @"SUBQUERY", @"CAST", @"TRUEPREDICATE", @"FALSEPREDICATE", @"UTI-CONFORMS-TO", @"UTI-EQUALS"];
    });
    
    NSAssert([key length], @"Key for dependency must not be empty or nil.");
    NSAssert(dependency, @"Source for dependent modifier must not be nil.");
    NSAssert(![_dependencies allKeysForObject:dependency].count, @"Source must not already be a dependency of this modifier.");
    NSAssert1(![reservedKeys containsObject:[key uppercaseString]], @"Key \"%@\" is one of the NSExpression reserved words.  Name it something else instead.", key);
    
    [self removeDependencyforKey:key];
    
    _dependencies[key] = dependency;
    [dependency willBecomeSourceForOwner:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dependencyChanged:) name:DKDependencyChangedNotification object:dependency];
    [dependency addObserver:self forKeyPath:@"value" options:NSKeyValueObservingOptionNew context:nil];
    
    [self refresh];
}

- (void)removeDependencyforKey:(NSString*)key {
    
    NSAssert([key length], @"Key for dependency must not be empty or nil.");
    DKDependencyOwner* dependency = _dependencies[key];
    
    if (dependency) {
        
        [_dependencies removeObjectForKey:key];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:DKDependencyChangedNotification object:dependency];
        [dependency removeObserver:self forKeyPath:@"value"];
    }
}

- (void)dependencyChanged:(NSNotification*)notif {
    
    NSObject<DKDependency>* oldSource = notif.userInfo[@"old"];
    NSObject<DKDependency>* newSource = notif.userInfo[@"new"];
    
    if ([oldSource isEqual:[NSNull null]] || !oldSource) { }
    else {
        
        NSArray* keys = [_dependencies allKeysForObject:oldSource];
        //Hopefully there should only be one key returned here...
        for (NSString* key in keys) {
            
            if ([newSource isEqual:[NSNull null]] || !newSource) {
                //If we're missing a dependency, we need to clean up this modifier
                for (NSString* dependency in _dependencies.allKeys) {
                    [self removeDependencyforKey:dependency];
                }
            } else {
                [self addDependency:newSource forKey:key];
            }
        }
    }
    
    if (!_dependencies.count) {
        [self remove];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    //The value of our dependency changed, so we need to recalculate our value
    [self refresh];
}

//Gets overridden in subclasses
- (void)refresh {
    NSMutableDictionary* context = [NSMutableDictionary dictionary];
    for (NSString* key in self.dependencies) {
        NSObject<DKDependency>* dependency = self.dependencies[key];
        context[key] = dependency.value;
    }
    
    //Doing it this way allows subclasses to override this method
    self.enabled = [self enabledPredicateResult:context];
}

- (BOOL)enabledPredicateResult:(NSDictionary*)context {
    
    BOOL predicateResult = YES;
    if (self.enabledPredicate != nil) {
        predicateResult = [_enabledPredicate evaluateWithObject:self substitutionVariables:context];
    }
    return (predicateResult && _active);
}

- (void)remove { }

#pragma mark NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.dependencies forKey:@"dependencies"];
    [aCoder encodeBool:self.active forKey:@"active"];
    [aCoder encodeObject:self.enabledPredicate forKey:@"enabledPredicate"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    if (self) {
        
        _dependencies = [NSMutableDictionary dictionary];
        NSDictionary* dependencies = [aDecoder decodeObjectForKey:@"dependencies"];
        for (NSString* key in dependencies) {
            [self addDependency:dependencies[key] forKey:key];
        }
        _active = [aDecoder decodeBoolForKey:@"active"];
        _enabledPredicate = [aDecoder decodeObjectForKey:@"enabledPredicate"];
    }
    
    return self;
}

@end
