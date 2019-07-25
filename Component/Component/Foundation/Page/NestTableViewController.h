//
//  CollectionViewNestPageContainerViewControllerViewController.h
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewComponent.h"
#import "TableViewSectionItem.h"
#import "TableViewCell.h"
#import "TableViewCellItem.h"
#import "HeaderOrFooterView.h"
#import "HeaderOrFooterViewItem.h"
#import "PageContainerItem.h"
#import "NestPageContainerViewController.h"

@class NestTableViewBottomSectionHeaderView;
@class NestTableViewBottomSectionCell;

typedef void(^NestTabelViewBottomCellCanScrollBlock)(BOOL tabelViewBottomCellCanScroll);

NS_ASSUME_NONNULL_BEGIN

@protocol NestTableViewBottomSectionHeaderViewDelegate <HeaderOrFooterViewDelegate>

- (void)headerView:(NestTableViewBottomSectionHeaderView *)headerView pageTitleCurrentIndex:(NSInteger)pageTitleCurrentIndex;

@end

@protocol NestTableViewBottomSectionCellDelegate <TableViewCellDelegate>

- (void)tableViewCell:(NestTableViewBottomSectionCell *)tableViewCell pageContainerViewControllerScrollToContentOffset:(CGPoint)contentOffset;

- (void)pageContainerViewControllerWillLeaveTopForTableViewCell:(NestTableViewBottomSectionCell *)tableViewCell;

@end

//总共两个section

//顶部section
//Top Section Cell 可以有很多个
@interface NestTableViewTopSectionCellItem : TableViewCellItem

@end

@interface NestTableViewTopSectionCell : TableViewCell

@end

//低部section
//Bottom Section HeaderView 只有一个
@interface NestTableViewBottomSectionHeaderViewItem : HeaderOrFooterViewItem

@property(nonatomic, assign) CGFloat indexProgress;
@property(nonatomic, copy) NSArray<NSString *> *titles;

@end

@interface NestTableViewBottomSectionHeaderView : HeaderOrFooterView

@end

//Bottom Section Cell 只有一个
@interface NestTableViewBottomSectionCellItem : TableViewCellItem

@property(nonatomic, assign) BOOL canUpDownScroll;
@property(nonatomic, assign) NSUInteger pageIndex;

@property(nonatomic, strong) PageContainerItem *pageContainerItem;

@end

@interface NestTableViewBottomSectionCell : TableViewCell

@property(nonatomic, strong, nullable) UIViewController *parentViewController;

@end

//TableView
@interface NestTableView : UITableView

@end

@interface NestTableViewComponent : TableViewComponent

@property(nonatomic, assign) BOOL canUpDownScroll;

@property(nonatomic, copy) NestTabelViewBottomCellCanScrollBlock tabelViewBottomCellCanScrollBlock;

@end

@interface NestTableViewController : UIViewController

- (instancetype)initWithSectioItems:(NSArray<__kindof TableViewSectionItem *> *)sectionItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)buildTableViewComponent;
- (void)mapItemClassToViewClassWithTableViewComponent:(TableViewComponent *)tableViewComponent;
- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent willDisplayCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent didEndDisplayingCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
