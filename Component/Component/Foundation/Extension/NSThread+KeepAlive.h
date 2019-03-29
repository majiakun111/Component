//
//  NSThread+KeepAlive.h
//  Component
//
//  Created by Ansel on 2019/3/29.
//  Copyright © 2019 MJK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//通过下面等方法执行 thread 任务
//- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait modes:(nullable NSArray<NSString *> *)array API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));
//- (void)performSelector:(SEL)aSelector onThread:(NSThread *)thr withObject:(nullable id)arg waitUntilDone:(BOOL)wait API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

@interface NSThread (KeepAlive)

@property(nonatomic, assign) BOOL isStop;

+(NSThread *)keepAliveThread;

@end

NS_ASSUME_NONNULL_END
