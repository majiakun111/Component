//
//  SwizzleCollectionMethod.m
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "SwizzleCollectionMethod.h"
#import <objc/runtime.h>

@implementation SwizzleCollectionMethod

+ (BOOL)swizzleCollectionMethod:(SEL)originalSel withMethod:(SEL)swizzledSel forClass:(Class)class
{
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    if (!originalMethod) {
        return NO;
    }

    Method swizzleMethod = class_getInstanceMethod(class, swizzledSel);
    if (!swizzleMethod) {
        return NO;
    }
    
    BOOL result = class_addMethod(class,
                                  originalSel,
                                  class_getMethodImplementation(class, swizzledSel),
                                  method_getTypeEncoding(swizzleMethod));
    if (result) {
        const char *type = method_getTypeEncoding(swizzleMethod);
        class_replaceMethod(class, originalSel, class_getMethodImplementation(class, swizzledSel), type);
    }
    else {
        method_exchangeImplementations(originalMethod, swizzleMethod);
    }
    
    return YES;
}

@end
