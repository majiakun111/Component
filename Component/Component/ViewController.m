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

@interface ViewController ()

@property(nonatomic, strong) PageContainerViewController *pageContainerViewController;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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
    [self addChildViewController:self.pageContainerViewController];
    [self.view addSubview:self.pageContainerViewController.view];
    
    [self.pageContainerViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.pageContainerViewController didMoveToParentViewController:self];
    
    //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.pageContainerViewController setPageIndex:18 animated:NO];
    //});
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
