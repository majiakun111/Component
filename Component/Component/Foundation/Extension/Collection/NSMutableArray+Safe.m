//
//  NSMutableArray+Safe_.m
//  Component
//
//  Created by Ansel on 16/3/1.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import "SwizzleCollectionMethod.h"

@implementation NSMutableArray (Safe)

+ (void)load
{
#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayM = [[NSMutableArray array] class];// NSClassFromString(@"__NSArrayM");
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(addObject:) withMethod:@selector(safe_addObject:) forClass:arrayM];
        
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(insertObject:atIndex:) withMethod:@selector(safe_insertObject:atIndex:) forClass:arrayM];
        
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safe_removeObjectAtIndex:) forClass:arrayM];
        
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(safe_replaceObjectAtIndex:withObject:) forClass:arrayM];
        
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(exchangeObjectAtIndex:withObjectAtIndex:) withMethod:@selector(safe_exchangeObjectAtIndex:withObjectAtIndex:) forClass:arrayM];
        
        [self swizzleMethod:@selector(removeObject:inRange:) withMethod:@selector(safe_removeObject:inRange:)];
        
        [self swizzleMethod:@selector(removeObjectsInRange:) withMethod:@selector(safe_removeObjectsInRange:)];
        
        [self swizzleMethod:@selector(replaceObjectsInRange:withObjectsFromArray:) withMethod:@selector(safe_replaceObjectsInRange:withObjectsFromArray:)];
        
        [self swizzleMethod:@selector(replaceObjectsInRange:withObjectsFromArray: range:) withMethod:@selector(safe_replaceObjectsInRange:withObjectsFromArray:otherRange:)];
    });
#endif
}

- (void)safe_addObject:(id)object
{
    if (nil == object) {
        NSLog(@"%@ object is nill" , NSStringFromSelector(_cmd));
        return;
    }
    
    return [self safe_addObject:object];
}

- (void)safe_insertObject:(id)object atIndex:(NSUInteger)index
{
    if (index > [self count]) {
        NSLog(@"%@ index  greater then count" , NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_insertObject:object atIndex:index];
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index
{
    if (index >= [self count]) {
        NSLog(@"%@ index  greater then count or equal count or less then zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_removeObjectAtIndex:index];
}

- (void)safe_replaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    if (index >= [self count]) {
        NSLog(@"%@ index  greater then count or equal count or less then zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_replaceObjectAtIndex:index withObject:object];
}

- (void)safe_exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2
{
    if (index1 >= [self count]) {
        NSLog(@"%@ index1  greater then count or equal count or less then zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    if (index2 >= [self count]) {
        NSLog(@"%@ index2  greater then count or equal count or less then zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    if (index1 == index2) {
        return;
    }
    
    [self safe_exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

- (void)safe_removeObject:(id)object inRange:(NSRange)range
{
    if (range.location + range.length > [self count] || (NSInteger)range.location < 0 || (NSInteger)range.length < 0) {
        NSLog(@"%@ range.location +  range.length greater then count or range.location less than zero or range.length less than zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_removeObject:object inRange:range];
}

- (void)safe_removeObjectsInRange:(NSRange)range
{
    if (range.location + range.length > [self count] || (NSInteger)range.location < 0 || (NSInteger)range.length < 0) {
        NSLog(@"%@ range.location +  range.length greater then count or range.location less than zero or range.length less than zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_removeObjectsInRange:range];
}

- (void)safe_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray
{
    if (range.location + range.length > [self count] || (NSInteger)range.location < 0 || (NSInteger)range.length < 0) {
        NSLog(@"%@ range.location +  range.length greater then count or range.location less than zero or range.length less than zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_replaceObjectsInRange:range withObjectsFromArray:otherArray];
}


- (void)safe_replaceObjectsInRange:(NSRange)range withObjectsFromArray:(NSArray *)otherArray otherRange:(NSRange)otherRange
{
    if (range.location + range.length > [self count] || (NSInteger)range.location < 0 || (NSInteger)range.length < 0) {
        NSLog(@"%@ range.location +  range.length greater then count or range.location less than zero or    range.length less than zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    if (otherRange.location + otherRange.length > [otherArray count] || (NSInteger)otherRange.location < 0 || (NSInteger)otherRange.length < 0) {
        NSLog(@"%@ otherRange.location +  otherRange.length greater then count or otherRange.location less than zero or otherRange.length less than zero" , NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_replaceObjectsInRange:range withObjectsFromArray:otherArray];
}

@end
