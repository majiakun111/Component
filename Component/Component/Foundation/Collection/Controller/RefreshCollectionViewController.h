//
//  RemoteCollectionViewController.h
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+RefreshAndLoadMore.h"
#import "RefreshView.h"
#import "LoadMoreView.h"
#import "CollectionViewComponent.h"

@interface RefreshCollectionViewController : UIViewController

@property(nonatomic, strong, readonly) CollectionViewComponent *collectionViewComponent;

- (void)updateSectionItems:(NSArray<CollectionViewSectionItem *> *)sectionItems;
- (void)reloadData;

- (void)startRefreshing;
- (void)stopRefreshing;

- (void)stopLoading;
- (void)setHasMore:(BOOL)hasMore;

- (void)doRefresh;
- (void)loadMore;

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent;
- (void)collectionViewComponent:(CollectionViewComponent *)collectionViewComponent didSelectItemAtIndexPath:(NSIndexPath *)indexPath;

@end
