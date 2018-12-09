//
//  NSObject+ClassName.m
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "NSObject+ClassName.h"
#import <objc/runtime.h>

@implementation NSObject (ClassName)

- (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName(self)];
}

@end
