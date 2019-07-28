//
//  PageContainerViewController+Nest.m
//  Component
//
//  Created by Ansel on 2019/7/28.
//  Copyright © 2019 MJK. All rights reserved.
//

#import "PageContainerViewController+Nest.h"
#import <objc/runtime.h>

@interface PageContainerViewController ()

@property(nonatomic, strong) NSMutableSet<UIViewController<PageItemProtocol> *> *pageViewControllers;

@end

@implementation PageContainerViewController (Nest)

- (void)pageViewControllerDidCreated:(UIViewController<PageItemProtocol> *)pageViewController {
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

- (void)willSetPageContainerItem {
    [self.pageViewControllers removeAllObjects];
}

#pragma mark - Property

- (void)setPageContainerWillLeaveTopBlock:(void (^)(void))pageContainerWillLeaveTopBlock {
    objc_setAssociatedObject(self, @selector(pageContainerWillLeaveTopBlock), pageContainerWillLeaveTopBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))pageContainerWillLeaveTopBlock {
    return objc_getAssociatedObject(self, @selector(pageContainerWillLeaveTopBlock));
}

- (void)setPageCanUpDownScroll:(BOOL)pageCanUpDownScroll {
    objc_setAssociatedObject(self, @selector(pageCanUpDownScroll), @(pageCanUpDownScroll), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pageCanUpDownScroll {
    return [objc_getAssociatedObject(self, @selector(pageCanUpDownScroll)) boolValue];
}

#pragma mark - PrivateProperty

- (void)setPageViewControllers:(NSMutableSet<UIViewController<PageItemProtocol> *> *)pageViewControllers {
    objc_setAssociatedObject(self, @selector(pageViewControllers), pageViewControllers, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSMutableSet<UIViewController<PageItemProtocol> *> *)pageViewControllers {
    NSMutableSet<UIViewController<PageItemProtocol> *> *tmpPageViewControllers = objc_getAssociatedObject(self, @selector(pageViewControllers));
    if (!tmpPageViewControllers) {
        tmpPageViewControllers = [[NSMutableSet alloc] init];
        [self setPageViewControllers:tmpPageViewControllers];
    }
    
    return tmpPageViewControllers;
}

@end
