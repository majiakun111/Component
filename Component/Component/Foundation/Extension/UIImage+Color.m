//
//  UIImage+Color.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import "UIImage+Color.h"

@implementation UIImage (Color)

+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color corners:(UIRectCorner)corners cornerRadius:(CGFloat)radius {
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);

    CGRect rect = {.origin = CGPointZero, .size = size};
    UIBezierPath *path;
    if (radius > 0) {
        path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
    } else {
        path = [UIBezierPath bezierPathWithRect:rect];
    }
    
    if (color) {
        [color setFill];
        [path fill];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


+ (instancetype)imageWithSize:(CGSize)size color:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGRect rect = {.origin = CGPointZero, .size = size};
    rect = CGRectInset(rect, borderWidth/2.0, borderWidth/2.0);
    
    UIBezierPath *path;
    if (radius > 0) {
        CGFloat realRadius = radius-borderWidth/2.0;
        if (realRadius < 0) {
            realRadius = 0;
        }
        path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:realRadius];
    }
    else {
        path = [UIBezierPath bezierPathWithRect:rect];
    }
    path.lineWidth = borderWidth;
    
    if (color) {
        [color setFill];
        [path fill];
    }
    
    if (borderColor) {
        [borderColor setStroke];
        [path stroke];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (instancetype)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    CGSize size;
    size.width = radius*2 + 1;
    size.height = size.width;
    
    UIImage *image = [self imageWithSize:size color:color cornerRadius:radius borderWidth:borderWidth borderColor:borderColor];
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(radius, radius, radius, radius)];
}

@end
