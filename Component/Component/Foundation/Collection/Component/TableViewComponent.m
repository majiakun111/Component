//
//  TableViewComponent.m
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "TableViewComponent.h"
#import "NSObject+ClassName.h"
#import "CommonDefine.h"
#import "TableViewCellItem.h"
#import "HeaderOrFooterViewItem.h"

typedef NS_ENUM(NSInteger, HeaderOrFooterViewKind) {
    Header = 0,
    Footer = 1,
};

@interface TableViewComponent ()
//1. TableViewCellItem 的ClassName作为key TableViewCell或其子类的class作为值
//2. 以HeaderOrFooterViewItem的ClassName作为key HeaderOrFooterView或其子类的class作为值
@property (nonatomic, strong) NSMutableDictionary *viewClassMap;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray <TableViewSectionItem *> *sectionItems;

@end

@implementation TableViewComponent

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof TableViewSectionItem *> *)sectionItems
        mapItemClassToViewClassBlock:(void (^)(__kindof TableViewComponent *tableViewComponent))mapItemClassToViewClassBlock
                       delegateBlock:(void(^)(__kindof TableViewComponent *tableViewComponent))delegateBlock {
    self = [super init];
    if (self) {
        self.sectionItems = [sectionItems mutableCopy];
        [self buildTableView];
        
        if (mapItemClassToViewClassBlock) {
            mapItemClassToViewClassBlock(self);
        } else {
            [self mapItemClassToViewClass];
        }
        
        if (delegateBlock) {
            delegateBlock(self);
        }
    }
    
    return self;
}

- (void)buildTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

-(void)updateSectionItems:(NSArray<TableViewSectionItem *> *)sectionItems {
    if (self.sectionItems != sectionItems) {
        self.sectionItems = [sectionItems mutableCopy];
        
        [self.tableView reloadData];
    }
}

- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass {
    [self.viewClassMap setObject:cellClass forKey:[cellItemClass className]];
    [self.tableView registerClass:cellClass forCellReuseIdentifier:[cellItemClass className]];
}

- (void)mapHeaderOrFooterViewClass:(Class)headerOrFooterViewClass headerOrFooterViewItemClass:(Class)headerOrFooterViewItemClass {
    [self.viewClassMap setObject:headerOrFooterViewClass forKey:[headerOrFooterViewItemClass className]];
    [self.tableView registerClass:headerOrFooterViewClass forHeaderFooterViewReuseIdentifier:[headerOrFooterViewItemClass className]];
}

#pragma mark - MustOverride

- (void)mapItemClassToViewClass {
#ifdef DEBUG
    MustOverride();
#endif
}

// cell 对应的数据
- (__kindof TableViewCellItem *)cellItemForRow:(NSUInteger)row section:(NSUInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return [self cellItemForIndexPath:indexPath];
}

- (__kindof TableViewCellItem *)cellItemForIndexPath:(NSIndexPath *)indexPath {
    TableViewCellItem *item = nil;
    do {
        if (indexPath.section >= [self.sectionItems count]) {
            break;
        }
        
        TableViewSectionItem *sectionItem = [self.sectionItems objectAtIndex:indexPath.section];
        NSMutableArray *sectionData = sectionItem.cellItems;
        if (indexPath.row >= [sectionData count]) {
            break;
        }
        
        item = [sectionData objectAtIndex:indexPath.row];
    } while (0);
    
    return item;
}

//header footer
- (__kindof HeaderOrFooterViewItem *)headerItemForSection:(NSUInteger)section {
    return [self headerOrFooterViewItemForSection:section kind:Header];
}

- (__kindof HeaderOrFooterViewItem *)footerItemForSection:(NSUInteger)section {
    return [self headerOrFooterViewItemForSection:section kind:Footer];
}

#pragma mark -- optional override property

- (TableViewRelativeHeightHelper *)heightHelper {
    if (nil == _heightHelper) {
        _heightHelper = [[TableViewRelativeHeightHelper alloc] init];
    }
    
    return _heightHelper;
}

#pragma mark -- PrivateProperty

- (NSMutableDictionary *)viewClassMap {
    if (nil == _viewClassMap) {
        _viewClassMap = [[NSMutableDictionary alloc] init];
    }
    
    return _viewClassMap;
}

#pragma mark - PrivateMethod UITableView Handle Method

// section对应的行数
- (NSInteger)numOfRowsInSection:(NSInteger)sectionIndex tableView:(UITableView *)tableView {
    NSInteger numOfRows = 0;
    if (0 <= sectionIndex && sectionIndex < [self.sectionItems count]) {
        TableViewSectionItem *sectionItem = [self.sectionItems objectAtIndex:sectionIndex];
        numOfRows = [sectionItem.cellItems count];
    }
    
    return numOfRows;
}

- (__kindof HeaderOrFooterViewItem *)headerOrFooterViewItemForSection:(NSInteger)section kind:(HeaderOrFooterViewKind)kind {
    HeaderOrFooterViewItem *item = nil;
    do {
        if (section >= [self.sectionItems count]) {
            break;
        }
        
        TableViewSectionItem *sectionItem = [self.sectionItems objectAtIndex:section];
        if (kind == Header) {
            item = sectionItem.headerViewItem;
        } else {
            item = sectionItem.footerViewItem;
        }
    } while (0);
    
    return item;
}

- (Class)cellClassWithItem:(TableViewCellItem *)item {
    Class cellClass = [self.viewClassMap objectForKey:[item className]];
    return cellClass == nil ? [TableViewCell class] : cellClass;
}

- (NSString *)tableViewCellIdentifier:(TableViewCellItem *)item {
    NSString *identifier = [TableViewCell className];
    Class cellClass = [self cellClassWithItem:item];
    if (cellClass && [cellClass isSubclassOfClass:[TableViewCell class]]) {
        identifier = [cellClass className];
    }
    
    return identifier;
}

- (Class)headerOrFooterViewClassWithItem:(HeaderOrFooterViewItem *)item {
    Class cellClass = [self.viewClassMap objectForKey:[item className]];
    return cellClass == nil ? [HeaderOrFooterView class] : cellClass;
}

- (__kindof HeaderOrFooterView *)headerOrFooterViewForSection:(NSInteger)section kind:(HeaderOrFooterViewKind)kind {
    HeaderOrFooterView *headerOrFooterView = nil;
    
    do {
        HeaderOrFooterViewItem *item = [self headerOrFooterViewItemForSection:section kind:kind];
        if (!item) {
            break;
        }
        
        headerOrFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:[item className]];
        [headerOrFooterView setDelegate:self.headerOrFooterViewDelegate];
        [headerOrFooterView setItem:item];
        
    } while (0);
    
    return headerOrFooterView;
}

- (CGFloat)headerOrFooterViewHeightForSection:(NSInteger)section kind:(HeaderOrFooterViewKind)kind tableView:(UITableView *)tableView {
    HeaderOrFooterViewItem *item = [self headerOrFooterViewItemForSection:section kind:kind];
    Class headerOrFooterViewClass = [self headerOrFooterViewClassWithItem:item];
    
    CGFloat height = [self.heightHelper getHeaderOrFooterHeightWithItem:item headerClass:headerOrFooterViewClass];
    
    return height;
}

#pragma-- mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger sectionCount = 1;
    if (tableView == self.tableView) {
        sectionCount = [self.sectionItems count];
    }
    
    return sectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    CGFloat rows =  [self numOfRowsInSection:section tableView:tableView];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = nil;
    TableViewCellItem *item = [self cellItemForIndexPath:indexPath];
    cellIdentifier = [self tableViewCellIdentifier:item];
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (nil == cell) {
        Class cellClass = [self cellClassWithItem:item];
        cell = [[cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setDelegate:self.cellDelegate];
    }
    
    [cell setItem:item];
    
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HeaderOrFooterView *headerView = [self headerOrFooterViewForSection:section kind:Header];
    
    return headerView;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HeaderOrFooterView *footerView = [self headerOrFooterViewForSection:section kind:Footer];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCellItem *item = [self cellItemForIndexPath:indexPath];
    Class cellClass = [self cellClassWithItem:item];
    
    CGFloat height = [self.heightHelper getCellHeightWithItem:item cellClass:cellClass];
    
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [self headerOrFooterViewHeightForSection:section kind:Header tableView:tableView];
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    CGFloat height = [self headerOrFooterViewHeightForSection:section kind:Footer tableView:tableView];
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.didSelectedIndexPathBlcok) {
        self.didSelectedIndexPathBlcok(self, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.willDisplayIndexPathBlock) {
        self.willDisplayIndexPathBlock(self, cell, indexPath);
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(nonnull UITableViewCell *)cell forRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (self.didEndDisplayingIndexPathBlock) {
        self.didEndDisplayingIndexPathBlock(self, cell, indexPath);
    }
}

@end
