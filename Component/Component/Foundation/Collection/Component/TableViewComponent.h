//
//  TableViewComponent.h
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewCell.h"
#import "HeaderOrFooterView.h"
#import "TableViewSectionItem.h"
#import "TableViewRelativeHeightHelper.h"

@class TableViewComponent;

typedef void(^TableViewComponentDidSelectedIndexPathBlcok)(__kindof TableViewComponent *tableViewComponent, NSIndexPath *indexPath);
typedef void(^TableViewComponentWillDisplayIndexPathBlock)(__kindof TableViewComponent *tableViewComponent, __kindof UITableViewCell *cell, NSIndexPath *indexPath);
typedef void(^TableViewComponentDidEndDisplayingIndexPathBlock)(__kindof TableViewComponent *tableViewComponent, __kindof UITableViewCell *cell, NSIndexPath *indexPath);

NS_ASSUME_NONNULL_BEGIN

@interface TableViewComponent : NSObject <UITableViewDataSource, UITableViewDelegate>
{
    @public
    UITableView *_tableView;
}

@property(nonatomic, strong, readonly) UITableView *tableView;
@property(nonatomic, strong, readonly) NSMutableArray <TableViewSectionItem *> *sectionItems;
@property (nonatomic, weak) id<TableViewCellDelegate> cellDelegate;
@property (nonatomic, weak) id<HeaderOrFooterViewDelegate> headerOrFooterViewDelegate;

//optional overrride   得到 cell header footer的高度
@property(nonatomic, strong) TableViewRelativeHeightHelper *heightHelper;

@property(nonatomic, copy) TableViewComponentDidSelectedIndexPathBlcok didSelectedIndexPathBlcok;
@property(nonatomic, copy) TableViewComponentWillDisplayIndexPathBlock willDisplayIndexPathBlock;
@property(nonatomic, copy) TableViewComponentDidEndDisplayingIndexPathBlock didEndDisplayingIndexPathBlock;

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof TableViewSectionItem *> *)sectionItems
        mapItemClassToViewClassBlock:(void (^)(__kindof TableViewComponent *tableViewComponent))mapItemClassToViewClassBlock
                       delegateBlock:(void(^)(__kindof TableViewComponent *tableViewComponent))delegateBlock NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)buildTableView;

- (void)updateSectionItems:(NSArray<TableViewSectionItem *> *)sectionItems;

//映射TableViewCell Class和TableViewSectionItem ClassName的关系  以TableViewSectionItem 的ClassName作为key TableViewCell或其子类的class作为值
- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;

//映射HeaderOrFooterView Class和HeaderViewOrFooterViewItem ClassName的关系  以HeaderOrFooterViewItem的ClassName作为key HeaderOrFooterView或其子类的class作为值
- (void)mapHeaderOrFooterViewClass:(Class)headerOrFooterViewClass headerOrFooterViewItemClass:(Class)headerOrFooterViewItemClass;

#pragma mark - MustOverride
//调用
//- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;
//- (void)mapHeaderOrFooterViewClass:(Class)headerOrFooterViewClass headerOrFooterViewItem:(Class)headerOrFooterViewItem;
- (void)mapItemClassToViewClass;

// cell 对应的数据
- (__kindof TableViewCellItem *)cellItemForRow:(NSUInteger)row section:(NSUInteger)section;
- (__kindof TableViewCellItem *)cellItemForIndexPath:(NSIndexPath *)indexPath;

//header footer
- (__kindof HeaderOrFooterViewItem *)headerItemForSection:(NSUInteger)section;
- (__kindof HeaderOrFooterViewItem *)footerItemForSection:(NSUInteger)section;

@end

NS_ASSUME_NONNULL_END
