//
//  NSObject+Notification.m
//  Component
//
//  Created by Ansel on 15/11/3.
//  Copyright © 2015年 PAIC. All rights reserved.
//

#import "NSObject+Notification.h"
#import <objc/runtime.h>

#pragma mark -

@implementation NSNotification (Notification)

- (BOOL)is:(NSString *)name
{
    return [self.name isEqualToString:name];
}

- (BOOL)isKindOf:(NSString *)prefix
{
    return [self.name hasPrefix:prefix];
}

@end

#pragma mark -

#define KEY [NSString stringWithFormat:@"%p", self]

static NSMutableDictionary *g_callbackDictioanry;

@implementation NSObject (Notification)

- (void)observeNotification:(NSString *)name notificationCallBack:(NotificationCallBack)notificationCallBack;
{
    if (nil == g_callbackDictioanry) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            if (nil == g_callbackDictioanry) {
                g_callbackDictioanry = [[NSMutableDictionary alloc] init];
            }
        });
    }
    
    NSMutableDictionary *selfCallbackDictioanry = [g_callbackDictioanry objectForKey:KEY];
    if (!selfCallbackDictioanry) {
        selfCallbackDictioanry = [NSMutableDictionary  dictionary];
        [g_callbackDictioanry setObject:selfCallbackDictioanry forKey:KEY];
    }
    [selfCallbackDictioanry setObject:notificationCallBack forKey:name];

    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                name:name
                                              object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(handleNotification:)
                                                 name:name
                                               object:nil];
}

- (void)unobserveNotification:(NSString *)name
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:name
                                                  object:nil];
    
    NSMutableDictionary *selfCallbackDictioanry = [g_callbackDictioanry objectForKey:KEY];
    [selfCallbackDictioanry removeObjectForKey:name];
}

- (void)unobserveAllNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    NSMutableDictionary *selfCallbackDictioanry = [g_callbackDictioanry objectForKey:KEY];
    [selfCallbackDictioanry removeAllObjects];
}

- (void)postNotificationName:(NSString *)name
{
    [[self class] postNotificationName:name];
}

+ (void)postNotificationName:(NSString *)name
{
    [self postNotificationName:name object:nil];
}

- (void)postNotificationName:(NSString *)name object:(nullable id)object
{
    [[self class] postNotificationName:name object:object];
}

+ (void)postNotificationName:(NSString *)name object:(nullable id)object
{
    [self postNotificationName:name object:object userInfo:nil];
}

- (void)postNotificationName:(NSString *)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo
{
    [[self class] postNotificationName:name object:object userInfo:userInfo];
}

+ (void)postNotificationName:(NSString *)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo
{
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:userInfo];
}

#pragma mark - property


- (NSMutableDictionary *)callbackDictioanry
{
    NSMutableDictionary *dic =  [(NSMutableDictionary *)objc_getAssociatedObject(self, @selector(callbackDictioanry)) mutableCopy];
    if (!dic) {
        dic = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(callbackDictioanry), dic, OBJC_ASSOCIATION_COPY);
    }
    
    return dic;
}

#pragma mark - PrivateMethod

- (void)handleNotification:(NSNotification *)notification
{
    NSMutableDictionary *selfCallbackDictioanry = [g_callbackDictioanry objectForKey:KEY];
    NotificationCallBack callback =  selfCallbackDictioanry[notification.name];
    if (callback) {
        callback(notification);
    }
}

@end