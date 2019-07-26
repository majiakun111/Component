//
//  NestPageContainerViewController.m
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "NestPageContainerViewController.h"

@interface NestPageContainerViewController ()

@property(nonatomic, strong) NSMutableSet<UIViewController<PageItemProtocol> *> *pageViewControllers;

@end

@implementation NestPageContainerViewController

#pragma mark - Override

- (void)pageViewControllerDidCreated:(UIViewController<PageItemProtocol> *)pageViewController {
    [super pageViewControllerDidCreated:pageViewController];
    
    __weak typeof(self) weakSelf = self;
    if ([pageViewController respondsToSelector:@selector(setPageWillLeaveTopBlock:)]) {
        [pageViewController setPageWillLeaveTopBlock:^{
            if (weakSelf.pageContainerWillLeaveTopBlock) {
                weakSelf.pageContainerWillLeaveTopBlock();
            }
        }];
    }
    
    if ([pageViewController respondsToSelector:@selector(setCanUpDownScroll:)]) {
        [pageViewController setCanUpDownScroll:self.pageCanUpDownScroll];
    }
}

#pragma mark - Property

- (void)setPageContainerItem:(__kindof PageContainerItem *)pageContainerItem {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_pageContainerItem != pageContainerItem) {
            [self.pageViewControllers removeAllObjects];
        }
        
        [super setPageContainerItem:pageContainerItem];
    });
}

- (void)setPageCanUpDownScroll:(BOOL)pageCanUpDownScroll {
    _pageCanUpDownScroll = pageCanUpDownScroll;
    
    [self.pageViewControllers enumerateObjectsUsingBlock:^(UIViewController<PageItemProtocol> * _Nonnull pageViewController, BOOL * _Nonnull stop) {
        if ([pageViewController respondsToSelector:@selector(setCanUpDownScroll:)]) {
            [pageViewController setCanUpDownScroll:_pageCanUpDownScroll];
        }
    }];
}

- (NSMutableSet<UIViewController<PageItemProtocol> *> *)pageViewControllers {
    if (nil == _pageViewControllers) {
        _pageViewControllers = [[NSMutableSet alloc] init];
    }
    
    return _pageViewControllers;
}

@end
