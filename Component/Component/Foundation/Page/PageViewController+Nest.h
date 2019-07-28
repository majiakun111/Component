//
//  PageViewController+Nest.h
//  Component
//
//  Created by Ansel on 2019/7/28.
//  Copyright © 2019 MJK. All rights reserved.
//

#import "PageViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageViewController (Nest)

- (void)scrollViewDidScroll:(__kindof CollectionViewComponent *)collectionViewComponent;

#pragma mark - PageItemProtocol
@property(nonatomic, assign) BOOL canUpDownScroll;

@property(nonatomic, copy) void(^pageWillLeaveTopBlock)(void);

@end

NS_ASSUME_NONNULL_END
