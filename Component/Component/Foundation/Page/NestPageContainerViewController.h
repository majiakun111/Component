//
//  NestPageContainerViewController.h
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "PageContainerViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NestPageContainerViewController : PageContainerViewController

@property(nonatomic, copy) void(^pageContainerWillLeaveTopBlock)(void);

@property(nonatomic, assign) BOOL pageCanUpDownScroll;

@end

NS_ASSUME_NONNULL_END
