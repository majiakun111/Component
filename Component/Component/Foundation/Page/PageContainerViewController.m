//
//  PageViewController.m
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "PageContainerViewController.h"
#import "CollectionViewComponent.h"
#import "CollectionViewCell.h"
#import "CollectionViewCellItem.h"
#import "Masonry.h"

NSInteger const DefaultCurrentPageIndex = 0;

@interface PageCollectionViewCellItem : CollectionViewCellItem

@property(nonatomic, strong) PageItem *pageItem;

@property(nonatomic, strong) UIViewController<PageItemProtocol> *paegVieController;
@property(nonatomic, weak) UIViewController *parentViewController;

@end

@implementation PageCollectionViewCellItem

@end

@interface PageCollectionViewCell : CollectionViewCell

@property(nonatomic, strong) UIViewController *viewController;

@end

@implementation PageCollectionViewCell

- (void)setViewController:(UIViewController *)viewController {
    if (_viewController == viewController) {
        return;
    }
    
    UIViewController *lastViewController = _viewController;
    if (lastViewController) {
        [lastViewController willMoveToParentViewController:nil];
        if (lastViewController.isViewLoaded && [lastViewController.view superview]) {
            [lastViewController.view removeFromSuperview];
        }
        [lastViewController removeFromParentViewController];
        [lastViewController didMoveToParentViewController:nil];
    }
    
    _viewController = viewController;
    PageCollectionViewCellItem *cellItem = self.item;
    if (viewController) {
        [viewController willMoveToParentViewController:cellItem.parentViewController];
        [cellItem.parentViewController addChildViewController:viewController];
        [self.contentView addSubview:viewController.view];
        [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
        
        [viewController didMoveToParentViewController:cellItem.parentViewController];
    }
    
    [lastViewController beginAppearanceTransition:NO animated:YES];
    [viewController beginAppearanceTransition:YES animated:YES];
    [lastViewController endAppearanceTransition];
    [viewController endAppearanceTransition];
}

@end

@interface PageContainerViewController ()

@property(nonatomic, strong) CollectionViewComponent *collectionViewComponent;

@property(nonatomic, assign) NSInteger currentPageIndex;

@property(nonatomic, assign) CGSize viewOldSize;

@property(nonatomic, assign) BOOL didAppearNeedExecuteEnd;

@end

@implementation PageContainerViewController

- (void)dealloc {
    [self removeObserver];
}

- (instancetype)initWithPageContainerItem:(nullable __kindof PageContainerItem *)pageContainerItem {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.pageContainerItem = pageContainerItem;
        self.currentPageIndex = DefaultCurrentPageIndex;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
    [self addObserver];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([self currentPageViewController]) {
        self.didAppearNeedExecuteEnd = YES;
        [[self currentPageViewController] beginAppearanceTransition:YES animated:animated];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.didAppearNeedExecuteEnd) {
        self.didAppearNeedExecuteEnd = NO;
        [[self currentPageViewController] endAppearanceTransition];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[self currentPageViewController] beginAppearanceTransition:NO animated:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];

    [[self currentPageViewController] endAppearanceTransition];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!CGSizeEqualToSize(self.view.bounds.size, CGSizeZero) && !CGSizeEqualToSize(self.view.bounds.size, self.viewOldSize)) {
        self.viewOldSize = self.view.bounds.size;
        
        CollectionViewSectionItem *sectionItem = [self.collectionViewComponent sectionItemForSectionIndex:0];
        [sectionItem.cellItems enumerateObjectsUsingBlock:^(__kindof CollectionViewCellItem * _Nonnull cellItem, NSUInteger idx, BOOL * _Nonnull stop) {
            cellItem.size = self.view.bounds.size;
        }];

        [self.view layoutIfNeeded];
        [self.collectionViewComponent.collectionView setContentOffset:CGPointMake(self.currentPageIndex * self.view.bounds.size.width, 0) animated:NO];
    }
}

- (BOOL)shouldAutomaticallyForwardAppearanceMethods {
    return NO;
}

- (void)setPageIndex:(NSInteger)pageIndex animated:(BOOL)animated {
    if (_currentPageIndex == pageIndex) {
        return;
    }
    
    _currentPageIndex = pageIndex;
    [self removeObserver];
    CGFloat contentOffsetX = _currentPageIndex * self.view.bounds.size.width;
    if (!animated) {
        [self.collectionViewComponent.collectionView setContentOffset:CGPointMake(contentOffsetX, 0)];
        [self addObserver];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [self.collectionViewComponent.collectionView setContentOffset:CGPointMake(contentOffsetX, 0)];
        } completion:^(BOOL finished) {
            [self addObserver];
        }];
    }
}

- (void)pageViewControllerDidCreated:(UIViewController<PageItemProtocol> *)pageViewController {

}

#pragma mark - Property

- (void)setTintColor:(UIColor *)tintColor {
    _tintColor = tintColor;
    
    if (self.isViewLoaded) {
        [self.view setBackgroundColor:tintColor];
    }
}

- (void)setPageContainerItem:(__kindof PageContainerItem *)pageContainerItem {
    if (_pageContainerItem == pageContainerItem) {
        return;
    }
    _pageContainerItem = pageContainerItem;
    
    CollectionViewSectionItem *sectionItem = [[CollectionViewSectionItem alloc] init];
    sectionItem.cellItems = [[NSMutableArray alloc] init];
    [_pageContainerItem.pageItems enumerateObjectsUsingBlock:^(__kindof PageItem * _Nonnull pageItem, NSUInteger idx, BOOL * _Nonnull stop) {
        PageCollectionViewCellItem *cellItem = [[PageCollectionViewCellItem alloc] init];
        [cellItem setSize:self.view.bounds.size];
        [cellItem setPageItem:pageItem];
        [cellItem setParentViewController:self];
        [sectionItem.cellItems addObject:cellItem];
    }];
    
    [self.collectionViewComponent updateSectionItems:@[sectionItem]];
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:self.tintColor ?: [UIColor clearColor]];
    
    [self buildCollectionViewComponent];
}

- (void)buildCollectionViewComponent {
    __weak typeof(self) weakSelf = self;
    self.collectionViewComponent = [[CollectionViewComponent alloc] initWithSectionItems:nil
                                                                         scrollDirection:UICollectionViewScrollDirectionHorizontal
                                                            mapItemClassToViewClassBlock:^(CollectionViewComponent *collectionViewComponent) {
                                                                [weakSelf mapItemClassToViewClassWithCollectionViewComponent:collectionViewComponent];
                                                            } delegateBlock:nil];
    
    [self.collectionViewComponent setWillDisplayIndexPathBlock:^(__kindof CollectionViewComponent *collecctionViewComponent, __kindof UICollectionViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf collectionViewComponent:collecctionViewComponent willDisplayCell:cell forItemAtIndexPath:indexPath];
    }];
    [self.collectionViewComponent setDidEndDisplayingIndexPathBlock:^(__kindof CollectionViewComponent *collecctionViewComponent, __kindof UICollectionViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf collectionViewComponent:collecctionViewComponent didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }];
    [self.collectionViewComponent.collectionView setPagingEnabled:YES];
    [self.collectionViewComponent.collectionView setPrefetchingEnabled:NO];
    
    [self.view addSubview:self.collectionViewComponent.collectionView];
    [self.collectionViewComponent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[PageCollectionViewCell class] cellItemClass:[PageCollectionViewCellItem class]];
}

- (void)collectionViewComponent:(__kindof CollectionViewComponent *)collectionViewComponent willDisplayCell:(__kindof UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    PageCollectionViewCellItem *cellItem = [self.collectionViewComponent cellItemForRow:indexPath.row inSection:indexPath.section];
    if (!cellItem.paegVieController) {
        cellItem.paegVieController = [[cellItem.pageItem.viewControllerClass alloc] init];
        [self pageViewControllerDidCreated:cellItem.paegVieController];
    }
    
    [(PageCollectionViewCell *)cell setViewController:cellItem.paegVieController];
}

- (void)collectionViewComponent:(__kindof CollectionViewComponent *)collectionViewComponent didEndDisplayingCell:(__kindof UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(PageCollectionViewCell *)cell setViewController:nil];
}

#pragma mark -  PrivateNotification

- (void)addObserver {
    [self.collectionViewComponent.collectionView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserver {
    [self.collectionViewComponent.collectionView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (![keyPath isEqualToString:NSStringFromSelector(@selector(contentOffset))]) {
        return;
    }
    
    CGPoint contentOffsetOld  = [change[NSKeyValueChangeOldKey] CGPointValue];
    CGPoint contentOffset = [change[NSKeyValueChangeNewKey] CGPointValue];
    if (!CGPointEqualToPoint(contentOffsetOld, contentOffset)) {
        if (self.contentOffsetDidChangeBlock) {
            self.contentOffsetDidChangeBlock(contentOffset);
        }
    }
}

#pragma mark - PrivateMethod

- (UIViewController *)currentPageViewController {
    PageCollectionViewCellItem *cellItem = [self.collectionViewComponent cellItemForRow:self.currentPageIndex inSection:0];
    return cellItem.paegVieController;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tracking || scrollView.decelerating) {
        NSInteger pageIndex = round((scrollView.contentOffset.x / (scrollView.frame.size.width ?: 0.000001)));
        CollectionViewSectionItem *sectionItem = [self.collectionViewComponent sectionItemForSectionIndex:0];
        pageIndex = MIN(MAX(0, pageIndex), sectionItem.cellItems.count - 1);
        if (self.currentPageIndex != pageIndex) {
            self.currentPageIndex = pageIndex;
            self.pageIndexChangeBlock ? self.pageIndexChangeBlock(self.currentPageIndex) : nil;
        }
    }
}

@end
