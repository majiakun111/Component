//
//  RefreshView.h
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "PullView.h"

typedef void (^RefreshingBlock)();

@interface RefreshView : PullView

+ (instancetype)refreshWithFrame:(CGRect)frame refreshingBlock:(RefreshingBlock)refreshingBlock;

- (void)startRefreshing;
- (void)stopRefreshing;

@end
