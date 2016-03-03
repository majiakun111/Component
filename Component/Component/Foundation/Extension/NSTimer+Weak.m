//
//  NSTimer+Weak.m
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSTimer+Weak.h"

@implementation NSTimer (Weak)

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     block:(void(^)(NSTimer *timer))block
                                   repeats:(BOOL)repeats
{
    NSTimer *timer = [self scheduledTimerWithTimeInterval:interval target:self selector:@selector(invoke:) userInfo:block repeats:repeats];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes]; //保证进入后台和滚动时都可以运行
    
    return timer;
}

+ (void)invoke:(NSTimer*)timer
{
    void(^block)(NSTimer *timer) = timer.userInfo;
    
    if(block) {
        __block NSTimer *weakTimer = timer;
        block(weakTimer);
    }
}

@end
