//
//  PageViewController+Nest.m
//  Component
//
//  Created by Ansel on 2019/7/28.
//  Copyright © 2019 MJK. All rights reserved.
//

#import "PageViewController+Nest.h"
#import <objc/runtime.h>

@implementation PageViewController (Nest)

- (void)scrollViewDidScroll:(__kindof CollectionViewComponent *)collectionViewComponent {
    if (!self.canUpDownScroll) {
        self.collectionViewComponent.collectionView.contentOffset = CGPointZero;
    }
    if (self.collectionViewComponent.collectionView.contentOffset.y <= 0) {
        self.canUpDownScroll = NO;
        self.collectionViewComponent.collectionView.contentOffset = CGPointZero;
        
        if (self.pageWillLeaveTopBlock) {
            self.pageWillLeaveTopBlock();
        }
    }
    
    self.collectionViewComponent.collectionView.showsVerticalScrollIndicator = self.canUpDownScroll;
}

#pragma mark - Property

- (void)setCanUpDownScroll:(BOOL)canUpDownScroll {
    objc_setAssociatedObject(self, @selector(canUpDownScroll), @(canUpDownScroll), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (!canUpDownScroll) {
        [self.collectionViewComponent.collectionView setContentOffset:CGPointZero];
    }
}

- (BOOL)canUpDownScroll {
    return [objc_getAssociatedObject(self, @selector(canUpDownScroll)) boolValue];
}

- (void)setPageWillLeaveTopBlock:(void (^)(void))pageWillLeaveTopBlock {
    objc_setAssociatedObject(self, @selector(pageWillLeaveTopBlock), pageWillLeaveTopBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void (^)(void))pageWillLeaveTopBlock {
    return objc_getAssociatedObject(self, @selector(pageWillLeaveTopBlock));
}

@end
