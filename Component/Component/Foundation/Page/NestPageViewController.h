//
//  NestPageViewController.h
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "PageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NestPageViewController : PageViewController

#pragma mark - PageItemProtocol
@property(nonatomic, assign) BOOL canUpDownScroll;
/**
 contentOffset.y <= 0
 */
@property(nonatomic, copy) void(^pageWillLeaveTopBlock)(void);

@end

NS_ASSUME_NONNULL_END
