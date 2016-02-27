//
//  CALayer+Aniamtion.h
//  Component
//
//  Created by Ansel on 16/2/26.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

typedef void (^AnimationBlock)(void);
typedef void (^CompleteBlock)(void);

@interface CALayer (Aniamtion)

- (void)addAnimation:(nonnull CAAnimation *)animation
              forKey:(nullable NSString *)key
       completeBlock:(nullable CompleteBlock)completeBlock;

- (void)stopAniamtion;

@end
