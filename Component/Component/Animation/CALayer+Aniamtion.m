//
//  CALayer+Aniamtion.m
//  Component
//
//  Created by Ansel on 16/2/26.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "CALayer+Aniamtion.h"
#import "NSObject+Notification.h"
#import <objc/runtime.h>

@interface CALayer ()

@property (nonatomic, copy) CompleteBlock completeBlcok;

@property (nonatomic, strong) CAAnimation *animation;

@property (nonatomic, copy) NSString *key;


@end

@implementation CALayer (Aniamtion)

- (void)addAnimation:(nonnull CAAnimation *)animation
              forKey:(nullable NSString *)key
       completeBlock:(nullable CompleteBlock)completeBlock
{
    self.completeBlcok = completeBlock;
    self.animation = animation;
    self.key = key;
    
    [animation setDelegate:self];
    [self addAnimation:animation forKey:key];
    
    [self addObserver];
}

- (void)doAniamtion
{
    [self removeAnimationForKey:self.key];
    
    [self.animation setDelegate:self];
    [self addAnimation:self.animation forKey:self.key];
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

#pragma mark - Observer

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
