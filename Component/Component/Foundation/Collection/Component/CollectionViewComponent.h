//
//  CollectionViewComponent.h
//  gifPostModule
//
//  Created by Ansel on 2018/6/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"

@class CollectionViewCellItem;
@class CollectionViewSectionItem;
@class CollectionViewRelativeSizeHelper;
@class CollectionViewComponent;

typedef void(^CollectionViewComponentDidSelectedIndexPathBlcok)(CollectionViewComponent *collectionViewComponent, NSIndexPath *indexPath);
typedef void(^CollectionViewComponentWillDisplayIndexPathBlock)(CollectionViewComponent *collectionViewComponent, UICollectionViewCell *cell, NSIndexPath *indexPath);

@interface CollectionViewComponent : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CollectionViewCellDelegate>
{
    @protected
    UICollectionViewFlowLayout *_collectionViewFlowLayout;
}

@property (nonatomic, strong, readonly) UICollectionView *collectionView;

//Optional Override Property
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) CollectionViewRelativeSizeHelper *sizeHelper;

@property (nonatomic, strong, readonly) NSArray<__kindof CollectionViewSectionItem *> *sectionItems;

@property (nonatomic, copy) CollectionViewComponentDidSelectedIndexPathBlcok didSelectedIndexPathBlcok;

@property (nonatomic, copy) CollectionViewComponentWillDisplayIndexPathBlock willDisplayIndexPathBlock;

- (instancetype)initWithSectionItems:(NSArray<__kindof CollectionViewSectionItem *> *)sectionItems mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)buildCollectionView;

- (void)updateSectionItems:(NSArray<CollectionViewSectionItem *> *)sectionItems;

//映射CollectionViewCell Class和CollectionViewCellItem ClassName的关系  CollectionViewCellItem或其子类的ClassName作为key CollectionViewCell或其子类的class作为值
- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;

//映射ReuseableView Class和SReuseableViewItem ClassName的关系  以ReuseableViewItem或其子类的ClassName作为key ReuseableView或其子类的class作为值
//kind  UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
- (void)mapReuseableViewClass:(Class)reuseableViewClass reuseableViewItem:(Class)reuseableViewItem forKind:(NSString *)kind;

//section
- (__kindof CollectionViewSectionItem *)sectionItemForSectionIndex:(NSInteger)sectionIndex;

- (NSInteger)numOfRowsInSection:(NSInteger)sectionIndex;

//cell item
- (__kindof CollectionViewCellItem *)cellItemForRow:(NSInteger)row inSection:(NSInteger)section;
- (__kindof CollectionViewCellItem *)cellItemForIndexPath:(NSIndexPath *)indexPath;
- (NSArray< __kindof CollectionViewCellItem *> *)cellItemsForSectionIndex:(NSInteger)sectionIndex;

//cell
- (__kindof UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

//indexPath
- (NSIndexPath *)indexPathForCellItem:(__kindof CollectionViewCellItem *)cellItem;

#pragma mark - MustOverride
//调用
//- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;
//- (void)mapReuseableViewClass:(Class)headerOrFooterViewClass reuseableViewItem:(Class)reuseableViewItem;
- (void)mapItemClassToViewClass;

@end
