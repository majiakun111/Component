//
//  UIButton+Highlight.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import "UIButton+Highlight.h"

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
    UIImage *highlightImage = [self alphaChangeImageForImage:image scale:scale];
    [self setImage:highlightImage forState:state | UIControlStateHighlighted];
}

- (void)setHighlightBackgroundImageWithScale:(CGFloat)scale forState:(UIControlState)state
{
    scale = (0 == scale) ? [UIScreen mainScreen].scale : scale;
    UIImage *backgroundImage = [self backgroundImageForState:state];
    CGFloat edge = floor((MIN(backgroundImage.size.width, backgroundImage.size.height) - 1.0) / 2.0);
    UIImage *highlightImage = [[self alphaChangeImageForImage:backgroundImage scale:scale] resizableImageWithCapInsets:UIEdgeInsetsMake(edge, edge, edge, edge)];
    [self setBackgroundImage:highlightImage forState:state | UIControlStateHighlighted];
}

- (UIImage *)alphaChangeImageForImage:(UIImage *)image scale:(CGFloat)scale {
    if (!image) {
         NSParameterAssert(NO);
    }
    
    CIImage *ciimage = [[CIImage alloc] initWithCGImage:image.CGImage];
    CGFloat rgba[4] = {0.0, 0.0, 0.0, 0.4};
    CIFilter *colorMatrix = [CIFilter filterWithName:@"CIColorMatrix"];
    [colorMatrix setDefaults];
    [colorMatrix setValue:ciimage forKey: kCIInputImageKey];
    [colorMatrix setValue:[CIVector vectorWithValues:rgba count:4] forKey:@"inputAVector"];
    CIImage *outputImage = [colorMatrix outputImage];
    UIImage *alphaChangeImage = [UIImage imageWithCIImage:outputImage scale:scale orientation:UIImageOrientationUp];
    
    return alphaChangeImage;
}

@end
