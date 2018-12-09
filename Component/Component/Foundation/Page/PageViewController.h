//
//  CollectionViewPageViewController.h
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewComponent.h"
#import "PageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageViewController : UIViewController

@property(nonatomic, readonly) CollectionViewComponent *collectionViewComponent;

- (instancetype)initWithPageItem:(__kindof PageItem *)pageItem NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)buildCollectionViewComponent;

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent;

- (void)collectionViewComponent:(CollectionViewComponent *)collectionViewComponent didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)reloadDataWithPageItem:(__kindof PageItem *)pageItem;

@end

NS_ASSUME_NONNULL_END
