//
//  RemoteCollectionViewController.h
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "CollectionViewController.h"
#import "UIScrollView+RefreshAndLoadMore.h"
#import "RefreshView.h"
#import "LoadMoreView.h"

@interface RemoteCollectionViewController : CollectionViewController

- (void)reloadData;

#pragma mark - Override
- (void)doRefresh;
- (void)loadMore;

@end
