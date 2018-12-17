//
//  CollectionViewNestPageContainerViewControllerViewController.m
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "NestTableViewController.h"
#import "Masonry.h"
#import "PageTitleView.h"

NSInteger const NestTableViewBottomSection = 1;
NSInteger const NestTableViewBottomCellRow = 0;

//Top Section
@implementation NestTableViewTopSectionCellItem

@end

@implementation NestTableViewTopSectionCell

@end

//Bottom Section header
@implementation NestTableViewBottomSectionHeaderViewItem

@end

@interface NestTableViewBottomSectionHeaderView ()

@property(nonatomic, strong) PageTitleView *pageTitleView;

@end

@implementation NestTableViewBottomSectionHeaderView

- (void)dealloc {
    [self removeObserver];
}

- (void)setItem:(__kindof HeaderOrFooterViewItem *)item {
    [self removeObserver];
    
    _item = item;
    
    [self addObserver];
    
    [self updateUI];
}

- (void)updateUI {
    [super updateUI];
    
    NestTableViewBottomSectionHeaderViewItem *item = self.item;
    if (!_pageTitleView) {
        _pageTitleView = [[PageTitleView alloc] initWithTitles:item.titles];
        [self addSubview:_pageTitleView];
        [_pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        __weak typeof(self) weakSelf = self;
        [_pageTitleView setCurrentIndexChangedBlock:^(NSUInteger currentIndex) {
            if ([(id<NestTableViewBottomSectionHeaderViewDelegate>)weakSelf.delegate respondsToSelector:@selector(headerView:pageTitleCurrentIndex:)]) {
                [(id<NestTableViewBottomSectionHeaderViewDelegate>)weakSelf.delegate headerView:weakSelf pageTitleCurrentIndex:currentIndex];
            }
        }];
        [_pageTitleView setBackgroundColor:[UIColor clearColor]];
    }
    
    [_pageTitleView updateIndexProgress:item.indexProgress animated:YES];
}

#pragma mark - PrivateNotification

- (void)addObserver {
    NestTableViewBottomSectionHeaderViewItem *item = self.item;
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(indexProgress)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    NestTableViewBottomSectionHeaderViewItem *item = self.item;
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(indexProgress))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NestTableViewBottomSectionHeaderViewItem *item = self.item;
        if (object == item) {
            if ([keyPath isEqualToString:NSStringFromSelector(@selector(indexProgress))]) {
                [self.pageTitleView updateIndexProgress:item.indexProgress animated:YES];
            }
        }
    });
}


@end

//bottom Section Cell
@implementation NestTableViewBottomSectionCellItem

@end

@interface NestTableViewBottomSectionCell ()

@property(nonatomic, strong) NestPageContainerViewController *pageContianerViewController;

@end

@implementation NestTableViewBottomSectionCell

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

- (void)setItem:(__kindof TableViewCellItem *)item {
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
    
    NestTableViewBottomSectionCellItem *item = self.item;
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
            if ([(id<NestTableViewBottomSectionCellDelegate>)weakSelf.delegate respondsToSelector:@selector(tableViewCell:pageContainerViewControllerScrollToContentOffset:)]) {
                [(id<NestTableViewBottomSectionCellDelegate>)weakSelf.delegate tableViewCell:weakSelf pageContainerViewControllerScrollToContentOffset:contentOffset];
            }
        }];
        [_pageContianerViewController setPageContainerWillLeaveTopBlock:^{
            if ([(id<NestTableViewBottomSectionCellDelegate>)weakSelf.delegate respondsToSelector:@selector(pageContainerViewControllerWillLeaveTopForTableViewCell:)]) {
                [(id<NestTableViewBottomSectionCellDelegate>)weakSelf.delegate pageContainerViewControllerWillLeaveTopForTableViewCell:weakSelf];
            }
        }];
    }
    
    return _pageContianerViewController;
}

#pragma mark - PrivateNotification

- (void)addObserver {
    NestTableViewBottomSectionCellItem *item = self.item;
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(canUpDownScroll)) options:NSKeyValueObservingOptionNew context:nil];
    [item addObserver:self forKeyPath:NSStringFromSelector(@selector(pageIndex)) options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObserver {
    NestTableViewBottomSectionCellItem *item = self.item;
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(canUpDownScroll))];
    [item removeObserver:self forKeyPath:NSStringFromSelector(@selector(pageIndex))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    dispatch_async(dispatch_get_main_queue(), ^{
        NestTableViewBottomSectionCellItem *item = self.item;
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

@interface NestTableView () <UIGestureRecognizerDelegate>

@end

//collectionView
@implementation NestTableView

#pragma mark - UIGestureRecognizerDelegate
/**
 同时识别多个手势
 */
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end

@implementation NestTableViewComponent

- (instancetype)initWithSectionItems:(NSArray<__kindof TableViewSectionItem *> *)sectionItems mapItemClassToViewClassBlock:(void (^)(__kindof TableViewComponent * _Nonnull))mapItemClassToViewClassBlock delegateBlock:(void (^)(__kindof TableViewComponent * _Nonnull))delegateBlock {
    self = [super initWithSectionItems:sectionItems
          mapItemClassToViewClassBlock:mapItemClassToViewClassBlock delegateBlock:delegateBlock];
    if (self) {
        self.canUpDownScroll = YES;
    }
    
    return self;
}

#pragma mark - Override

- (void)buildTableView {
    
    _tableView = [[NestTableView alloc] initWithFrame:CGRectZero];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    if (@available(iOS 11.0, *)) {
        [self.tableView setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat bottomSectionOffset = [self.tableView rectForSection:NestTableViewBottomSection].origin.y;
    if (self.tableView.contentOffset.y >= bottomSectionOffset) {
        self.tableView.contentOffset = CGPointMake(0, bottomSectionOffset);

        if (self.canUpDownScroll) {
            self.canUpDownScroll = NO;
            if (self.tabelViewBottomCellCanScrollBlock) {
                self.tabelViewBottomCellCanScrollBlock(YES);
            }
        }
    }else{
        if (!self.canUpDownScroll) {//子视图没到顶部
            self.tableView.contentOffset = CGPointMake(0, bottomSectionOffset);
        }
    }

    self.tableView.showsVerticalScrollIndicator = self.canUpDownScroll;
}

@end

@interface NestTableViewController ()<NestTableViewBottomSectionHeaderViewDelegate, NestTableViewBottomSectionCellDelegate>

@property(nonatomic, strong) NestTableViewComponent *tableViewComponent;
@property(nonatomic, strong) NSArray<__kindof TableViewSectionItem *> *sectionItems;

@end

@implementation NestTableViewController

- (instancetype)initWithSectioItems:(NSArray<__kindof TableViewSectionItem *> *)sectionItems {
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

- (void)buildTableViewComponent {
    __weak typeof(self) weakSelf = self;
    self.tableViewComponent = [[NestTableViewComponent alloc] initWithSectionItems:self.sectionItems mapItemClassToViewClassBlock:^(TableViewComponent *tableViewComponent) {
        [weakSelf mapItemClassToViewClassWithTableViewComponent:tableViewComponent];
    } delegateBlock:^(__kindof TableViewComponent * _Nonnull tableViewComponent) {
        tableViewComponent.cellDelegate = weakSelf;
        tableViewComponent.headerOrFooterViewDelegate = weakSelf;
    }];
    [self.tableViewComponent setWillDisplayIndexPathBlock:^(__kindof TableViewComponent *tableViewComponent, __kindof UITableViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf tableViewComponent:tableViewComponent willDisplayCell:cell forItemAtIndexPath:indexPath];
    }];
    [self.tableViewComponent setDidEndDisplayingIndexPathBlock:^(__kindof TableViewComponent *tableViewComponent, __kindof UITableViewCell *cell, NSIndexPath *indexPath) {
        [weakSelf tableViewComponent:tableViewComponent didEndDisplayingCell:cell forItemAtIndexPath:indexPath];
    }];
    [self.tableViewComponent setTabelViewBottomCellCanScrollBlock:^(BOOL tabelViewBottomCellCanScroll) {
        [weakSelf updateTabelViewBottomCellCanScroll:tabelViewBottomCellCanScroll];
    }];
    
    [self.view addSubview:self.tableViewComponent.tableView];
    [self.tableViewComponent.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)mapItemClassToViewClassWithTableViewComponent:(TableViewComponent *)tableViewComponent {
    [tableViewComponent mapCellClass:[NestTableViewBottomSectionCell class] cellItemClass:[NestTableViewBottomSectionCellItem class]];
    
    [tableViewComponent mapHeaderOrFooterViewClass:[NestTableViewBottomSectionHeaderView class] headerOrFooterViewItemClass:[NestTableViewBottomSectionHeaderViewItem class]];
}

- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent willDisplayCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[NestTableViewBottomSectionCell class]]) {
        NestTableViewBottomSectionCell *bottomCell = cell;
        [bottomCell setParentViewController:self];
    }
}

- (void)tableViewComponent:(__kindof TableViewComponent *)tableViewComponent didEndDisplayingCell:(__kindof UITableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell isKindOfClass:[NestTableViewBottomSectionCell class]]) {
        NestTableViewBottomSectionCell *bottomCell = cell;
        [bottomCell setParentViewController:nil];
    }
}

#pragma mark - NestTableViewBottomSectionHeaderViewDelegate

- (void)headerView:(NestTableViewBottomSectionHeaderView *)headerView pageTitleCurrentIndex:(NSInteger)pageTitleCurrentIndex {
    NestTableViewBottomSectionCellItem *cellItem = [self.tableViewComponent cellItemForRow:NestTableViewBottomCellRow section:NestTableViewBottomSection];
    cellItem.pageIndex = pageTitleCurrentIndex;
}

#pragma mark - NestTableViewBottomSectionCellDelegate

- (void)tableViewCell:(NestTableViewBottomSectionCell *)tableViewCell pageContainerViewControllerScrollToContentOffset:(CGPoint)contentOffset {
    NestTableViewBottomSectionHeaderViewItem *headerViewItem = [self.tableViewComponent headerItemForSection:NestTableViewBottomSection];
    headerViewItem.indexProgress = contentOffset.x / self.view.bounds.size.width;
}

- (void)pageContainerViewControllerWillLeaveTopForTableViewCell:(NestTableViewBottomSectionCell *)tableViewCell {
    [self.tableViewComponent setCanUpDownScroll:YES];
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self buildTableViewComponent];
}

#pragma mark - PrivateMethod

- (void)updateTabelViewBottomCellCanScroll:(BOOL)tabelViewBottomCellCanScroll {
    NestTableViewBottomSectionCellItem *item = [self.tableViewComponent cellItemForRow:NestTableViewBottomCellRow section:NestTableViewBottomSection];
    item.canUpDownScroll = tabelViewBottomCellCanScroll;
}

@end
