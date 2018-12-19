//
//  RemoteTableViewController.h
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIScrollView+RefreshAndLoadMore.h"
#import "RefreshView.h"
#import "LoadMoreView.h"
#import "TableViewComponent.h"

@interface RefreshTableViewController : UIViewController <TableViewCellDelegate, HeaderOrFooterViewDelegate>

@property(nonatomic, strong, readonly) TableViewComponent *tableViewComponent;

- (void)updateSectionItems:(NSArray<TableViewSectionItem *> *)sectionItems;
- (void)reloadData;

- (void)startRefreshing;
- (void)stopRefreshing;

- (void)stopLoading;
- (void)setHasMore:(BOOL)hasMore;

- (void)doRefresh;
- (void)loadMore;

- (void)mapItemClassToViewClassWithTableViewComponent:(TableViewComponent *)tableViewComponent;
- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent willDisplayCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent didEndDisplayingCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end
