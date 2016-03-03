//
//  UIView+Coordinate.h
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIView (Coordinate)

- (CGFloat)top;
- (void)setTop:(CGFloat)top;

- (CGFloat)left;
- (void)setLeft:(CGFloat)left;

- (CGFloat)bottom;

- (CGFloat)right;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGSize)size;
- (void)setSize:(CGSize)size;

- (CGPoint)origin;
- (void)setOrigin:(CGPoint)origin;

- (CGFloat)centerX;
- (void)setCenterX:(CGFloat)centerX;

- (CGFloat)centerY;
- (void)setCenterY:(CGFloat)centerY;

@end
