//
//  CollectionViewComponent.m
//  gifPostModule
//
//  Created by Ansel on 2018/6/20.
//

#import "CollectionViewComponent.h"
#import <objc/runtime.h>
#import "CollectionViewRelativeSizeHelper.h"
#import "CollectionViewSectionItem.h"
#import "CollectionViewCellItem.h"
#import "CollectionViewCell.h"
#import "ReusableView.h"
#import "ReusableViewItem.h"

#define MustOverride() @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"%s must be overridden in a subclass/category", __PRETTY_FUNCTION__] userInfo:nil]

@interface NSObject (ClassName)

- (NSString *)className;

+ (NSString *)className;

@end

@implementation NSObject (ClassName)

- (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName([self class])];
}

+ (NSString *)className
{
    return [NSString stringWithUTF8String:class_getName(self)];
}

@end

@interface CollectionViewComponent ()

@property(nonatomic, strong) NSMutableArray<__kindof CollectionViewSectionItem *> *sectionItems;
@property(nonatomic, strong) UICollectionView *collectionView;

//1. CollectionViewCellItem或其子类的ClassName作为key CollectionViewCell或其子类的class作为值
//2. 以ReuseableViewItem或其子类的ClassName作为key ReusableView或其子类的class作为值
@property(nonatomic, strong) NSMutableDictionary *viewClassMap;

@property(nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

@end

@implementation CollectionViewComponent

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock {
    return [self initWithSectionItems:sectionItems
                      scrollDirection:UICollectionViewScrollDirectionVertical
         mapItemClassToViewClassBlock:mapItemClassToViewClassBlock delegateBlock:nil];
}

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock
                       delegateBlock:(nullable void (^)(__kindof CollectionViewComponent *collectionViewComponent))delegateBlock {
    return [self initWithSectionItems:sectionItems
                      scrollDirection:UICollectionViewScrollDirectionVertical
         mapItemClassToViewClassBlock:mapItemClassToViewClassBlock
                        delegateBlock:delegateBlock];
}

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
                     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock delegateBlock:(nullable void (^)(__kindof CollectionViewComponent *collectionViewComponent))delegateBlock {
    self = [super init];
    if (self) {
        _sectionItems = [sectionItems mutableCopy];
        _scrollDirection = scrollDirection;
        [self buildCollectionView];
        
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

- (void)buildCollectionView {
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    if (@available(iOS 11.0, *)) {
        [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

-(void)updateSectionItems:(NSArray<CollectionViewSectionItem *> *)sectionItems {
    if (self.sectionItems != sectionItems) {
        self.sectionItems = [sectionItems mutableCopy];
        
        [self.collectionView reloadData];
    }
}

- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass {
    cellClass != nil ? cellClass : [CollectionViewCell class];

    [self.viewClassMap setObject:cellClass forKey:[cellItemClass className]];
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:[cellClass className]];
}

- (void)mapReuseableViewClass:(Class)reuseableViewClass reuseableViewItemClass:(Class)reuseableViewItem forKind:(NSString *)kind {
    [self.viewClassMap setObject:reuseableViewClass forKey:[reuseableViewItem className]];
    
    reuseableViewClass != nil ? reuseableViewClass : [ReusableView class];
    [self.collectionView registerClass:reuseableViewClass forSupplementaryViewOfKind:kind withReuseIdentifier:[reuseableViewClass className]];
}

#pragma mark - CollectionView Handle Method
//section 对应的数据
- (__kindof CollectionViewSectionItem *)sectionItemForSectionIndex:(NSInteger)sectionIndex {
    CollectionViewSectionItem *sectionItem = nil;
    if (0 <= sectionIndex && sectionIndex < [self.sectionItems count]) {
        sectionItem = [self.sectionItems objectAtIndex:sectionIndex];
    }
    
    return sectionItem;
}

- (NSInteger)numOfRowsInSection:(NSInteger)sectionIndex {
    CollectionViewSectionItem *sectionItem = [self sectionItemForSectionIndex:sectionIndex];
    NSInteger numOfRows = [sectionItem.cellItems count];
    return numOfRows;
}

// cell 对应的数据
- (__kindof CollectionViewCellItem *)cellItemForRow:(NSInteger)row inSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return [self cellItemForIndexPath:indexPath];
}

- (__kindof CollectionViewCellItem *)cellItemForIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCellItem *item = nil;
    do {
        CollectionViewSectionItem *sectionItem = [self sectionItemForSectionIndex:indexPath.section];
        if (!sectionItem) {
            break;
        }
        
        NSArray<__kindof CollectionViewCellItem *> *cellItems = sectionItem.cellItems;
        if (indexPath.row >= [cellItems count]) {
            break;
        }
        
        item = [cellItems objectAtIndex:indexPath.row];
    } while (0);
    
    return item;
}

- (NSArray< __kindof CollectionViewCellItem *> *)cellItemsForSectionIndex:(NSInteger)sectionIndex {
    CollectionViewSectionItem *sectionItem = [self sectionItemForSectionIndex:sectionIndex];
    return sectionItem.cellItems;
}

- (__kindof CollectionViewCell *)cellForRow:(NSInteger)row inSection:(NSInteger)section {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    return [self cellForItemAtIndexPath:indexPath];
}

- (__kindof UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

- (__kindof ReusableViewItem *)reuseableViewItemForSection:(NSInteger)section kind:(NSString *)kind {
    ReusableViewItem *item = nil;
    do {
        if (section >= [self.sectionItems count] || section < 0) {
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

//indexPath
- (NSIndexPath *)indexPathForCellItem:(__kindof CollectionViewCellItem *)cellItem {
    __block NSIndexPath *indexPath = nil;
    [self.sectionItems enumerateObjectsUsingBlock:^(__kindof CollectionViewSectionItem * _Nonnull sectionItem, NSUInteger section, BOOL * _Nonnull sectionStop) {
        __block NSInteger row = NSNotFound;
        [sectionItem.cellItems enumerateObjectsUsingBlock:^(__kindof CollectionViewCellItem * _Nonnull tmpItem, NSUInteger tmpRow, BOOL * _Nonnull cellStop) {
            if (cellItem != tmpItem) {
                return;
            }
            
            row = tmpRow;
            *cellStop = YES;
        }];
        
        if (row == NSNotFound) {
            return;
        }
        
        *sectionStop = YES;
        indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    }];
    
    return indexPath;
}

#pragma mark - MustOverride

- (void)mapItemClassToViewClass {
    #ifdef DEBUG
        MustOverride();
    #endif
}

#pragma mark - Optional Override Property

- (UICollectionViewFlowLayout *)collectionViewFlowLayout {
    if (nil == _collectionViewFlowLayout) {
        _collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        [_collectionViewFlowLayout setScrollDirection:self.scrollDirection];
    }
    
    return _collectionViewFlowLayout;
}

#pragma mark - Property

- (CollectionViewRelativeSizeHelper *)sizeHelper {
    if (nil == _sizeHelper) {
        _sizeHelper = [[CollectionViewRelativeSizeHelper alloc] init];
    }
    
    return _sizeHelper;
}

#pragma mark - PrviateProperty

- (NSMutableDictionary *)viewClassMap {
    if (nil == _viewClassMap) {
        _viewClassMap = [[NSMutableDictionary alloc] init];
    }
    
    return _viewClassMap;
}

#pragma mark - PrivateMethod CollectionView Handle Method

- (Class)cellClassWithItem:(CollectionViewCellItem *)item {
    Class cellClass = [self.viewClassMap objectForKey:[item className]];
    return cellClass == nil ? [CollectionViewCell class] : cellClass;
}

- (NSString *)collectionViewCellIdentifier:(CollectionViewCellItem *)item {
    NSString *identifier = [CollectionViewCell className];
    Class cellClass = [self cellClassWithItem:item];
    if (cellClass && [cellClass isSubclassOfClass:[CollectionViewCell class]]) {
        identifier = [cellClass className];
    }
    
    return identifier;
}

- (NSString *)reuseableViewIdentifier:(ReusableViewItem *)item {
    NSString *identifier = [ReusableView className];
    Class reusableViewClass = [self reuseableViewClassWithItem:item];
    
    if (reusableViewClass && [reusableViewClass isSubclassOfClass:[ReusableView class]]) {
        identifier = [reusableViewClass className];
    }
    
    return identifier;
}


- (Class)reuseableViewClassWithItem:(ReusableViewItem *)item {
    Class reuseableViewClass = [self.viewClassMap objectForKey:[item className]];
    return reuseableViewClass == nil ? [ReusableView class] : reuseableViewClass;
}

- (CGSize)reuseableViewSizeForSection:(NSInteger)section kind:(NSString *)kind collectionView:(UICollectionView *)collectionView {
    ReusableViewItem *item = [self reuseableViewItemForSection:section kind:kind];
    Class reuseableViewClass = [self reuseableViewClassWithItem:item];
    
    CGSize size = [self.sizeHelper getReuseableViewSizeWithItem:item reuseableView:reuseableViewClass];
    return size;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    CGFloat sections = [self.sectionItems count];
    return sections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    CGFloat rows = [self numOfRowsInSection:section];
    return rows;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = nil;
    CollectionViewCellItem *item = [self cellItemForIndexPath:indexPath];
    cellIdentifier = [self collectionViewCellIdentifier:item];
    
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell setItem:item];
    [cell setDelegate:self.cellDelegate
     ];
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseableViewIdentifier = nil;
    
    ReusableViewItem *item = [self reuseableViewItemForSection:indexPath.section kind:kind];
    reuseableViewIdentifier = [self reuseableViewIdentifier:item];
    
    ReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseableViewIdentifier forIndexPath:indexPath];
    [reusableView setItem:item];
    [reusableView setDelegate:self.reusableViewDelegate];
    
    return reusableView ? reusableView : [[ReusableView alloc] initWithFrame:CGRectZero];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.willDisplayIndexPathBlock) {
        self.willDisplayIndexPathBlock(self, cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.didEndDisplayingIndexPathBlock) {
        self.didEndDisplayingIndexPathBlock(self, cell, indexPath);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (self.didSelectedIndexPathBlcok) {
        self.didSelectedIndexPathBlcok(self, indexPath);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCellItem *item = [self cellItemForIndexPath:indexPath];
    Class cellClass = [self cellClassWithItem:item];
    
    CGSize size = [self.sizeHelper getCellSizetWithItem:item cellClass:cellClass];
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize size = [self reuseableViewSizeForSection:section kind:UICollectionElementKindSectionHeader collectionView:collectionView];
    return size;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize size = [self reuseableViewSizeForSection:section kind:UICollectionElementKindSectionFooter collectionView:collectionView];
    return size;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CollectionViewSectionItem *item = [self sectionItemForSectionIndex:section];
    return item.inset;
}

//调整列的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CollectionViewSectionItem *item = [self sectionItemForSectionIndex:section];
    return item.minimumInteritemSpacing;
}

//调整行的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    CollectionViewSectionItem *item = [self sectionItemForSectionIndex:section];
    return item.minimumLineSpacing;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.didScrollBlock) {
        self.didScrollBlock(self);
    }
}

@end
