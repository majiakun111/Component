//
//  ImagesConvertVideo.h
//  Component
//
//  Created by Ansel on 2018/11/14.
//  Copyright © 2018 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImagesConvertVideo : NSObject

+ (void)videoFromImages:(NSArray<UIImage *> *)images callback:(void(^)(NSString *videoPath))callback;

+ (void)videoFromImages:(NSArray<UIImage *> *)images fps:(NSInteger)fps callback:(void(^)(NSString *videoPath))callback;
                                                    
+ (void)videoFromImages:(NSArray<UIImage *> *)images size:(CGSize)size callback:(void(^)(NSString *videoPath))callback;

+ (void)videoFromImages:(NSArray<UIImage *> *)images fps:(NSInteger)fps size:(CGSize)size callback:(void(^)(NSString *videoPath))callback;

@end

NS_ASSUME_NONNULL_END
