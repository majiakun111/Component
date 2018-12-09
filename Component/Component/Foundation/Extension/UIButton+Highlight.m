//
//  UIButton+Highlight.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 MJK. All rights reserved.
//

#import "UIButton+Highlight.h"
#import "UIImage+Alpha.h"

@implementation UIButton (Highlight)

- (void)setHighlightImageWithScale:(CGFloat)scale {
    [self setHighlightImageWithScale:scale forState:UIControlStateNormal];
}

- (void)setHighlightSelectedImageWithScale:(CGFloat)scale {
    [self setHighlightImageWithScale:scale forState:UIControlStateSelected];
}

- (void)setHighlightBackgroundImageWithScale:(CGFloat)scale {
    [self setHighlightBackgroundImageWithScale:scale forState:UIControlStateNormal];
}

- (void)enableHighlightSelectedBackgroundImageWithScale:(CGFloat)scale {
    [self setHighlightBackgroundImageWithScale:scale forState:UIControlStateSelected];
}

#pragma mark - PrivateMethod

- (void)setHighlightImageWithScale:(CGFloat)scale forState:(UIControlState)state
{
    scale = scale == 0 ? [UIScreen mainScreen].scale : scale;
    UIImage *image = [self imageForState:state];
    UIImage *highlightImage = [image alphaChangeImageWithScale:scale];
    [self setImage:highlightImage forState:state | UIControlStateHighlighted];
}

- (void)setHighlightBackgroundImageWithScale:(CGFloat)scale forState:(UIControlState)state
{
    scale = (0 == scale) ? [UIScreen mainScreen].scale : scale;
    UIImage *backgroundImage = [self backgroundImageForState:state];
    CGFloat edge = floor((MIN(backgroundImage.size.width, backgroundImage.size.height) - 1.0) / 2.0);
    UIImage *highlightImage = [[backgroundImage alphaChangeImageWithScale:scale] resizableImageWithCapInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    [self setBackgroundImage:highlightImage forState:state | UIControlStateHighlighted];
}

@end
