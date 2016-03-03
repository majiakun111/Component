//
//  PullView.m
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "PullView.h"
#import "UIView+Coordinate.h"

@implementation PullView

- (id)initWithFrame:(CGRect)frame arrowImage:(NSString *)arrowImagName
{
    if ((self = [super initWithFrame:frame])) {
        
        CGFloat imageX = (self.width - REAL_WIDTH) / 2;
        
        UIFont *stateLabelFont = [UIFont systemFontOfSize:14];
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageX + 30, (CONTENT_HEIGHT - 14)/2, 200, 14)];
        _statusLabel.font = stateLabelFont;
        _statusLabel.textColor = [UIColor redColor];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _statusLabel.text = @"下拉刷新";
        [self addSubview:_statusLabel];
        
        UIImage *arrow = [UIImage imageNamed:arrowImagName];
        _arrowImageLayer = [CALayer layer];
        _arrowImageLayer.frame = CGRectMake(imageX, (CONTENT_HEIGHT - arrow.size.height)/2, arrow.size.width, arrow.size.height);
        _arrowImageLayer.contentsGravity = kCAGravityResizeAspect;
        _arrowImageLayer.contents = (id)[UIImage imageWithCGImage:arrow.CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
        [self.layer addSublayer:_arrowImageLayer];
        _arrowImageLayer.transform = CATransform3DIdentity;
        
        UIImage *loadingImage = [UIImage imageNamed:@"loading"];
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageX, (CONTENT_HEIGHT - loadingImage.size.height)/2, loadingImage.size.width, loadingImage.size.height)];
        [_loadingImageView setImage:loadingImage];
        [self addSubview:_loadingImageView];
        [_loadingImageView setHidden:YES];
    }
    
    return self;
}

- (void)setState:(EGOPullState)state
{
    switch (state) {
        case EGOPullRefreshNormal:
        case EGOPullLoadMorehNormal: {
            if (_state == EGOPullRefreshPulling || _state == EGOPullLoadMorePulling) {
                [CATransaction begin];
                [CATransaction setAnimationDuration:ANIMATION_TIME];
                _arrowImageLayer.transform = CATransform3DIdentity;
                [CATransaction commit];
            }
            
            _statusLabel.text = self.normalStatusText;
            [self stopRotationLoadingImage];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImageLayer.hidden = NO;
            _arrowImageLayer.transform = CATransform3DIdentity;
            [CATransaction commit];
            
            break;
        }
        case EGOPullRefreshPulling:
        case EGOPullLoadMorePulling: {
            _statusLabel.text = self.pullingStatusText;
            [CATransaction begin];
            [CATransaction setAnimationDuration:ANIMATION_TIME];
            _arrowImageLayer.transform = CATransform3DMakeRotation((M_PI / 180.0) * 180.0f, 0.0f, 0.0f, 1.0f);
            [CATransaction commit];
            
            break;
        }
        case EGOPullRefreshRefreshing:
        case EGOPullLoadMoreLoading: {
            _statusLabel.text = self.loadingStatusText;
            [self startRotationLoadingImage];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            _arrowImageLayer.hidden = YES;
            [CATransaction commit];
            
            break;
        }
        default:
            break;
    }
    
    _state = state;
}

#pragma mark -  PrivateMethod

- (void)startRotationLoadingImage
{
    [self stopRotationLoadingImage];
    
    [_loadingImageView setHidden:NO];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 0.8;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    
    [_loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)stopRotationLoadingImage
{
    [_loadingImageView.layer removeAnimationForKey:@"rotationAnimation"];
    [_loadingImageView setHidden:YES];
}

@end
