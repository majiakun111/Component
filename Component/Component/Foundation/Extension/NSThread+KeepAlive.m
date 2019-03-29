//
//  NSThread+KeepAlive.m
//  Component
//
//  Created by Ansel on 2019/3/29.
//  Copyright © 2019 MJK. All rights reserved.
//

#import "NSThread+KeepAlive.h"
#import <objc/runtime.h>

@implementation NSThread (KeepAlive)

+(NSThread *)keepAliveThread {
    __block NSThread *thread = nil;
    void (^block)(void) = ^{
        @autoreleasepool {
            [[NSRunLoop currentRunLoop] addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
            while (!thread.isStop) {
                //每隔10s检测线程是否stop
                [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:10]];
            }
        }
    };
    
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(run:) object:block];
    thread.isStop = NO;
    return thread;
}

- (BOOL)isStop {
    return [objc_getAssociatedObject(self, @selector(isStop)) boolValue];
}

- (void)setIsStop:(BOOL)isStop {
    objc_setAssociatedObject(self, @selector(isStop), @(isStop), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - PrivateMethod
//线程启动
+ (void)run:(void (^)(void))block {
    if (block) {
        block();
    }
}

@end
