//
//  CollectionViewNestPageContainerViewControllerViewController.m
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "NestCollectionViewController.h"
#import "Masonry.h"
#import "PageTitleView.h"

NSInteger const NestCollectionViewPageContainerCellRow = 0;

//Header Section
@implementation NestCollectionViewHeaderSectionCellItem

@end

@implementation NestCollectionViewHeaderSectionCell

@end

//Page Section header
@implementation NestCollectionViewPageContainerSectionHeaderViewItem

@end

@interface NestCollectionViewPageContainerSectionHeaderView ()

@property(nonatomic, strong) PageTitleView *pageTitleView;

@end

@implementation NestCollectionViewPageContainerSectionHeaderView

- (void)dealloc {
    [self removeObserver];
}

- (void)setItem:(__kindof ReusableViewItem *)item {
    [self removeObserver];
    
    _item = item;
    
    [self addObserver];
    
    [self updateUI];
}

- (void)updateUI {
    [super updateUI];
    
    NestCollectionViewPageContainerSectionHeaderViewItem *item = self.item;
    if (!_pageTitleView) {
        _pageTitleView = [[PageTitleView alloc] initWithTitles:item.titles];
        [self addSubview:_pageTitleView];
        [_pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        __weak typeof(self) weakSelf = self;
        [_pageTitleView setCurrentIndexChangedBlock:^(NSUInteger currentIndex) {
            if ([(id<NestCollectionViewPageContainerSectionHeaderViewDelegate>)weakSelf.delegate respondsToSelector:@selector(headerView:pageTitleCurrentIndex:)]) {
                [(id<NestCollectionViewPageContainerSectionHeaderViewDelegate>)weakSelf.delegate headerView:weakSelf pageTitleCurrentIndex:currentIndex];
            }
        }];
        [_pageTitleView setBackgroundColor:[UIColor clearColor]];
    }
    
    [_pageTitleView updateIndexProgress:item.indexProgress animated:YES];
}

#pragma mark - PrivateNotification

- (void)addObserver {
    NestCollectionViewPageContainerSectionHeaderViewItem *item = self.item;
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(indexProgress)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    NestCollectionViewPageContainerSectionHeaderViewItem *item = self.item;
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(indexProgress))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NestCollectionViewPageContainerSectionHeaderViewItem *item = self.item;
        if (object == item) {
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(indexProgress))]) {
                [self.pageTitleView updateIndexProgress:item.indexProgress animated:YES];
            }
        }
    });
}


@end

//bottom Section Cell
@implementation NestCollectionViewPageContainerSectionCellItem

@end

@interface NestCollectionViewPageContainerSectionCell ()

@property(nonatomic, strong) NestPageContainerViewController *pageContianerViewController;

@end

@implementation NestCollectionViewPageContainerSectionCell

- (void)dealloc {
    [self removeObserver];
}

- (void)setParentViewController:(UIViewController *)parentViewController {
    if (_parentViewController == parentViewController) {
        return;
    }
    
    if (_parentViewController) {
        if (self.pageContianerViewController.isViewLoaded && [self.pageContianerViewController.view superview]) {
            [self.pageContianerViewController.view removeFromSuperview];
        }
        [self.pageContianerViewController removeFromParentViewController];
    }
    
    _parentViewController = parentViewController;
    
    if (parentViewController) {
        [parentViewController addChildViewController:self.pageContianerViewController];
        [self addSubview:self.pageContianerViewController.view];
        
        [self.pageContianerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

#pragma mark - Override

- (void)setItem:(__kindof CollectionViewCellItem *)item {
    [self removeObserver];
    
    _item = item;
    
    [self addObserver];
    
    [self updateUI];
}

- (void)buildUI {
    [super buildUI];
    
    [self.contentView addSubview:self.pageContianerViewController.view];
    [self.pageContianerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)updateUI {
    [super updateUI];
    
    NestCollectionViewPageContainerSectionCellItem *item = self.item;
    [self.pageContianerViewController setPageContainerItem:item.pageContainerItem];
    [self.pageContianerViewController setPageCanUpDownScroll:item.canUpDownScroll];
    [self.pageContianerViewController setPageIndex:item.pageIndex animated:NO];
}

#pragma mark - PrivateProperty

- (NestPageContainerViewController *)pageContianerViewController {
    if (nil == _pageContianerViewController) {
        _pageContianerViewController = [[NestPageContainerViewController alloc] initWithPageContainerItem:nil];
        __weak typeof(self) weakSelf = self;
        [_pageContianerViewController setContentOffsetDidChangeBlock:^(CGPoint contentOffset) {
            if ([(id<NestCollectionViewPageContainerSectionCellDelegate>)weakSelf.delegate respondsToSelector:@selector(collectionViewCell:pageContainerViewControllerScrollToContentOffset:)]) {
                [(id<NestCollectionViewPageContainerSectionCellDelegate>)weakSelf.delegate collectionViewCell:weakSelf pageContainerViewControllerScrollToContentOffset:contentOffset];
            }
        }];
        [_pageContianerViewController setPageContainerWillLeaveTopBlock:^{
            if ([(id<NestCollectionViewPageContainerSectionCellDelegate>)weakSelf.delegate respondsToSelector:@selector(pageContainerViewControllerWillLeaveTopForCollectionViewCell:)]) {
                [(id<NestCollectionViewPageContainerSectionCellDelegate>)weakSelf.delegate pageContainerViewControllerWillLeaveTopForCollectionViewCell:weakSelf];
            }
        }];
    }
    
    return _pageContianerViewController;
}

#pragma mark - PrivateNotification

- (void)addObserver {
    NestCollectionViewPageContainerSectionCellItem *item = self.item;
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(canUpDownScroll)) options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(pageIndex)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    NestCollectionViewPageContainerSectionCellItem *item = self.item;
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(canUpDownScroll))];
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(pageIndex))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NestCollectionViewPageContainerSectionCellItem *item = self.item;
        if (object == item) {
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(canUpDownScroll))]) {
                [self.pageContianerViewController setPageCanUpDownScroll:item.canUpDownScroll];
            } else if ([keyPath isEqualToString:NSStringFromSelector(@selector(pageIndex))]) {
                [self.pageContianerViewController setPageIndex:item.pageIndex animated:YES];
            }
        }
    });
}

@end

@interface NestCollectionView () <UIGestureRecognizerDelegate>

@end

//collectionView
@implementation NestCollectionView

#pragma mark - UIGestureRecognizerDelegate
/**
 同时识别多个手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@interface CollectionViewComponent (Private)

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation NestCollectionViewComponent

#pragma mark - Override

- (instancetype)initWithSectionItems:(NSArray<__kindof CollectionViewSectionItem *> *)sectionItems
                     scrollDirection:(UICollectionViewScrollDirection)scrollDirection
        mapItemClassToViewClassBlock:(nonnull void (^)(__kindof CollectionViewComponent * _Nonnull))mapItemClassToViewClassBlock
                       delegateBlock:(nullable void (^)(__kindof CollectionViewComponent * _Nonnull))delegateBlock {
    self = [super initWithSectionItems:sectionItems
                       scrollDirection:scrollDirection
          mapItemClassToViewClassBlock:mapItemClassToViewClassBlock
                         delegateBlock:delegateBlock];
    if (self) {
        self.canUpDownScroll = YES;
    }
    
    return self;
}

- (void)buildCollectionView {
    self.collectionView = [[NestCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewFlowLayout];
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    if (@available(iOS 11.0, *)) {
        [self.collectionView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger PageContainerSection = [self.sectionItems count] - 1;
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForRow:0 inSection:PageContainerSection > 0 ? PageContainerSection : 0]];
    CGFloat bottomSectionOffset = attributes.frame.origin.y;
    if (self.collectionView.contentOffset.y >= bottomSectionOffset) {
        self.collectionView.contentOffset = CGPointMake(0, bottomSectionOffset);

        if (self.canUpDownScroll) {
            self.canUpDownScroll = NO;
            if (self.collectionViewPageContainerCellCanScrollBlock) {
                self.collectionViewPageContainerCellCanScrollBlock(YES);
            }
        }
    }else{
        if (!self.canUpDownScroll) {//子视图没到顶部
            self.collectionView.contentOffset = CGPointMake(0, bottomSectionOffset);
        }
    }

    self.collectionView.showsVerticalScrollIndicator = self.canUpDownScroll;
}

@end

@interface NestCollectionViewController ()<NestCollectionViewPageContainerSectionHeaderViewDelegate, NestCollectionViewPageContainerSectionCellDelegate>

@property(nonatomic, strong) NestCollectionViewComponent *collectionViewComponent;
@property(nonatomic, strong) NSArray<__kindof CollectionViewSectionItem *> *sectionItems;

@end

@implementation NestCollectionViewController

- (instancetype)initWithSectioItems:(NSArray<__kindof CollectionViewSectionItem *> *)sectionItems {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _sectionItems = sectionItems;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)buildCollectionViewComponent {
    __weak typeof(self) weakSelf = self;
    self.collectionViewComponent = [[NestCollectionViewComponent alloc] initWithSectionItems:self.sectionItems mapItemClassToViewClassBlock:^(__kindof CollectionViewComponent *collectionViewComponent) {
        [self mapItemClassToViewClassWithCollectionViewComponent:collectionViewComponent];
    } delegateBlock:^(__kindof CollectionViewComponent *collectionViewComponent) {
        collectionViewComponent.cellDelegate = weakSelf;
        collectionViewComponent.reusableViewDelegate = weakSelf;
    }];
    
    [self.collectionViewComponent setWillDisplayIndexPathBlock:^(__kindof CollectionViewComponent *CollectionViewComponent, __kindof UICollectionViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf collectionViewComponent:CollectionViewComponent willDisplayCell:cell forItemAtIndexPath:indexPath];
    }];
    [self.collectionViewComponent setDidEndDisplayingIndexPathBlock:^(__kindof CollectionViewComponent *CollectionViewComponent, __kindof UICollectionViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf collectionViewComponent:CollectionViewComponent didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }];
    [self.collectionViewComponent setCollectionViewPageContainerCellCanScrollBlock:^(BOOL collectionViewPageContainerCellCanScroll) {
        [weakSelf updateCollectionViewPageContainerCellCanScroll:collectionViewPageContainerCellCanScroll];
    }];
    
    [self.view addSubview:self.collectionViewComponent.collectionView];
    [self.collectionViewComponent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[NestCollectionViewPageContainerSectionCell class] cellItemClass:[NestCollectionViewPageContainerSectionCellItem class]];
    
    [collectionViewComponent mapReuseableViewClass:[NestCollectionViewPageContainerSectionHeaderView class] reuseableViewItemClass:[NestCollectionViewPageContainerSectionHeaderViewItem class] forKind:UICollectionElementKindSectionHeader];
}

- (void)collectionViewComponent:(__kindof CollectionViewComponent *)collectionViewComponent willDisplayCell:(__kindof UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[NestCollectionViewPageContainerSectionCell class]]) {
        NestCollectionViewPageContainerSectionCell *pageContainerCell = cell;
        [pageContainerCell setParentViewController:self];
    }
}

- (void)collectionViewComponent:(__kindof CollectionViewComponent *)collectionViewComponent didEndDisplayingCell:(__kindof UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[NestCollectionViewPageContainerSectionCell class]]) {
        NestCollectionViewPageContainerSectionCell *pageContainerCell = cell;
        [pageContainerCell setParentViewController:nil];
    }
}

#pragma mark - NestCollectionViewPageContainerSectionHeaderViewDelegate

- (void)headerView:(NestCollectionViewPageContainerSectionHeaderView *)headerView pageTitleCurrentIndex:(NSInteger)pageTitleCurrentIndex {
    NestCollectionViewPageContainerSectionCellItem *cellItem = [self.collectionViewComponent cellItemForRow:NestCollectionViewPageContainerCellRow inSection:[self.sectionItems count] - 1];
    cellItem.pageIndex = pageTitleCurrentIndex;
}

#pragma mark - NestCollectionViewPageContainerSectionCellDelegate

- (void)collectionViewCell:(NestCollectionViewPageContainerSectionCell *)collectionViewCell pageContainerViewControllerScrollToContentOffset:(CGPoint)contentOffset {
    NestCollectionViewPageContainerSectionHeaderViewItem *headerViewItem = [self.collectionViewComponent reuseableViewItemForSection:[self.sectionItems count] - 1 kind:UICollectionElementKindSectionHeader];
    headerViewItem.indexProgress = contentOffset.x / self.view.bounds.size.width;
}

- (void)pageContainerViewControllerWillLeaveTopForCollectionViewCell:(NestCollectionViewPageContainerSectionCell *)collectionViewCell {
    [self.collectionViewComponent setCanUpDownScroll:YES];
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self buildCollectionViewComponent];
}

#pragma mark - PrivateMethod

- (void)updateCollectionViewPageContainerCellCanScroll:(BOOL)collectionViewPageContainerCellCanScroll {
    NestCollectionViewPageContainerSectionCellItem *item = [self.collectionViewComponent cellItemForRow:NestCollectionViewPageContainerCellRow inSection:[self.sectionItems count] - 1];
    item.canUpDownScroll = collectionViewPageContainerCellCanScroll;
}

@end
