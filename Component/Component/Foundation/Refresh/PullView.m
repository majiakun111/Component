//
//  PullView.m
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "PullView.h"
#import "UIView+Coordinate.h"
#import "CALayer+Aniamtion.h"

#define CONTENT_SIZE   @"contentSize"
#define CONTENT_OFFSET @"contentOffset"
#define PAN_STATE      @"state"

@interface PullView ()

@property (nonatomic, strong) NSString *arrowImagName;

@end

@implementation PullView

- (void)dealloc
{
    [self removeObserverKeyPaths];
}

- (id)initWithFrame:(CGRect)frame arrowImage:(NSString *)arrowImagName
{
    if ((self = [super initWithFrame:frame])) {
        self.arrowImagName = arrowImagName;
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    [self addSubview:self.statusLabel];
    [self.layer addSublayer:self.arrowImageLayer];
    [self addSubview:self.loadingImageView];
}

- (void)willMoveToSuperview:(nullable UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!newSuperview || ![newSuperview isKindOfClass:[UIScrollView class]]) {
        return;
    }
    
    [self removeObserverKeyPaths];

    self.scrollView = (UIScrollView *)newSuperview;
    //永远支持垂直滑动
    [self.scrollView setAlwaysBounceVertical:YES];
    
    [self addObserverKeyPaths];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{

}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{

}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    
}

#pragma mark - property

- (UILabel *)statusLabel
{
    if (nil == _statusLabel) {
        UIFont *stateLabelFont = [UIFont systemFontOfSize:14];
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.width - REAL_WIDTH) / 2 + 30, (CONTENT_HEIGHT - 14)/2, 200, 14)];
        _statusLabel.font = stateLabelFont;
        _statusLabel.textColor = [UIColor redColor];
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:_statusLabel];
    }
    
    return _statusLabel;
}

-(CALayer *)arrowImageLayer
{
    if (nil == _arrowImageLayer) {
        UIImage *arrow = [UIImage imageNamed:self.arrowImagName];
        _arrowImageLayer = [CALayer layer];
        _arrowImageLayer.frame = CGRectMake((self.width - REAL_WIDTH) / 2, (CONTENT_HEIGHT - arrow.size.height)/2, arrow.size.width, arrow.size.height);
        _arrowImageLayer.contentsGravity = kCAGravityResizeAspect;
        _arrowImageLayer.contents = (id)[UIImage imageWithCGImage:arrow.CGImage scale:1 orientation:UIImageOrientationDown].CGImage;
        [self.layer addSublayer:_arrowImageLayer];
        _arrowImageLayer.transform = CATransform3DIdentity;
    }
    
    return _arrowImageLayer;
}

- (UIImageView *)loadingImageView
{
    if (nil == _loadingImageView) {
        UIImage *loadingImage = [UIImage imageNamed:@"loading"];
        _loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.width - REAL_WIDTH) / 2, (CONTENT_HEIGHT - loadingImage.size.height)/2, loadingImage.size.width, loadingImage.size.height)];
        [_loadingImageView setImage:loadingImage];
        [self addSubview:_loadingImageView];
        [_loadingImageView setHidden:YES];
    }
    
    return _loadingImageView;
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
            [CATransaction  setCompletionBlock:^{
                
            }];
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

#pragma mark - PrivateMethod  Notification

- (void)addObserverKeyPaths
{
    [self.scrollView addObserver:self forKeyPath:CONTENT_SIZE options:NSKeyValueObservingOptionNew context:NULL];
    [self.scrollView addObserver:self forKeyPath:CONTENT_OFFSET options:NSKeyValueObservingOptionNew context:NULL];
    [self.scrollView.panGestureRecognizer addObserver:self forKeyPath:PAN_STATE options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserverKeyPaths
{
    [self.scrollView removeObserver:self forKeyPath:CONTENT_SIZE context:NULL];
    [self.scrollView removeObserver:self forKeyPath:CONTENT_OFFSET context:NULL];
    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:PAN_STATE context:NULL];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqual:CONTENT_SIZE]) {
        [self scrollViewContentSizeDidChange:change];
    }
    else if ([keyPath isEqual:CONTENT_OFFSET]) {
        [self scrollViewContentOffsetDidChange:change];
    }
    else if ([keyPath isEqual:PAN_STATE]) {
        [self scrollViewPanStateDidChange:change];
    }
}

#pragma mark -  PrivateMethod

- (void)startRotationLoadingImage
{
    [self stopRotationLoadingImage];
    
    [_loadingImageView setHidden:NO];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = ROTATION_ANIMATION_TIME;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = INT32_MAX;
    
    [_loadingImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation" completeBlock:^{
        
    }];
}

- (void)stopRotationLoadingImage
{
    [_loadingImageView.layer stopAniamtion];
    [_loadingImageView setHidden:YES];
}

@end
