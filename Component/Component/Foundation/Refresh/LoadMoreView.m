//
//  LoadMoreView.m
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "LoadMoreView.h"

#define CONTENT_HEIGHT 60.f
#define REAL_WIDTH 94.0f //(image + label 及他们之间的间隙 所占的大小)

@implementation LoadMoreView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame arrowImage:@"PullToLoadMore"])) {
        self.state = EGOPullLoadMorehNormal;
        [self.statusLabel setText:@"上拉刷新"];
        self.normalStatusText = @"上拉刷新";
        self.pullingStatusText = @"释放加载更多";
        self.loadingStatusText = @"加载中...";
    }
    
    return self;
}

@end
