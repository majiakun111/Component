//
//  TableViewController.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SizeDefine.h"

@class TableViewSectionItem;
@class TableViewRelativeHeightHelper;

@interface TableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray <TableViewSectionItem *> *sectionItems;

//optional overrride   得到 cell header footer的高度
@property (nonatomic, strong) TableViewRelativeHeightHelper *heightHelper;

- (void)buildUI;

- (void)buildTableView;

//映射TableViewCell Class和TableViewSectionItem ClassName的关系  以TableViewSectionItem 的ClassName作为key TableViewCell或其子类的class作为值
- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;

//映射HeaderOrFooterView Class和HeaderViewOrFooterViewItem ClassName的关系  以HeaderOrFooterViewItem的ClassName作为key HeaderOrFooterView或其子类的class作为值
- (void)mapHeaderOrFooterViewClass:(Class)headerOrFooterViewClass headerOrFooterViewItem:(Class)headerOrFooterViewItem;

#pragma mark - MustOverride
//调用
//- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;
//- (void)mapHeaderOrFooterViewClass:(Class)headerOrFooterViewClass headerOrFooterViewItem:(Class)headerOrFooterViewItem;
- (void)mapItemClassToViewClass;

@end
