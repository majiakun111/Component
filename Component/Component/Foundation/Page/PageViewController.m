//
//  CollectionViewPageViewController.m
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "PageViewController.h"
#import "CollectionViewComponent.h"
#import "Masonry.h"

@interface PageViewController ()

@property(nonatomic, strong) CollectionViewComponent *collectionViewComponent;

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)buildCollectionViewComponent {
    __weak typeof(self) weakSelf = self;
    self.collectionViewComponent = [[CollectionViewComponent alloc] initWithSectionItems:self.pageItem.sectionItems mapItemClassToViewClassBlock:^(CollectionViewComponent *collectionViewComponent) {
        [weakSelf mapItemClassToViewClassWithCollectionViewComponent:collectionViewComponent];
    }];
    [self.collectionViewComponent setDidSelectedIndexPathBlcok:^(CollectionViewComponent *collectionViewComponent, NSIndexPath *indexPath) {
        [weakSelf collectionViewComponent:collectionViewComponent didSelectItemAtIndexPath:indexPath];
    }];
    [self.collectionViewComponent.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.collectionViewComponent.collectionView setShowsVerticalScrollIndicator:YES];
    [self.collectionViewComponent.collectionView setShowsHorizontalScrollIndicator:NO];
    [self.collectionViewComponent.collectionView setBounces:YES];
    [self.collectionViewComponent.collectionView setAlwaysBounceVertical:YES];
    
    [self.view addSubview:self.collectionViewComponent.collectionView];
    [self.collectionViewComponent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    
}

- (void)collectionViewComponent:(CollectionViewComponent *)collectionViewComponent didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)reloadDataWithPageItem:(__kindof PageItem *)pageItem {
    if ([pageItem isKindOfClass:[PageItem class]]) {
        return;
    }
    
    self.pageItem = pageItem;
    [self.collectionViewComponent updateSectionItems:self.pageItem.sectionItems];
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self buildCollectionViewComponent];
}

@end
