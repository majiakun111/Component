//
//  RemoteTableViewController.h
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "TableViewController.h"
#import "UIScrollView+RefreshAndLoadMore.h"
#import "RefreshView.h"
#import "LoadMoreView.h"

@interface RefreshTableViewController : TableViewController

- (void)reloadData;

- (void)startRefreshing;
- (void)stopRefreshing;

- (void)stopLoading;
- (void)setHasMore:(BOOL)hasMore;

#pragma mark - Override
- (void)doRefresh;
- (void)loadMore;

@end
