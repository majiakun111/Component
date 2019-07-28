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

@interface PageViewController : UIViewController<PageItemProtocol>

@property(nonatomic, strong, readonly) CollectionViewComponent *collectionViewComponent;

- (void)buildCollectionViewComponent;

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent;

- (void)collectionViewComponent:(CollectionViewComponent *)collectionViewComponent didSelectItemAtIndexPath:(NSIndexPath *)indexPath;


#pragma mark PageItemProtocol
@property(nonatomic, strong) PageItem *pageItem;
- (void)reloadDataWithPageItem:(__kindof PageItem *)pageItem;


@end

NS_ASSUME_NONNULL_END
