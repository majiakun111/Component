//
//  NestCollectionViewComponent.m
//  Component
//
//  Created by Ansel on 2019/7/26.
//  Copyright © 2019 MJK. All rights reserved.
//

#import "NestCollectionViewComponent.h"
#import "Masonry.h"
#import "PageTitleView.h"

//Page Section header
@implementation NestPageContainerReusableViewItem

@end

@interface NestPageContainerReusableView ()

@property(nonatomic, strong) PageTitleView *pageTitleView;

@end

@implementation NestPageContainerReusableView

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
    
    NestPageContainerReusableViewItem *item = self.item;
    if (!_pageTitleView) {
        _pageTitleView = [[PageTitleView alloc] initWithTitles:item.titles];
        [self addSubview:_pageTitleView];
        [_pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        __weak typeof(self) weakSelf = self;
        [_pageTitleView setCurrentIndexChangedBlock:^(NSUInteger currentIndex) {
            if ([(id<NestPageContainerReusableViewDelegate>)weakSelf.delegate respondsToSelector:@selector(reusableView:pageTitleCurrentIndex:)]) {
                [(id<NestPageContainerReusableViewDelegate>)weakSelf.delegate reusableView:weakSelf pageTitleCurrentIndex:currentIndex];
            }
        }];
        [_pageTitleView setBackgroundColor:[UIColor clearColor]];
    }
    
    [_pageTitleView updateIndexProgress:item.indexProgress animated:YES];
}

#pragma mark - PrivateNotification

- (void)addObserver {
    NestPageContainerReusableViewItem *item = self.item;
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(indexProgress)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    NestPageContainerReusableViewItem *item = self.item;
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(indexProgress))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NestPageContainerReusableViewItem *item = self.item;
        if (object == item) {
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(indexProgress))]) {
                [self.pageTitleView updateIndexProgress:item.indexProgress animated:YES];
            }
        }
    });
}


@end

//Page Container  Section Cell

@implementation NestPageContainerCellItem

@end

@interface NestPageContainerCell ()

@property(nonatomic, strong) NestPageContainerViewController *pageContianerViewController;

@end

@implementation NestPageContainerCell

- (void)dealloc {
    [self removeObserver];
}

#pragma mark - Override

- (void)setItem:(__kindof CollectionViewCellItem *)item {
    if (_item == item) {
        return;
    }
    
    [self removeObserver];
    
    _item = item;
    
    [self addObserver];
    
    [self updateUI];
}

- (void)updateUI {
    [super updateUI];
    
    NestPageContainerCellItem *item = self.item;
    if ([self.pageContianerViewController parentViewController]) {
        [self.pageContianerViewController willMoveToParentViewController:nil];
        if (self.pageContianerViewController.isViewLoaded && [self.pageContianerViewController.view superview]) {
            [self.pageContianerViewController.view removeFromSuperview];
        }
        [self.pageContianerViewController removeFromParentViewController];
        [self.pageContianerViewController didMoveToParentViewController:nil];
    }
    
    if (item.parentViewController) {
        [self.pageContianerViewController willMoveToParentViewController:item.parentViewController];
        [item.parentViewController addChildViewController:self.pageContianerViewController];
        [self.contentView addSubview:self.pageContianerViewController.view];
        [self.pageContianerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        [self.pageContianerViewController didMoveToParentViewController:item.parentViewController];
    }
    
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
            if ([(id<NestPageContainerCellDelegate>)weakSelf.delegate respondsToSelector:@selector(collectionViewCell:pageContainerViewControllerScrollToContentOffset:)]) {
                [(id<NestPageContainerCellDelegate>)weakSelf.delegate collectionViewCell:weakSelf pageContainerViewControllerScrollToContentOffset:contentOffset];
            }
        }];
        [_pageContianerViewController setPageContainerWillLeaveTopBlock:^{
            if ([(id<NestPageContainerCellDelegate>)weakSelf.delegate respondsToSelector:@selector(pageContainerViewControllerWillLeaveTopForCollectionViewCell:)]) {
                [(id<NestPageContainerCellDelegate>)weakSelf.delegate pageContainerViewControllerWillLeaveTopForCollectionViewCell:weakSelf];
            }
        }];
    }
    
    return _pageContianerViewController;
}

#pragma mark - PrivateNotification

- (void)addObserver {
    NestPageContainerCellItem *item = self.item;
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(canUpDownScroll)) options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(pageIndex)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    NestPageContainerCellItem *item = self.item;
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(canUpDownScroll))];
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(pageIndex))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NestPageContainerCellItem *item = self.item;
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

@property (nonatomic, weak) UICollectionView *collectionView;

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
    } else {
        if (!self.canUpDownScroll) {//子视图没到顶部
            self.collectionView.contentOffset = CGPointMake(0, bottomSectionOffset);
        }
    }
    
    self.collectionView.showsVerticalScrollIndicator = self.canUpDownScroll;
}

@end
