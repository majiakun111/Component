//
//  RefreshViewController.h
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizeDefine.h"

@class RefreshView;
@class LoadMoreView;

@interface RefreshViewController : UIViewController <UIScrollViewDelegate>
{
    RefreshView *_refreshHeaderView;
    LoadMoreView *_loadMoreFooterView;
    UIScrollView *_scrollView;
}

@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) RefreshView *refreshHeaderView;
@property (nonatomic, strong) LoadMoreView *loadMoreFooterView;

- (void)buildUI;
- (UIScrollView *)scrollView;

- (void)startRefreshing;
- (void)stopRefreshing;
- (void)stopLoading;

- (void)doRefresh;
- (void)loadMore;

@end
