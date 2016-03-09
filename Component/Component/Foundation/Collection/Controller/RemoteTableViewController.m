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
    
    [self.tableView.refreshView startRefreshing];
}

-(void)doRefresh
{

}

- (void)loadMore
{

}

- (void)reloadData
{
    [self.tableView reloadData];
}

@end
