//
//  NestCollectionViewComponent.h
//  Component
//
//  Created by Ansel on 2019/7/26.
//  Copyright © 2019 MJK. All rights reserved.
//

#import "CollectionViewComponent.h"
#import "CollectionViewComponent.h"
#import "CollectionViewSectionItem.h"
#import "CollectionViewCell.h"
#import "CollectionViewCellItem.h"
#import "ReusableView.h"
#import "ReusableViewItem.h"
#import "PageContainerItem.h"

@class NestPageContainerReusableView;
@class NestPageContainerCell;

NS_ASSUME_NONNULL_BEGIN

typedef void(^NestCollectionViewPageContainerCellCanScrollBlock)(BOOL collectionViewPageContainerCellCanScroll);

//总共两个section

//顶部section Cell 可以有很多个 都是CollectionViewCell的子类

//低部section
//Page Container Section HeaderView 只有一个
@interface NestPageContainerReusableViewItem : ReusableViewItem

@property(nonatomic, assign) CGFloat indexProgress;
@property(nonatomic, copy) NSArray<NSString *> *titles;

@end

@protocol NestPageContainerReusableViewDelegate <ReusableViewDelegate>

- (void)reusableView:(NestPageContainerReusableView *)reusableView pageTitleCurrentIndex:(NSInteger)pageTitleCurrentIndex;

@end

@interface NestPageContainerReusableView : ReusableView

@end

//Page Container Section Cell 只有一个
@interface NestPageContainerCellItem : CollectionViewCellItem

@property(nonatomic, assign) BOOL canUpDownScroll;
@property(nonatomic, assign) NSUInteger pageIndex;

@property(nonatomic, strong) PageContainerItem *pageContainerItem;

//特殊
@property(nonatomic, strong) UIViewController *parentViewController;

@end

@protocol NestPageContainerCellDelegate <CollectionViewCellDelegate>

- (void)collectionViewCell:(NestPageContainerCell *)collectionViewCell pageContainerViewControllerScrollToContentOffset:(CGPoint)contentOffset;

- (void)pageContainerViewControllerWillLeaveTopForCollectionViewCell:(NestPageContainerCell *)collectionViewCell;

@end

@interface NestPageContainerCell : CollectionViewCell

@end

@interface NestCollectionView : UICollectionView

@end

@interface NestCollectionViewComponent : CollectionViewComponent

@property(nonatomic, assign) BOOL canUpDownScroll;

@property(nonatomic, copy) NestCollectionViewPageContainerCellCanScrollBlock collectionViewPageContainerCellCanScrollBlock;

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithSectionItems:(nullable NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
                     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
        mapItemClassToViewClassBlock:(void (^)(__kindof CollectionViewComponent *collectionViewComponent))mapItemClassToViewClassBlock
                       delegateBlock:(nullable void (^)(__kindof CollectionViewComponent *collectionViewComponent))delegateBlock NS_UNAVAILABLE;


@end

NS_ASSUME_NONNULL_END
