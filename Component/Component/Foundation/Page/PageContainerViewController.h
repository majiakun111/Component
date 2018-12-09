//
//  PageViewController.h
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PageContainerViewController<__covariant ViewControllerType : UIViewController *> : UIViewController

- (instancetype)initWithPageViewControllers:(NSArray<ViewControllerType> *)pageViewControllers pageWidth:(CGFloat)pageWidth NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)reloadDataWithPageViewControllers:(NSArray<ViewControllerType> *)pageViewControllers;

- (void)setPageIndex:(NSInteger)pageIndex animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
