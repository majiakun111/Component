//
//  NestPageContainerViewController.m
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "NestPageContainerViewController.h"

@interface NestPageContainerViewController ()

@end

@implementation NestPageContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Property

- (void)setPageContainerItem:(__kindof PageContainerItem *)pageContainerItem {
    [super setPageContainerItem:pageContainerItem];
    
    __weak typeof(self) weakSelf = self;
    [self.pageViewControllers enumerateObjectsUsingBlock:^(UIViewController<PageItemProtocol> * _Nonnull pageViewController, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pageViewController respondsToSelector:@selector(setPageWillLeaveTopBlock:)]) {
            [pageViewController setPageWillLeaveTopBlock:^{
                if (weakSelf.pageContainerWillLeaveTopBlock) {
                    weakSelf.pageContainerWillLeaveTopBlock();
                }
            }];
        }
    }];
}

- (void)setPageCanUpDownScroll:(BOOL)pageCanUpDownScroll {
    _pageCanUpDownScroll = pageCanUpDownScroll;
    
    [self.pageViewControllers enumerateObjectsUsingBlock:^(UIViewController<PageItemProtocol> * _Nonnull pageViewController, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([pageViewController respondsToSelector:@selector(setCanUpDownScroll:)]) {
            [pageViewController setCanUpDownScroll:_pageCanUpDownScroll];
        }
    }];
}


@end
