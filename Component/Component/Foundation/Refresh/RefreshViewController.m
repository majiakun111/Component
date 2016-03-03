//
//  RefreshViewController.m
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "RefreshViewController.h"
#import "UIView+Coordinate.h"
#import "RefreshView.h"
#import "LoadMoreView.h"

#define OFFSET_THRESHOLD 65.0
#define INSET  60.0f

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface RefreshViewController ()

@property (nonatomic, assign) CGFloat currentContentOffsetY; //保存加载之前 scrollView的 contentOffsetY

@property (nonatomic, assign) BOOL refreshing;
@property (nonatomic, assign) BOOL loading; //判断是否在load more

@end

@implementation RefreshViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _refreshing = NO;
        _loading = NO;
        _hasMore = YES;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildUI];
    
    [self addObserverKeyPaths];
}

- (void)startRefreshing
{
    _refreshing = YES;
    
    [self.refreshHeaderView setState:EGOPullRefreshRefreshing];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    self.scrollView.contentInset = UIEdgeInsetsMake(INSET, 0.0f, 0.0f, 0.0f);
    [UIView commitAnimations];
    
    [self doRefresh];
}

- (void)stopRefreshing
{
    _refreshing = NO;
    
    [self.refreshHeaderView setState:EGOPullRefreshNormal];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    [UIView commitAnimations];
}

- (void)stopLoading
{
    _loading = NO;
    
    [self.loadMoreFooterView setState:EGOPullLoadMorehNormal];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    
    self.scrollView.contentInset = UIEdgeInsetsZero;
    
    //让scrollView会到load more之前的位置
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentOffset.x, _currentContentOffsetY-OFFSET_THRESHOLD) animated:YES];
    
    [UIView commitAnimations];
}

- (void)reloadData
{
    NSLog(@"Override reloadData in subclass. This line should not appear on console");
}

- (void)doRefresh
{
    NSLog(@"Override doRefresh in subclass. This line should not appear on console");
}

- (void)loadMore
{
    NSLog(@"Override loadMore in subclass. This line should not appear on console");
}

#pragma mark - UI

- (void)buildUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    if (self.scrollView.delegate == nil) {
        self.scrollView.delegate = self;
    }
    
    //永远支持垂直滑动
    [self.scrollView setAlwaysBounceVertical:YES];
    
    self.refreshHeaderView = [[RefreshView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.scrollView.height, self.scrollView.width, self.scrollView.height)];
    [self.refreshHeaderView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.refreshHeaderView];
    
    self.loadMoreFooterView = [[LoadMoreView alloc] initWithFrame:CGRectMake(0.0f, self.scrollView.height, self.scrollView.width, self.scrollView.height)];
    [self.loadMoreFooterView setBackgroundColor:[UIColor clearColor]];
    [self.scrollView addSubview:self.loadMoreFooterView];
}

#pragma mark - Property

- (void)setHasMore:(BOOL)hasMore
{
    _hasMore = hasMore;
    if (!_hasMore) {
        [self.loadMoreFooterView setHidden:YES];
    }
    else {
        [self.loadMoreFooterView setHidden:NO];
    }
}

#pragma mark observe callback

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    if ([keyPath isEqualToString:@"contentSize"]) {
        [self scrollViewContentSizeDidChange:change];
    }
}


#pragma mark - PrivateMethod

- (void)addObserverKeyPaths
{
    [self.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    //一开始进入 页面就设置了 self.hasMore = NO; self.loadMoreFooterView就必须隐藏
    if (!self.hasMore || self.scrollView.contentSize.height < self.scrollView.height) {
        [self.loadMoreFooterView setHidden:YES];
    }
    else {
        [self.loadMoreFooterView setHidden:NO];
        [self.loadMoreFooterView setTop:self.scrollView.contentSize.height];
    }
}

- (void)startLoading
{
    _loading = YES;
    
    [self.loadMoreFooterView setState:EGOPullLoadMoreLoading];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:ANIMATION_TIME];
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, INSET, 0.0f);
    [UIView commitAnimations];
    
    _currentContentOffsetY = self.scrollView.contentOffset.y;
    
    [self loadMore];
}

- (BOOL)handleRefreshNormalAndPullingStatus
{
    BOOL isHandle = NO;
    if (self.refreshHeaderView.state == EGOPullRefreshPulling && self.scrollView.contentOffset.y > -OFFSET_THRESHOLD && self.scrollView.contentOffset.y < 0.0f && !self.refreshing) {
        [self.refreshHeaderView setState:EGOPullRefreshNormal];
        isHandle = YES;
    } else if (self.refreshHeaderView.state == EGOPullRefreshNormal && self.scrollView.contentOffset.y < -OFFSET_THRESHOLD && !self.refreshing) {
        [self.refreshHeaderView setState:EGOPullRefreshPulling];
        
        isHandle = YES;
    }
    
    if (self.scrollView.contentInset.top != 0) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
    
    return isHandle;
}

//已经在刷新
- (void)handleRefreshRefreshingStatus
{
    CGFloat offset = MAX(self.scrollView.contentOffset.y * -1, 0);
    offset = MIN(offset, INSET);
    self.scrollView.contentInset = UIEdgeInsetsMake(offset, 0.0f, 0.0f, 0.0f);
}

- (void)handleLoadMoreNormalAndPullingStatus
{
    if (!self.hasMore || self.loadMoreFooterView.isHidden) {
        return;
    }
    
    CGFloat offset = self.scrollView.contentOffset.y + self.scrollView.height -  self.scrollView.contentSize.height;
    if (self.loadMoreFooterView.state == EGOPullLoadMorePulling && offset < OFFSET_THRESHOLD && self.scrollView.contentOffset.y > 0.0f && !self.loading) {
        [self.loadMoreFooterView setState:EGOPullLoadMorehNormal];
    } else if (self.loadMoreFooterView.state == EGOPullLoadMorehNormal && offset > OFFSET_THRESHOLD && !self.loading) {
        [self.loadMoreFooterView setState:EGOPullLoadMorePulling];
    }
    
    if (self.scrollView.contentInset.bottom != 0) {
        self.scrollView.contentInset = UIEdgeInsetsZero;
    }
}

- (void)handleLoadingMoreLoadingStatus
{
    CGFloat offset = MAX(self.scrollView.contentOffset.y + self.scrollView.height -  self.scrollView.contentSize.height, 0);
    offset = MIN(offset, INSET);
    self.scrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0f, offset, 0.0f);
}

#pragma mark - UIScrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(self.searchDisplayController.searchResultsTableView == scrollView) {
        return;
    }
    
	if (self.refreshHeaderView.state == EGOPullRefreshRefreshing) {
        //header
        [self handleRefreshRefreshingStatus];
	}
    else if (self.loadMoreFooterView.state == EGOPullLoadMoreLoading) {
        //footer
        [self handleLoadingMoreLoadingStatus];
    }
    else if (scrollView.isDragging) {
        //header
        BOOL isHandle = [self handleRefreshNormalAndPullingStatus];
        if (isHandle) {
            return;
        }
        //header end
        
        //footer
        [self handleLoadMoreNormalAndPullingStatus];
        //footer end
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(self.searchDisplayController.searchResultsTableView == scrollView) {
        return;
    }
    
    if (self.refreshing || self.loading) {
        return;
    }
    
    //header
    if (self.scrollView.contentOffset.y <= - OFFSET_THRESHOLD && !self.refreshing) {
        [self startRefreshing];
        
        return;
    }
    //header end

    //footer
    if (!self.hasMore || self.loadMoreFooterView.isHidden) {
        return;
    }
    
    CGFloat offset = scrollView.contentOffset.y + scrollView.height - scrollView.contentSize.height - OFFSET_THRESHOLD;
    if (offset > 0.0) {
        [self startLoading];
    }
    //footer end
}

@end
