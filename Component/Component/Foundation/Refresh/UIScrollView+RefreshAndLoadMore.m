//
//  UIScrollView+RefreshAndLoadMore.m
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "UIScrollView+RefreshAndLoadMore.h"
#import <objc/runtime.h>
#import "RefreshView.h"
#import "LoadMoreView.h"

@implementation UIScrollView (RefreshAndLoadMore)

@dynamic refreshView;
@dynamic loadMoreView;

- (void)setRefreshView:(RefreshView *)refreshView
{
    if (refreshView != self.refreshView) {
        // 删除旧的，添加新的
        [self.refreshView removeFromSuperview];
        [self insertSubview:refreshView atIndex:0];
        
        objc_setAssociatedObject(self, @selector(refreshView), refreshView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (RefreshView *)refreshView
{
    return objc_getAssociatedObject(self, @selector(refreshView));
}

- (void)setLoadMoreView:(LoadMoreView *)loadMoreView
{
    if (loadMoreView != self.loadMoreView) {
        // 删除旧的，添加新的
        [self.loadMoreView removeFromSuperview];
        [self addSubview:loadMoreView];
        
        // 存储新的
        objc_setAssociatedObject(self, @selector(loadMoreView), loadMoreView, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (LoadMoreView *)loadMoreView
{
    return objc_getAssociatedObject(self, @selector(loadMoreView));
}

@end
