//
//  CALayer+Aniamtion.m
//  Component
//
//  Created by Ansel on 16/2/26.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "CALayer+Aniamtion.h"
#import <objc/runtime.h>
#import "NSObject+Notification.h"
#import "NSObject+SwizzleMethod.h"

@interface CALayer ()

@property (nonatomic, copy) CompleteBlock completeBlcok;

@property (nonatomic, strong) CAAnimation *animation;

@property (nonatomic, copy) NSString *key;


@end

@implementation CALayer (Aniamtion)

+ (void)load
{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [self swizzleMethod:@selector(addAnimation:forKey:) withMethod:@selector(hook_addAnimation:forKey:)];
//    });
}

- (void)addAnimation:(nonnull CAAnimation *)animation
              forKey:(nullable NSString *)key
       completeBlock:(nullable CompleteBlock)completeBlock
{
    self.completeBlcok = completeBlock;

    [self addAnimation:animation forKey:key];
}

- (void)stopAniamtion
{
    [self removeAnimationForKey:self.key];
    
    self.animation = nil;
    self.key = nil;
    self.completeBlcok = nil;
    
    [self removeObserver];
}

#pragma mark - property

- (void)setCompleteBlcok:(CompleteBlock)completeBlcok
{
    objc_setAssociatedObject(self, @selector(completeBlcok), completeBlcok, OBJC_ASSOCIATION_COPY);
}

- (CompleteBlock)completeBlcok
{
    return objc_getAssociatedObject(self, @selector(completeBlcok));
}

- (void)setAnimation:(CAAnimation *)animation
{
    objc_setAssociatedObject(self, @selector(animation), animation, OBJC_ASSOCIATION_RETAIN);
}

- (CAAnimation *)animation
{
    return objc_getAssociatedObject(self, @selector(animation));
}

- (void)setKey:(NSString *)key
{
    objc_setAssociatedObject(self, @selector(key), key, OBJC_ASSOCIATION_COPY);
}

- (NSString *)key
{
    return objc_getAssociatedObject(self, @selector(key));
}

#pragma mark - PrivateMethod

- (void)hook_addAnimation:(CAAnimation *)animation forKey:(NSString *)key
{
    self.animation = animation;
    self.key = key;

    [animation setDelegate:self];
    [self hook_addAnimation:animation forKey:key];
    
    [self addObserver];
}

- (void)addObserver
{
    __weak typeof(self) weakSelf = self;
    
    [self observeNotification:UIApplicationWillEnterForegroundNotification notificationCallBack:^(NSNotification *notification) {
        [weakSelf willEnterForeground:notification];
    }];
}

- (void)removeObserver
{
    [self unobserveAllNotifications];
}

- (void)willEnterForeground:(NSNotification *)natification
{
    [self doAniamtion];
}

- (void)doAniamtion
{
    [self removeAnimationForKey:self.key];
    
    [self.animation setDelegate:self];
    [self addAnimation:self.animation forKey:self.key];
}

#pragma mark - AnimationDelegate

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
    if (flag) {
        if (self.completeBlcok) {
            self.completeBlcok();
            self.completeBlcok = nil;
        }
     
        [self removeObserver];
    }
}

@end
