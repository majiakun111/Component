//
//  TestPageRootViewController.m
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 PingAn. All rights reserved.
//

#import "TestPageRootViewController.h"
#import "PageContainerViewController.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewCellItem.h"
#import "Masonry.h"
#import "PageTitleView.h"

@implementation TestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)(arc4random() % 255) / 255.0 green:(CGFloat)(arc4random() % 255) / 255.0 blue:(CGFloat)(arc4random() % 255) / 255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"--viewWillAppear--vc:%@----", self);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"--viewDidAppear--vc:%@----", self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"--viewWillDisappear--vc:%@----", self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"--viewDidDisappear--vc:%@----", self);
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[TestCollectionViewCell class] cellItemClass:[TestCollectionViewCellItem class]];
}

@end

@interface TestPageRootViewController ()

@property(nonatomic, strong) PageTitleView *pageTitleView;
@property(nonatomic, strong) PageContainerViewController *pageContainerViewController;

@end

@implementation TestPageRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSMutableArray<NSString *> *titles = @[].mutableCopy;
    for (NSInteger index = 0; index < 20; index++) {
        NSString *title = [NSString stringWithFormat:@"title_%d", (int)index];
        if (index % 2 ==0) {
            title = [NSString stringWithFormat:@"ansel_%@", title];
        }
        
        [titles addObject:title];
    }
    
    self.pageTitleView = [[PageTitleView alloc] initWithTitles:titles];
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
    [self.pageTitleView updateIndexProgress:10 animated:NO];
    
    NSMutableArray<__kindof PageItem *> *pageItems = @[].mutableCopy;
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
        pageItem.viewControllerClass = [TestPageViewController class];
        [pageItems addObject:pageItem];
    }
    
    PageContainerItem *pageContainerItem = [[PageContainerItem alloc] init];
    pageContainerItem.pageItems = pageItems;
    pageContainerItem.pageWidth = [UIScreen mainScreen].bounds.size.width;
    self.pageContainerViewController = [[PageContainerViewController alloc] initWithPageContainerItem:pageContainerItem];
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
    
    [self.pageContainerViewController setPageIndex:10 animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
