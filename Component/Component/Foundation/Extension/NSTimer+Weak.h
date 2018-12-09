//
//  NSTimer+Weak.h
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (Weak)

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                     block:(void(^)(NSTimer *timer))block
                                   repeats:(BOOL)repeats;

@end
