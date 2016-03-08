//
//  CollectionViewController.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"

@class CollectionViewSectionItem;
@class CollectionViewRelativeSizeHelper;

@interface CollectionViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, CollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <CollectionViewSectionItem *> *sectionItems;

//optional override property
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionViewFlowLayout;

@property (nonatomic, strong) CollectionViewRelativeSizeHelper *sizeHelper;

- (void)buildUI;

- (void)buildCollectionView;

//映射CollectionViewCell Class和TableViewSectionItem ClassName的关系  以CollectionViewSectionItem 的ClassName作为key CollectionViewCell或其子类的class作为值
- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;

//映射ReuseableView Class和ReuseableViewItem ClassName的关系  以ReuseableViewItem的ClassName作为key ReuseableView或其子类的class作为值
//kind  UICollectionElementKindSectionHeader or UICollectionElementKindSectionFooter
//
- (void)mapReuseableViewClass:(Class)reuseableViewClass reuseableViewItem:(Class)reuseableViewItem forKind:(NSString *)kind;

#pragma mark - MustOverride
//调用
//- (void)mapCellClass:(Class)cellClass cellItemClass:(Class)cellItemClass;
//- (void)mapReuseableViewClass:(Class)headerOrFooterViewClass reuseableViewItem:(Class)reuseableViewItem;
- (void)mapItemClassToViewClass;

@end
