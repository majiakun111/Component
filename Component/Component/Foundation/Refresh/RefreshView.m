//
//  RefreshView.m
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "RefreshView.h"
#import "UIView+Coordinate.h"

@interface RefreshView ()

@end

@implementation RefreshView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame arrowImage:@"PullToRefresh"])) {

        [self.statusLabel setTop:self.statusLabel.top + self.height - CONTENT_HEIGHT];
        [self.arrowImageLayer setFrame:CGRectMake(self.arrowImageLayer.frame.origin.x, self.arrowImageLayer.frame.origin.y + self.height - CONTENT_HEIGHT, self.arrowImageLayer.frame.size.width, self.arrowImageLayer.frame.size.height)];
        [self.loadingImageView setTop:self.loadingImageView.top + self.height - CONTENT_HEIGHT];
        
        self.state = EGOPullRefreshNormal;
        
        [self.statusLabel setText:@"下拉刷新"];
        self.normalStatusText = @"下拉刷新";
        self.pullingStatusText = @"释放更新";
        self.loadingStatusText = @"加载中...";
    }
    
    return self;
}

@end
