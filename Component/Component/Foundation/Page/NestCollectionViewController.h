//
//  CollectionViewNestPageContainerViewControllerViewController.h
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewComponent.h"
#import "CollectionViewSectionItem.h"
#import "CollectionViewCell.h"
#import "CollectionViewCellItem.h"
#import "ReusableView.h"
#import "ReusableViewItem.h"
#import "PageContainerItem.h"
#import "NestPageContainerViewController.h"

@class NestCollectionViewBottomSectionHeaderView;
@class NestCollectionViewBottomSectionCell;

NS_ASSUME_NONNULL_BEGIN

typedef void(^NestCollectionViewBottomCellCanScrollBlock)(BOOL collectionViewBottomCellCanScroll);

@protocol NestCollectionViewBottomSectionHeaderViewDelegate <ReusableViewDelegate>

- (void)headerView:(NestCollectionViewBottomSectionHeaderView *)headerView pageTitleCurrentIndex:(NSInteger)pageTitleCurrentIndex;

@end

@protocol NestCollectionViewBottomSectionCellDelegate <CollectionViewCellDelegate>

- (void)collectionViewCell:(NestCollectionViewBottomSectionCell *)collectionViewCell pageContainerViewControllerScrollToContentOffset:(CGPoint)contentOffset;

- (void)pageContainerViewControllerWillLeaveTopForCollectionViewCell:(NestCollectionViewBottomSectionCell *)collectionViewCell;

@end

//总共两个section

//顶部section
//Top Section Cell 可以有很多个
@interface NestCollectionViewTopSectionCellItem : CollectionViewCellItem

@end

@interface  NestCollectionViewTopSectionCell : CollectionViewCell

@end

//低部section
//Bottom Section HeaderView 只有一个
@interface NestCollectionViewBottomSectionHeaderViewItem : ReusableViewItem

@property(nonatomic, assign) CGFloat indexProgress;
@property(nonatomic, copy) NSArray<NSString *> *titles;

@end

@interface NestCollectionViewBottomSectionHeaderView : ReusableView

@end

//Bottom Section Cell 只有一个
@interface NestCollectionViewBottomSectionCellItem : CollectionViewCellItem

@property(nonatomic, assign) BOOL canUpDownScroll;
@property(nonatomic, assign) NSUInteger pageIndex;

@property(nonatomic, strong) PageContainerItem *pageContainerItem;

@end

@interface NestCollectionViewBottomSectionCell : CollectionViewCell

@property(nonatomic, strong, nullable) UIViewController *parentViewController;

@end

@interface NestCollectionView : UICollectionView

@end

@interface NestCollectionViewComponent : CollectionViewComponent

@property(nonatomic, assign) BOOL canUpDownScroll;

@property(nonatomic, copy) NestCollectionViewBottomCellCanScrollBlock collectionViewBottomCellCanScrollBlock;

@end

@interface NestCollectionViewController : UIViewController

- (instancetype)initWithSectioItems:(NSArray<__kindof CollectionViewSectionItem *> *)sectionItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent;
- (void)collectionViewComponent:(__kindof CollectionViewComponent *)collectionViewComponent willDisplayCell:(__kindof UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)collectionViewComponent:(__kindof CollectionViewComponent *)collectionViewComponent didEndDisplayingCell:(__kindof UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
