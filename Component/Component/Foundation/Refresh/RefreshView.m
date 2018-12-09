//
//  RefreshView.m
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "RefreshView.h"
#import "UIView+Coordinate.h"

@interface RefreshView ()

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, copy)  RefreshingBlock refreshingBlock;

@end

@implementation RefreshView

+ (instancetype)refreshWithFrame:(CGRect)frame refreshingBlock:(RefreshingBlock)refreshingBlock
{
    RefreshView *refreshView = [[self alloc] initWithFrame:frame];
    refreshView.refreshingBlock = refreshingBlock;
    
    return refreshView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame arrowImage:@"PullToRefresh"])) {

        [self.statusLabel setTop:self.statusLabel.top + self.height - CONTENT_HEIGHT];
        [self.arrowImageLayer setFrame:CGRectMake(self.arrowImageLayer.frame.origin.x, self.arrowImageLayer.frame.origin.y + self.height - CONTENT_HEIGHT, self.arrowImageLayer.frame.size.width, self.arrowImageLayer.frame.size.height)];
        [self.loadingImageView setTop:self.loadingImageView.top + self.height - CONTENT_HEIGHT];
        
        self.state = EGOPullRefreshNormal;
        
        [self.statusLabel setText:@"下拉刷新"];
        self.normalStatusText = @"下拉刷新";
        self.pullingStatusText = @"释放更新";
        self.loadingStatusText = @"加载中...";
        
        _refreshing = NO;
    }
    
    return self;
}

- (void)startRefreshing
{
    _refreshing = YES;
    
    [self setState:EGOPullRefreshRefreshing];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    self.scrollView.contentInset = UIEdgeInsetsMake(INSET, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    
    if (self.refreshingBlock) {
        self.refreshingBlock();
    }
}

- (void)stopRefreshing
{
    _refreshing = NO;
    
    [self setState:EGOPullRefreshNormal];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    if (self.state == EGOPullRefreshRefreshing) {
        [self handleRefreshRefreshingStatus];
    }
    else if (self.scrollView.isDragging) {
       [self handleRefreshNormalAndPullingStatus];
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        
        if (self.refreshing) {
            return;
        }
        
        if (self.scrollView.contentOffset.y <= - OFFSET_THRESHOLD && !self.refreshing) {
            [self startRefreshing];
        }
    }
}

#pragma mark - PrivateMethod

//已经在刷新
- (void)handleRefreshRefreshingStatus
{
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    offset = MIN(offset, INSET);
    self.scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
}

- (void)handleRefreshNormalAndPullingStatus
{
    if (self.state == EGOPullRefreshPulling && self.scrollView.contentOffset.y > -OFFSET_THRESHOLD && self.scrollView.contentOffset.y < 0.0f && !self.refreshing) {
        [self setState:EGOPullRefreshNormal];
    } else if (self.state == EGOPullRefreshNormal && self.scrollView.contentOffset.y < -OFFSET_THRESHOLD && !self.refreshing) {
        [self setState:EGOPullRefreshPulling];
    }
    
    if (self.scrollView.contentInset.top != 0) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
}

@end
