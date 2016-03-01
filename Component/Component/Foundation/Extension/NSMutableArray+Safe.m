//
//  NSMutableArray+Safe_.m
//  Component
//
//  Created by Ansel on 16/3/1.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSMutableArray+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSMutableArray (Safe)

+ (void)load
{
    //#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class arrayM = NSClassFromString(@"__NSArrayM");
        [arrayM arrayI_swizzleMethod:@selector(addObject:) withMethod:@selector(safe_addObject:)];
    });
    //#endif
}

- (void)safe_addObject:(id)object
{
    if (nil == object) {
        NSLog(@"%@ object is nill" , NSStringFromSelector(_cmd));
        return;
    }
    
    return [self safe_addObject:object];
}

#pragma mark - PrivateMethod

+ (BOOL)arrayI_swizzleMethod:(SEL)originalSel withMethod:(SEL)swizzledSel
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
