//
//  LoadMoreView.h
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "PullView.h"

typedef void (^LoadingBlock)();

@interface LoadMoreView : PullView

@property (nonatomic, assign) BOOL hasMore;

+ (instancetype)loadMoreWithFrame:(CGRect)frame loadingBlock:(LoadingBlock)loadingBlock;

- (void)stopLoading;

@end
