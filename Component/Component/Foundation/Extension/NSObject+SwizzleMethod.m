//
//  NSObject+SwizzleMethod.m
//  Component
//
//  Created by Ansel on 16/2/27.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@implementation NSObject (SwizzleMethod)

- (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)swizzledSel 
{
    return [[self class] swizzleMethod:originalSel withMethod:swizzledSel];
}

+ (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)swizzledSel
{
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    if (!originalMethod) {
        return NO;
    }
    
    Method swizzleMethod = class_getInstanceMethod(self, swizzledSel);
    if (!swizzleMethod) {
        return NO;
    }
    
    class_addMethod(self,
                    originalSel,
                    class_getMethodImplementation(self, originalSel),
                    method_getTypeEncoding(originalMethod));
    class_addMethod(self,
                    swizzledSel,
                    class_getMethodImplementation(self, swizzledSel),
                    method_getTypeEncoding(swizzleMethod));
    
    method_exchangeImplementations(originalMethod, swizzleMethod);
    
    return YES;
}



@end
