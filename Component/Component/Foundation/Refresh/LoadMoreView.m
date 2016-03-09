//
//  LoadMoreView.m
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "LoadMoreView.h"
#import "UIView+Coordinate.h"

#define CONTENT_HEIGHT 60.f
#define REAL_WIDTH 94.0f //(image + label 及他们之间的间隙 所占的大小)

@interface LoadMoreView ()

@property (nonatomic, assign) BOOL loading; //判断是否在load more
@property (nonatomic, assign) CGFloat currentContentOffsetY; //保存加载之前 scrollView的 contentOffsetY

@property (nonatomic, copy) LoadingBlock loadingBlock;

@end

@implementation LoadMoreView

+ (instancetype)loadMoreWithFrame:(CGRect)frame loadingBlock:(LoadingBlock)loadingBlock
{
    LoadMoreView *loadMoreView = [[self alloc] initWithFrame:frame];
    [loadMoreView setLoadingBlock:loadingBlock];
    
    return loadMoreView;
}

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame arrowImage:@"PullToLoadMore"])) {
        self.state = EGOPullLoadMorehNormal;
        [self.statusLabel setText:@"上拉刷新"];
        self.normalStatusText = @"上拉刷新";
        self.pullingStatusText = @"释放加载更多";
        self.loadingStatusText = @"加载中...";
        
        _loading = NO;
        _hasMore = YES;
    }
    
    return self;
}

- (void)stopLoading
{
    _loading = NO;
    
    [self setState:EGOPullLoadMorehNormal];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    
    //让scrollView会到load more之前的位置 
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, _currentContentOffsetY-OFFSET_THRESHOLD) animated:YES];
    
    [UIView commitAnimations];
}

- (void)startLoading
{
    _loading = YES;
    
    [self setState:EGOPullLoadMoreLoading];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, INSET, 0.0f);
    [UIView commitAnimations];
    
    _currentContentOffsetY = self.scrollView.contentOffset.y;
    
    if (self.loadingBlock) {
        self.loadingBlock();
    }
}

#pragma mark override Notification

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    //一开始进入 页面就设置了 self.hasMore = NO; self就必须隐藏
    if (!self.hasMore || self.scrollView.contentSize.height < self.scrollView.height) {
        [self setHidden:YES];
    }
    else {
        [self setHidden:NO];
        [self setTop:self.scrollView.contentSize.height];
    }
}

- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    if (self.state == EGOPullLoadMoreLoading) {
        [self handleLoadingMoreLoadingStatus];
    }
    else if (self.scrollView.isDragging) {
        [self handleLoadMoreNormalAndPullingStatus];
    }
}

- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (self.loading) {
            return;
        }
        
        if (!self.hasMore || self.isHidden) {
            return;
        }
        
        CGFloat offset = self.scrollView.contentOffset.y + self.scrollView.height - self.scrollView.contentSize.height - OFFSET_THRESHOLD;
        if (offset > 0.0) {
            [self startLoading];
        }
    }
}


#pragma mark -  property

- (void)setHasMore:(BOOL)hasMore
{
    _hasMore = hasMore;
    if (!_hasMore) {
        [self setHidden:YES];
    }
    else {
        [self setHidden:NO];
    }
}

#pragma mark - PrivateMethod

- (void)handleLoadingMoreLoadingStatus
{
    CGFloat offset = MAX(self.scrollView.contentOffset.y + self.scrollView.height -  self.scrollView.contentSize.height, 0);
    offset = MIN(offset, INSET);
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, offset, 0.0f);
}

- (void)handleLoadMoreNormalAndPullingStatus
{
    if (!self.hasMore || self.isHidden) {
        return;
    }
    
    CGFloat offset = self.scrollView.contentOffset.y + self.scrollView.height -  self.scrollView.contentSize.height;
    if (self.state == EGOPullLoadMorePulling && offset < OFFSET_THRESHOLD && self.scrollView.contentOffset.y > 0.0f && !self.loading) {
        [self setState:EGOPullLoadMorehNormal];
    } else if (self.state == EGOPullLoadMorehNormal && offset > OFFSET_THRESHOLD && !self.loading) {
        [self setState:EGOPullLoadMorePulling];
    }
    
    if (self.scrollView.contentInset.bottom != 0) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
}


@end
