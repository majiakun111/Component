//
//  PageContainerViewController+Nest.h
//  Component
//
//  Created by Ansel on 2019/7/28.
//  Copyright © 2019 MJK. All rights reserved.
//

#import "PageContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageContainerViewController (Nest)

@property(nonatomic, copy) void(^pageContainerWillLeaveTopBlock)(void);

@property(nonatomic, assign) BOOL pageCanUpDownScroll;

- (void)pageViewControllerDidCreated:(UIViewController<PageItemProtocol> *)pageViewController;
- (void)willSetPageContainerItem;

@end

NS_ASSUME_NONNULL_END
