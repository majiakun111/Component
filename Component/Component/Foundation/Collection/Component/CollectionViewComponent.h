//
//  CollectionViewComponent.h
//  gifPostModule
//
//  Created by Ansel on 2018/6/20.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "ReusableView.h"

@class CollectionViewCellItem;
@class ReusableViewItem;
@class CollectionViewSectionItem;
@class CollectionViewRelativeSizeHelper;
@class CollectionViewComponent;

NS_ASSUME_NONNULL_BEGIN

typedef void(^CollectionViewComponentDidSelectedIndexPathBlcok)(__kindof CollectionViewComponent *collectionViewComponent, NSIndexPath *indexPath);
typedef void(^CollectionViewComponentWillDisplayIndexPathBlock)(__kindof CollectionViewComponent *collectionViewComponent, __kindof UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef void(^CollectionViewComponentDidEndDisplayingIndexPathBlock)(__kindof CollectionViewComponent *collectionViewComponent, __kindof UICollectionViewCell *cell, NSIndexPath *indexPath);
typedef void(^CollectionViewComponentDidScrollBlock)(__kindof CollectionViewComponent *collectionViewComponent);

@interface CollectionViewComponent : NSObject <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    @protected
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_collectionViewFlowLayout;
}

@property (nonatomic, strong, readonly) UICollectionView *collectionView;
@property(nonatomic, weak) id<CollectionViewCellDelegate> cellDelegate;
@property(nonatomic, weak) id<ReusableViewDelegate> reusableViewDelegate;

//Optional Override Property
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) CollectionViewRelativeSizeHelper *sizeHelper;

@property (nonatomic, strong, readonly) NSMutableArray<__kindof CollectionViewSectionItem *> *sectionItems;

@property (nonatomic, copy) CollectionViewComponentDidSelectedIndexPathBlcok didSelectedIndexPathBlcok;
@property (nonatomic, copy) CollectionViewComponentWillDisplayIndexPathBlock willDisplayIndexPathBlock;
@property (nonatomic, copy) CollectionViewComponentDidEndDisplayingIndexPathBlock didEndDisplayingIndexPathBlock;
@property (nonatomic, copy) CollectionViewComponentDidScrollBlock didScrollBlock;

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock;
- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock
                       delegateBlock:(nullable void (^)(__kindof CollectionViewComponent *collectionViewComponent))delegateBlock;
- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
                     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock
                       delegateBlock:(nullable void (^)(__kindof CollectionViewComponent *collectionViewComponent))delegateBlock NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;

- (void)buildCollectionView;

- (void)updateSectionItems:(NSArray<CollectionViewSectionItem *> *)sectionItems;

//映射CollectionViewCell Class和CollectionViewCellItem ClassName的关系  CollectionViewCellItem或其子类的ClassName作为key CollectionViewCell或其子类的class作为值
- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;

//映射ReuseableView Class和SReuseableViewItem ClassName的关系  以ReuseableViewItem或其子类的ClassName作为key ReuseableView或其子类的class作为值
//kind  UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
- (void)mapReuseableViewClass:(Class)reuseableViewClass reuseableViewItemClass:(Class)reuseableViewItem forKind:(NSString *)kind;

//section
- (__kindof CollectionViewSectionItem *)sectionItemForSectionIndex:(NSInteger)sectionIndex;

- (NSInteger)numOfRowsInSection:(NSInteger)sectionIndex;

//cell item
- (__kindof CollectionViewCellItem *)cellItemForRow:(NSInteger)row inSection:(NSInteger)section;
- (__kindof CollectionViewCellItem *)cellItemForIndexPath:(NSIndexPath *)indexPath;
- (NSArray< __kindof CollectionViewCellItem *> *)cellItemsForSectionIndex:(NSInteger)sectionIndex;

//cell
- (__kindof CollectionViewCell *)cellForRow:(NSInteger)row inSection:(NSInteger)section;
- (__kindof UICollectionViewCell *)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

//ReusableViewItem
- (__kindof ReusableViewItem *)reuseableViewItemForSection:(NSInteger)section kind:(NSString *)kind;

//indexPath
- (NSIndexPath *)indexPathForCellItem:(__kindof CollectionViewCellItem *)cellItem;

#pragma mark - MustOverride
//调用
//- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;
//- (void)mapReuseableViewClass:(Class)headerOrFooterViewClass reuseableViewItem:(Class)reuseableViewItem;
- (void)mapItemClassToViewClass;

@end

NS_ASSUME_NONNULL_END
