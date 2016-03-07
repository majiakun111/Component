//
//  RefreshViewController+LoadingTips.h
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "RefreshViewController.h"
#import "TipsDefine.h"

@class BaseLoadingTips;

@interface RefreshViewController (LoadingTips)

@property (nonatomic, assign) LoadingTipsType loadingTipsType;

- (void)showLoadingTips;

- (void)hiddenLoadingTips;

@end
