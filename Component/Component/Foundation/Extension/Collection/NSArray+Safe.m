//
//  NSArray+Safe.m
//  Component
//
//  Created by Ansel on 16/3/1.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "NSArray+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import "SwizzleCollectionMethod.h"

@implementation NSArray (Safe)

+ (void)load
{
#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayI = NSClassFromString(@"__NSArrayI");
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:) forClass:arrayI];
        [self swizzleMethod:@selector(arrayByAddingObject:) withMethod:@selector(safe_arrayByAddingObject:)];
        [self swizzleMethod:@selector(indexOfObject:inRange:) withMethod:@selector(safe_indexOfObject:inRange:)];
    });
#endif
}

- (id)safe_objectAtIndex:(NSInteger)index
{
    if (index >= [self count]) {
        NSLog(@"index greater count");
        return nil;
    }
    
    return [self safe_objectAtIndex:index];
}

- (NSArray *)safe_arrayByAddingObject:(id)object
{
    if (nil == object) {
        NSLog(@"object is nil");
        return self;
    }
    
    return [self safe_arrayByAddingObject:object];
}

- (NSUInteger)safe_indexOfObject:(id)object inRange:(NSRange)range
{
    if (range.location + range.length > [self count]) {
        return arc4random() + self.count;
    }
    
    return [self safe_indexOfObject:object inRange:range];
}

@end
