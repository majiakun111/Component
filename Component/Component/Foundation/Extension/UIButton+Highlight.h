//
//  UIButton+Highlight.h
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Highlight)
/**
 * 只改变了图片的alpha为原来的0.4
 *  UIImage 的scale 如果是0就是screen的scale
 */

- (void)setHighlightImageWithScale:(CGFloat)scale;
- (void)setHighlightSelectedImageWithScale:(CGFloat)scale;

- (void)setHighlightBackgroundImageWithScale:(CGFloat)scale;
- (void)enableHighlightSelectedBackgroundImageWithScale:(CGFloat)scale;

@end
