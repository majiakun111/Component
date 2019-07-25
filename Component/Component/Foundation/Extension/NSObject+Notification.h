//
//  NSObject+Notification.h
//  Component
//
//  Created by Ansel on 15/11/3.
//  Copyright © 2015年 PAIC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^NotificationCallBack)(NSNotification *notification);

@interface NSNotification (Notification)

- (BOOL)is:(nullable NSString *)name;
- (BOOL)isKindOf:(nullable NSString *)prefix;

@end

#pragma mark -

@interface NSObject (Notification)

- (void)observeNotification:(nonnull NSString *)name notificationCallBack:(nullable NotificationCallBack)notificationCallBack;

- (void)unobserveNotification:(nonnull NSString *)name;
- (void)unobserveAllNotifications;

- (void)postNotificationName:(nonnull NSString *)name;
+ (void)postNotificationName:(nonnull NSString *)name;

- (void)postNotificationName:(nonnull NSString *)name object:(nullable id)object;
+ (void)postNotificationName:(nonnull NSString *)name object:(nullable id)object;

- (void)postNotificationName:(nonnull NSString *)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo;
+ (void)postNotificationName:(nonnull NSString *)name object:(nullable id)object userInfo:(nullable NSDictionary *)userInfo;

@end

NS_ASSUME_NONNULL_END
