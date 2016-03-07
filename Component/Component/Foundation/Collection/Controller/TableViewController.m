//
//  TableViewController.m
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TableViewController.h"
#import "NSObject+ClassName.h"
#import "CommonDefine.h"

#import "SectionItem.h"
#import "CellItem.h"
#import "HeaderOrFooterViewItem.h"
#import "TableViewCell.h"
#import "TableViewHeaderOrFooterView.h"
#import "TableViewRelativeHeightHelper.h"

typedef NS_ENUM(NSInteger, HeaderOrFooterViewKind) {
    Header = 0,
    Footer = 1,
};

@interface TableViewController () <TableViewCellDelegate>
//1. CellItem 的ClassName作为key TableViewCell或其子类的class作为值
//2. 以HeaderOrFooterViewItem的ClassName作为key HeaderOrFooterView或其子类的class作为值
@property (nonatomic, strong) NSMutableDictionary *viewClassMap;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self mapItemClassToViewClass];
    [self buildUI];
}

- (void)buildUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self buildTableView];
}

- (void)buildTableView
{
    CGRect rect = CGRectZero;
    if (self.navigationController) {
        rect = CGRectMake(0, STATUS_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }
    else {
        rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    _tableView = [[UITableView alloc] initWithFrame:rect];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    
    [self.view addSubview:_tableView];
}

- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass
{
    [self.viewClassMap setObject:cellClass forKey:[cellItemClass className]];
}

- (void)mapHeaderOrFooterViewClass:(Class)headerOrFooterViewClass headerOrFooterViewItem:(Class)headerOrFooterViewItem
{
    [self.viewClassMap setObject:headerOrFooterViewClass forKey:[headerOrFooterViewItem className]];
}

#pragma mark - MustOverride

- (void)mapItemClassToViewClass;
{
#ifdef DEBUG
    MustOverride();
#endif
}

#pragma mark -- optional override property

- (TableViewRelativeHeightHelper *)heightHelper
{
    if (nil == _heightHelper) {
        _heightHelper = [[TableViewRelativeHeightHelper alloc] init];
    }
    
    return _heightHelper;
}

#pragma mark -- property

-(NSMutableArray<SectionItem *> *)sectionItems
{
    if (nil == _sectionItems) {
        _sectionItems = [[NSMutableArray alloc] init];
    }
    
    return _sectionItems;
}

- (NSMutableDictionary *)viewClassMap
{
    if (nil == _viewClassMap) {
        _viewClassMap = [[NSMutableDictionary alloc] init];
    }
    
    return _viewClassMap;
}

#pragma mark - PrivateMethod UITableView Handle Method

// section对应的行数
- (NSInteger)numOfRowsInSection:(NSInteger)sectionIndex tableView:(UITableView *)tableView
{
    NSInteger numOfRows = 0;
    if (tableView == self.tableView) {
        if (0 <= sectionIndex && sectionIndex < [self.sectionItems count]) {
            SectionItem *sectionItem = [self.sectionItems objectAtIndex:sectionIndex];
            numOfRows = [sectionItem.cellItems count];
        }
    }
    
    return numOfRows;
}

// cell 对应的数据
- (__kindof CellItem *)cellItemForIndexPath:(NSIndexPath *)indexPath tableView:(UITableView *)tableView
{
    if (nil == tableView) {
        return nil;
    }
    
    CellItem *item = nil;
    do {
        if (tableView == self.tableView){
            if (indexPath.section >= [self.sectionItems count]) {
                break;
            }
            
            SectionItem *sectionItem = [self.sectionItems objectAtIndex:indexPath.section];
            NSMutableArray *sectionData = sectionItem.cellItems;
            if (indexPath.row >= [sectionData count]) {
                break;
            }
            
            item = [sectionData objectAtIndex:indexPath.row];
        }
    } while (0);
    
    
    return item;
}

- (__kindof HeaderOrFooterViewItem *)headerOrFooterViewItemForSection:(NSInteger)section kind:(HeaderOrFooterViewKind)kind tableView:(UITableView *)tableView
{
    if (nil == tableView) {
        return nil;
    }
    
    HeaderOrFooterViewItem *item = nil;
    do {
        if (tableView == self.tableView) {
            if (section >= [self.sectionItems count]) {
                break;
            }
            
            SectionItem *sectionItem = [self.sectionItems objectAtIndex:section];
            if (kind == Header) {
                item = sectionItem.headerViewItem;
            } else {
                item = sectionItem.footerViewItem;
            }
        }
    } while (0);
    
    return item;
}

- (Class)cellClassWithItem:(CellItem *)item
{
    Class cellClass = [self.viewClassMap objectForKey:[item className]];
    return cellClass == nil ? [TableViewCell class] : cellClass;
}

- (NSString *)tableViewCellIdentifier:(CellItem *)item
{
    NSString *identifier = @"TableViewCell";
    Class cellClass = [self cellClassWithItem:item];
    if (cellClass && [cellClass isSubclassOfClass:[TableViewCell class]]) {
        identifier = [cellClass className];
    }
    
    return identifier;
}

- (Class)headerOrFooterViewClassWithItem:(HeaderOrFooterViewItem *)item
{
    Class cellClass = [self.viewClassMap objectForKey:[item className]];
    return cellClass == nil ? [TableViewHeaderOrFooterView class] : cellClass;
}

- (TableViewHeaderOrFooterView *)headerOrFooterViewForSection:(NSInteger)section kind:(HeaderOrFooterViewKind)kind tableView:(UITableView *)tableView
{
    TableViewHeaderOrFooterView *headerOrFooterView = nil;
    
    do {
        HeaderOrFooterViewItem *item = [self headerOrFooterViewItemForSection:section kind:kind tableView:tableView];
        if (!item) {
            break;
        }
        
        Class headerOrFooterViewClass = [self headerOrFooterViewClassWithItem:item];
        
        headerOrFooterView = [[headerOrFooterViewClass alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, item.height)];
        [headerOrFooterView setItem:item];
        
    } while (0);
    
    return headerOrFooterView;
}

- (CGFloat)headerOrFooterViewHeightForSection:(NSInteger)section kind:(HeaderOrFooterViewKind)kind tableView:(UITableView *)tableView
{
    HeaderOrFooterViewItem *item = [self headerOrFooterViewItemForSection:section kind:kind tableView:tableView];
    Class headerOrFooterViewClass = [self headerOrFooterViewClassWithItem:item];
    
    CGFloat height = [self.heightHelper getHeaderOrFooterHeightWithItem:item headerClass:headerOrFooterViewClass];
    
    return height;
}

#pragma-- mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sectionCount = 1;
    if (tableView == self.tableView) {
        sectionCount = [self.sectionItems count];
    }
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    CGFloat rows =  [self numOfRowsInSection:section tableView:tableView];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = nil;
    CellItem *item = [self cellItemForIndexPath:indexPath tableView:tableView];
    cellIdentifier = [self tableViewCellIdentifier:item];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        Class cellClass = [self cellClassWithItem:item];
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setDelegate: self];
    }
    
    [cell setItem:item];

    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TableViewHeaderOrFooterView *headerView = [self headerOrFooterViewForSection:section kind:Header tableView:tableView];

    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    TableViewHeaderOrFooterView *footerView = [self headerOrFooterViewForSection:section kind:Footer tableView:tableView];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellItem *item = [self cellItemForIndexPath:indexPath tableView:tableView];
    Class cellClass = [self cellClassWithItem:item];
    
    CGFloat height = [self.heightHelper getCellHeightWithItem:item cellClass:cellClass];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat height = [self headerOrFooterViewHeightForSection:section kind:Header tableView:tableView];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    CGFloat height = [self headerOrFooterViewHeightForSection:section kind:Footer tableView:tableView];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
