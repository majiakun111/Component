//
//  UIScrollView+RefreshAndLoadMore.h
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RefreshView;
@class LoadMoreView;

@interface UIScrollView (RefreshAndLoadMore)

@property (nonatomic, strong) RefreshView *refreshView;
@property (nonatomic, strong) LoadMoreView *loadMoreView;

@end
