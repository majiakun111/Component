//
//  NSArray+Safe.m
//  Component
//
//  Created by Ansel on 16/3/1.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSArray+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@interface NSArray ()

@end

@implementation NSArray (Safe)

+ (void)load
{
//#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayI = NSClassFromString(@"__NSArrayI");
        [arrayI IOrM_swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safe_objectAtIndex:) ];
        [self swizzleMethod:@selector(arrayByAddingObject:) withMethod:@selector(safe_arrayByAddingObject:)];
        [self swizzleMethod:@selector(indexOfObject:inRange:) withMethod:@selector(safe_indexOfObject:inRange:)];
    });
//#endif
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

#pragma mark - PrivateMethod

+ (BOOL)IOrM_swizzleMethod:(SEL)originalSel withMethod:(SEL)swizzledSel
{
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    if (!originalMethod) {
        return NO;
    }
    
    Method swizzleMethod = class_getInstanceMethod(self, swizzledSel);
    if (!swizzleMethod) {
        return NO;
    }
    
    BOOL result = class_addMethod(self,
                                  originalSel,
                                  class_getMethodImplementation(self, swizzledSel),
                                  method_getTypeEncoding(swizzleMethod));
    if (result) {
        const char *type = method_getTypeEncoding(swizzleMethod);
        class_replaceMethod(self, originalSel, class_getMethodImplementation(self, swizzledSel), type);
    }
    else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    
    return YES;
}

@end
