//
//  RemoteTableViewController.m
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "RemoteTableViewController.h"
#import "UIView+Coordinate.h"

@implementation RemoteTableViewController

- (void)buildTableView
{
    [super buildTableView];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.refreshView = [RefreshView refreshWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.height, self.tableView.width, self.tableView.height) refreshingBlock:^{
        [weakSelf doRefresh];
    }];
    
    self.tableView.loadMoreView = [LoadMoreView loadMoreWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.height, self.tableView.width, self.tableView.height) loadingBlock:^{
        [weakSelf loadMore];
    }];
    
    [self startRefreshing];
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)startRefreshing
{
    [self.tableView.refreshView startRefreshing];
}

- (void)stopRefreshing
{
    [self.tableView.refreshView stopRefreshing];
}

- (void)stopLoading
{
    [self.tableView.loadMoreView stopLoading];
}

- (void)setHasMore:(BOOL)hasMore
{
    [self.tableView.loadMoreView setHasMore:hasMore];
}

#pragma mark - overrride

-(void)doRefresh
{
    
}

- (void)loadMore
{
    
}

@end
