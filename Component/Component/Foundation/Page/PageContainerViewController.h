//
//  PageViewController.h
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageContainerItem.h"

typedef void(^PageContainerViewControllerContentOffsetDidChangeBlock)(CGPoint contentOffset);
typedef void(^PageContainerViewControllerPageIndexChangeBlock)(NSInteger pageIndex);

NS_ASSUME_NONNULL_BEGIN

@interface PageContainerViewController : UIViewController
{
    __kindof PageContainerItem *_pageContainerItem;
}

@property(nonatomic, strong) __kindof PageContainerItem *pageContainerItem;
@property(nonatomic, copy) PageContainerViewControllerContentOffsetDidChangeBlock contentOffsetDidChangeBlock;
@property(nonatomic, copy) PageContainerViewControllerPageIndexChangeBlock pageIndexChangeBlock;
@property(nonatomic, strong) UIColor *tintColor;

- (instancetype)initWithPageContainerItem:(nullable __kindof PageContainerItem *)pageContainerItem NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)setPageIndex:(NSInteger)pageIndex animated:(BOOL)animated;

- (void)pageViewControllerDidCreated:(UIViewController<PageItemProtocol> *)pageViewController;

@end

NS_ASSUME_NONNULL_END
