//
//  CollectionViewController.m
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "CollectionViewController.h"
#import "SizeDefine.h"
#import "CommonDefine.h"
#import "NSObject+ClassName.h"

#import "CollectionViewRelativeSizeHelper.h"
#import "CollectionViewSectionItem.h"
#import "CollectionViewCellItem.h"
#import "ReusableView.h"
#import "ReusableViewItem.h"

@interface CollectionViewController ()

//1. CollectionViewCellItem 的ClassName作为key CollectionViewCell或其子类的class作为值
//2. 以ReuseableViewItem的ClassName作为key ReusableView或其子类的class作为值
@property (nonatomic, strong) NSMutableDictionary *viewClassMap;

@end

@implementation CollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self buildCollectionView];
    [self mapItemClassToViewClass];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.contentInset = UIEdgeInsetsZero;
}

- (void)buildUI
{
    [self setAutomaticallyAdjustsScrollViewInsets:NO];

    [self buildCollectionView];
}

- (void)buildCollectionView
{
    CGRect rect = CGRectZero;
    if (self.navigationController) {
        rect = CGRectMake(0, STATUS_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_HEIGHT - NAVIGATION_BAR_HEIGHT);
    }
    else {
        rect = CGRectMake(0, STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    }
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:self.collectionViewFlowLayout];
    [self.collectionView  setBackgroundColor:[UIColor clearColor]];
    [self.collectionView  setDelegate:self];
    [self.collectionView  setDataSource:self];
    
    [self.view addSubview:self.collectionView];
}

- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass
{
    [self.viewClassMap setObject:cellClass forKey:[cellItemClass className]];
 
    cellClass != nil ? cellClass : [CollectionViewCell class];
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:[cellClass className]];
}

- (void)mapReuseableViewClass:(Class)reuseableViewClass reuseableViewItem:(Class)reuseableViewItem forKind:(NSString *)kind
{
    [self.viewClassMap setObject:reuseableViewClass forKey:[reuseableViewItem className]];
    
    reuseableViewClass != nil ? reuseableViewClass : [ReusableView class];
    [self.collectionView registerClass:reuseableViewClass forSupplementaryViewOfKind:kind   withReuseIdentifier:[reuseableViewClass className]];
}

#pragma mark - MustOverride

- (void)mapItemClassToViewClass
{
#ifdef DEBUG
    MustOverride();
#endif
}

#pragma mark - optional override property

- (UICollectionViewFlowLayout *)collectionViewFlowLayout
{
    if (nil == _collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [_collectionViewFlowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    }
    
    return _collectionViewFlowLayout;
}

#pragma mark - property

-(NSMutableArray<CollectionViewSectionItem *> *)sectionItems
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

- (CollectionViewRelativeSizeHelper *)sizeHelper
{
    if (nil == _sizeHelper) {
        _sizeHelper = [[CollectionViewRelativeSizeHelper alloc] init];
    }
    
    return _sizeHelper;
}

#pragma mark - PrivateMethod Property CollectionView Handle Method

- (__kindof CollectionViewSectionItem *)sectionItemForSectionIndex:(NSInteger)sectionIndex
{
    CollectionViewSectionItem *sectionItem = nil;
    if (0 <= sectionIndex && sectionIndex < [self.sectionItems count]) {
        sectionItem = [self.sectionItems objectAtIndex:sectionIndex];
    }
    
    return sectionItem;
}

// section对应的行数
- (NSInteger)numOfRowsInSection:(NSInteger)sectionIndex
{
    CollectionViewSectionItem *sectionItem = [self sectionItemForSectionIndex:sectionIndex];
    NSInteger numOfRows = [sectionItem.cellItems count];
    return numOfRows;
}

// cell 对应的数据
- (__kindof CollectionViewCellItem *)cellItemForIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCellItem *item = nil;
    do {
        CollectionViewSectionItem *sectionItem = [self sectionItemForSectionIndex:indexPath.section];
        if (!sectionItem) {
            break;
        }
        
        NSMutableArray *sectionData = sectionItem.cellItems;
        if (indexPath.row >= [sectionData count]) {
            break;
        }
        
        item = [sectionData objectAtIndex:indexPath.row];
    } while (0);
    
    return item;
}

- (Class)cellClassWithItem:(CollectionViewCellItem *)item
{
    Class cellClass = [self.viewClassMap objectForKey:[item className]];
    return cellClass == nil ? [CollectionViewCell class] : cellClass;
}

- (NSString *)collectionViewCellIdentifier:(CollectionViewCellItem *)item
{
    NSString *identifier = [CollectionViewCell className];
    Class cellClass = [self cellClassWithItem:item];
    if (cellClass && [cellClass isSubclassOfClass:[CollectionViewCell class]]) {
        identifier = [cellClass className];
    }
    
    return identifier;
}

- (NSString *)reuseableViewIdentifier:(ReusableViewItem *)item
{
    NSString *identifier = [ReusableView className];
    Class reusableViewClass = [self reuseableViewClassWithItem:item];
    
    if (reusableViewClass && [reusableViewClass isSubclassOfClass:[ReusableView class]]) {
        identifier = [reusableViewClass className];
    }
    
    return identifier;
}


- (Class)reuseableViewClassWithItem:(ReusableViewItem *)item
{
    Class reuseableViewClass = [self.viewClassMap objectForKey:[item className]];
    return reuseableViewClass == nil ? [ReusableView class] : reuseableViewClass;
}

- (__kindof ReusableViewItem *)reuseableViewItemForSection:(NSInteger)section kind:(NSString *)kind collectionView:(UICollectionView *)collectionView
{
    ReusableViewItem *item = nil;
    do {
        if (section >= [self.sectionItems count]) {
            break;
        }
        
        CollectionViewSectionItem *sectionItem = [self.sectionItems objectAtIndex:section];
        if ([kind isEqual:UICollectionElementKindSectionHeader]) {
            item = sectionItem.headerViewItem;
        } else if ([kind isEqual:UICollectionElementKindSectionFooter]) {
            item = sectionItem.footerViewItem;
        }

    } while (0);
    
    return item;
}

- (CGSize)reuseableViewSizeForSection:(NSInteger)section kind:(NSString *)kind collectionView:(UICollectionView *)collectionView
{
    ReusableViewItem *item = [self reuseableViewItemForSection:section kind:kind collectionView:collectionView];
    Class reuseableViewClass = [self reuseableViewClassWithItem:item];
    
    CGSize size = [self.sizeHelper getReuseableViewSizeWithItem:item reuseableView:reuseableViewClass];
    return size;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    CGFloat sections = [self.sectionItems count];
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    CGFloat rows = [self numOfRowsInSection:section];
    return rows;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = nil;
    CollectionViewCellItem *item = [self cellItemForIndexPath:indexPath];
    cellIdentifier = [self collectionViewCellIdentifier:item];
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setItem:item];
    [cell setDelegate:self];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseableViewIdentifier = nil;

    ReusableViewItem *item = [self reuseableViewItemForSection:indexPath.section kind:kind collectionView:collectionView];
    reuseableViewIdentifier = [self reuseableViewIdentifier:item];
    
    ReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseableViewIdentifier forIndexPath:indexPath];
    [reusableView setItem:item];
    
    return reusableView ? reusableView : [[ReusableView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark --UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionViewCellItem *item = [self cellItemForIndexPath:indexPath];
    Class cellClass = [self cellClassWithItem:item];
    
    CGSize size = [self.sizeHelper getCellSizetWithItem:item cellClass:cellClass];
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    CGSize size = [self reuseableViewSizeForSection:section kind:UICollectionElementKindSectionHeader collectionView:collectionView];
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    CGSize size = [self reuseableViewSizeForSection:section kind:UICollectionElementKindSectionFooter collectionView:collectionView];
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    CollectionViewSectionItem *item = [self sectionItemForSectionIndex:section];
    return item.inset;
}

//调整列的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    CollectionViewSectionItem *item = [self sectionItemForSectionIndex:section];
    return item.minimumInteritemSpacing;
}

//调整行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    CollectionViewSectionItem *item = [self sectionItemForSectionIndex:section];
    return item.minimumLineSpacing;
}

@end
