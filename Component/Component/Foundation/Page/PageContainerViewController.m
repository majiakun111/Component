//
//  PageViewController.m
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "PageContainerViewController.h"
#import "HorizontalTableView.h"
#import "HorizontalTableViewCell.h"
#import "Masonry.h"

NSInteger const DefaultCurrentPageIndex = 0;

@interface PageContainerTableViewCell : HorizontalTableViewCell

@property(nonatomic, strong) UIViewController *viewController;
@property(nonatomic, weak) UIViewController *parentViewController;
@property(nonatomic, assign) CGFloat pageWidth;

@end

@implementation PageContainerTableViewCell

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
    
    if (viewController) {
        [viewController willMoveToParentViewController:self.parentViewController];
        [self.parentViewController addChildViewController:viewController];
        [self addSubview:viewController.view];
        
        [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        [viewController didMoveToParentViewController:self.parentViewController];
    }
    
    [lastViewController beginAppearanceTransition:NO animated:YES];
    [viewController beginAppearanceTransition:YES animated:YES];
    [lastViewController endAppearanceTransition];
    [viewController endAppearanceTransition];
}

@end


@interface PageContainerViewController () <HorizontalTableViewDelegate, HorizontalTableViewDataSource>

@property(nonatomic, strong) HorizontalTableView *tableView;

@property(nonatomic, strong) NSArray<UIViewController<PageItemProtocol> *> *pageViewControllers;
@property(nonatomic, assign) NSInteger currentPageIndex;

@property (nonatomic, assign) CGSize viewOldSize;

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

    [[self currentPageViewController] beginAppearanceTransition:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[self currentPageViewController] endAppearanceTransition];
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
        [self.view layoutIfNeeded];
        [self.tableView setContentOffset:CGPointMake(self.currentPageIndex * self.pageContainerItem.pageWidth, 0) animated:NO];
    }
}

- (void)setPageIndex:(NSInteger)pageIndex animated:(BOOL)animated {
    if (_currentPageIndex == pageIndex) {
        return;
    }
    
    _currentPageIndex = pageIndex;
    [self removeObserver];
    if (!animated) {
        [self.tableView setContentOffset:CGPointMake(pageIndex * self.pageContainerItem.pageWidth, 0)];
        [self addObserver];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            [self.tableView setContentOffset:CGPointMake(pageIndex * self.pageContainerItem.pageWidth, 0)];
        } completion:^(BOOL finished) {
            [self addObserver];
        }];
    }
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
    
    NSMutableArray<UIViewController<PageItemProtocol> *> *pageViewControllers = @[].mutableCopy;
    [_pageContainerItem.pageItems enumerateObjectsUsingBlock:^(__kindof PageItem * _Nonnull pageItem, NSUInteger idx, BOOL * _Nonnull stop) {
        UIViewController<PageItemProtocol> *pageViewController = [[pageItem.viewControllerClass alloc] init];
        if ([pageViewController respondsToSelector:@selector(setPageItem:)]) {
            [pageViewController setPageItem:pageItem];
        }
        
        [pageViewControllers addObject:pageViewController];
    }];
    self.pageViewControllers = pageViewControllers;
    
    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:self.tintColor ?: [UIColor clearColor]];
    
    [self buildTableView];
}

- (void)buildTableView {
    self.tableView = [[HorizontalTableView alloc] init];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setPagingEnabled:YES];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark -  PrivateNotification

- (void)addObserver {
    [self.tableView addObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset)) options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
}

- (void)removeObserver {
    [self.tableView removeObserver:self forKeyPath:NSStringFromSelector(@selector(contentOffset))];
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
    if (self.currentPageIndex >= [self.pageViewControllers count]) {
        return nil;
    }
    
    return [self.pageViewControllers objectAtIndex:self.currentPageIndex];
}

#pragma mark - HorizontalTableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(HorizontalTableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(HorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.pageViewControllers count];
}

- (__kindof HorizontalTableViewCell *)tableView:(HorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"PageContainerTableViewCellIdentifier";
    PageContainerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[PageContainerTableViewCell alloc] initWithReuseIdentifer:cellIdentifier];
    }
    cell.parentViewController = self;

    return cell;
}

#pragma mark - HorizontalTableViewDelegate

- (CGFloat)tableView:(HorizontalTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.pageContainerItem.pageWidth;
}

- (void)tableView:(HorizontalTableView *)tableView willDisplayCell:(__kindof HorizontalTableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= self.pageViewControllers.count) {
        return;
    }
    
    UIViewController *pageViewController = [self.pageViewControllers objectAtIndex:indexPath.row];
    [(PageContainerTableViewCell *)cell setViewController:pageViewController];
}

- (void)tableView:(HorizontalTableView *)tableView didEndDisplayingCell:(__kindof HorizontalTableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(PageContainerTableViewCell *)cell setViewController:nil];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.tracking || scrollView.decelerating) {
        NSInteger pageIndex = round((scrollView.contentOffset.x / (scrollView.frame.size.width ?: 0.000001)));
        pageIndex = MIN(MAX(0, pageIndex), self.pageViewControllers.count - 1);
        if (self.currentPageIndex != pageIndex) {
            self.currentPageIndex = pageIndex;
            self.pageIndexChangeBlock ? self.pageIndexChangeBlock(self.currentPageIndex) : nil;
        }
    }
}

@end
