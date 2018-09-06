//
//  UIImage+Color.h
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Color)

+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color corners:(UIRectCorner)corners cornerRadius:(CGFloat)radius;

+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (instancetype)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;
@end
