//
//  ViewController.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 MJK. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Highlight.h"
#import "UIImage+Color.h"
#import "ImagesConvertVideo.h"
#import "PageContainerViewController.h"
#import "TestPageViewController.h"
#import "TestCollectionViewCellItem.h"
#import "Masonry.h"
#import "PageTitleView.h"

@interface ViewController ()

@property(nonatomic, strong) PageTitleView *pageTitleView;
@property(nonatomic, strong) PageContainerViewController *pageContainerViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    for (NSInteger index = 0; index < 20; index++) {
        NSString *title = [NSString stringWithFormat:@"title_%d", (int)index];
        [titles addObject:title];
    }
    
    self.pageTitleView = [[PageTitleView alloc] initWithTitles:titles];
    [self.pageTitleView setTitePadding:10];
    [self.pageTitleView setBackgroundColor:[UIColor clearColor]];
    __weak typeof(self) weakSelf = self;
    [self.pageTitleView setCurrentIndexChangedBlock:^(NSUInteger currentIndex) {
        [weakSelf.pageContainerViewController setPageIndex:currentIndex animated:NO];
    }];
    [self.view addSubview:self.pageTitleView];
    [self.pageTitleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@(40));
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];

    NSMutableArray<TestPageViewController *> *pageViewControllers = @[].mutableCopy;
    for (int pageIndex = 0; pageIndex < 20; pageIndex++) {
        PageItem *pageItem = [[PageItem alloc] init];

        CollectionViewSectionItem *sectionItem = [[CollectionViewSectionItem alloc] init];
        sectionItem.cellItems = @[].mutableCopy;
        for (int index = 0; index < 100; index ++) {
            TestCollectionViewCellItem *cellItem = [[TestCollectionViewCellItem alloc] init];
            cellItem.title = [NSString stringWithFormat:@"%d_%d", pageIndex, index];
            [sectionItem.cellItems addObject:cellItem];
            cellItem.size = CGSizeMake(80.0, 80.0);
        }

        pageItem.sectionItems = @[sectionItem];
        TestPageViewController *pageViewController = [[TestPageViewController alloc] initWithPageItem:pageItem];
        [pageViewControllers addObject:pageViewController];
    }

    self.pageContainerViewController = [[PageContainerViewController alloc] initWithPageViewControllers:pageViewControllers pageWidth:[UIScreen mainScreen].bounds.size.width];
    [self.pageContainerViewController setContentOffsetDidChangeBlock:^(CGPoint contentOffset) {
        [weakSelf.pageTitleView updateIndexProgress:contentOffset.x / [UIScreen mainScreen].bounds.size.width animated:YES];
    }];
    [self addChildViewController:self.pageContainerViewController];
    [self.view addSubview:self.pageContainerViewController.view];

    [self.pageContainerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pageTitleView.mas_bottom);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self.pageContainerViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
