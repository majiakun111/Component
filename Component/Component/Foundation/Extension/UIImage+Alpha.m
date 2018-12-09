//
//  UIImage+Alpha.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 MJK. All rights reserved.
//

#import "UIImage+Alpha.h"

@implementation UIImage (Alpha)

- (UIImage *)alphaChangeImageWithScale:(CGFloat)scale {
    CIImage *ciimage = [[CIImage alloc] initWithCGImage:self.CGImage];
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
