//
//  NSObject+MethodSafe.m
//  Component
//
//  Created by Ansel on 16/2/27.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSObject+MethodSafe.h"
#import "NSObject+SwizzleMethod.h"
#import <objc/runtime.h>

@interface ExceptionCatch : NSObject

- (BOOL)addMethod:(SEL)sel;

@end

@implementation ExceptionCatch

int smartFunction(id sel,SEL fun,...)
{
    return 0;
}

- (BOOL)addMethod:(SEL)sel
{
    NSString* selName = NSStringFromSelector(sel);
    NSMutableString* tmpString = [[NSMutableString alloc] initWithFormat:@"%@",selName];
    NSInteger count = [tmpString replaceOccurrencesOfString:@":"
                                                 withString:@"_" options:NSCaseInsensitiveSearch
                                                      range:NSMakeRange(0,selName.length)];
    NSMutableString* val = [[NSMutableString alloc] initWithString:@"i@:"];
    for (NSInteger i = 0; i < count; i++) {
        [val appendString:@"@"];
    }
    
    const char *varChar =  [val UTF8String];
    
    return class_addMethod([ExceptionCatch class], sel, (IMP)smartFunction, varChar);
}

@end

@implementation NSObject (MethodSafe)

+ (void)load
{
#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleMethod:@selector(forwardingTargetForSelector:) withMethod:@selector(safeForwardingTargetForSelector:)];
    });
#endif
}

- (id)safeForwardingTargetForSelector:(SEL)sel
{
    BOOL result = [self respondsToSelector:sel];
    NSMethodSignature *signatrue = [self methodSignatureForSelector:sel];
    if (result || signatrue) {
        return [self safeForwardingTargetForSelector:sel];
    } else {
        ExceptionCatch *exceptionCatch = [[ExceptionCatch alloc] init];
        [exceptionCatch addMethod:sel];
        
        return exceptionCatch;
    }

}

@end
