//
//  RemoteCollectionViewController.m
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "RemoteCollectionViewController.h"
#import "UIView+Coordinate.h"

@implementation RemoteCollectionViewController

- (void)buildCollectionView
{
    [super buildCollectionView];
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.refreshView = [RefreshView refreshWithFrame:CGRectMake(0.0f, 0.0f - self.collectionView.height, self.collectionView.width, self.collectionView.height) refreshingBlock:^{
        [weakSelf doRefresh];
    }];
    
    self.collectionView.loadMoreView = [LoadMoreView loadMoreWithFrame:CGRectMake(0.0f, 0.0f - self.collectionView.height, self.collectionView.width, self.collectionView.height) loadingBlock:^{
        [weakSelf loadMore];
    }];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self.collectionView.refreshView startRefreshing];
}

- (void)reloadData
{
    [self.collectionView reloadData];
}

- (void)startRefreshing
{
    [self.collectionView.refreshView startRefreshing];
}

- (void)stopRefreshing
{
    [self.collectionView.refreshView stopRefreshing];
}

- (void)stopLoading
{
    [self.collectionView.loadMoreView stopLoading];
}

- (void)setHasMore:(BOOL)hasMore
{
    [self.collectionView.loadMoreView setHasMore:hasMore];
}

#pragma mark - override
-(void)doRefresh
{
    
}

- (void)loadMore
{
    
}

@end
