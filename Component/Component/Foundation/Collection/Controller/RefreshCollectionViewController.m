//
//  RemoteCollectionViewController.m
//  Component
//
//  Created by Ansel on 16/3/10.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "RefreshCollectionViewController.h"
#import "UIView+Coordinate.h"
#import "Masonry.h"

@interface RefreshCollectionViewController ()

@property(nonatomic, strong) CollectionViewComponent *collectionViewComponent;
@property (nonatomic, assign) CGSize viewOldSize;

@end

@implementation RefreshCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self buildUI];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (!CGSizeEqualToSize(self.view.bounds.size, CGSizeZero) && !CGSizeEqualToSize(self.view.bounds.size, self.viewOldSize)) {
        self.viewOldSize = self.view.bounds.size;
        [self configRefreshAndLoadMore];
    }
}

- (void)updateSectionItems:(NSArray<CollectionViewSectionItem *> *)sectionItems {
    [self.collectionViewComponent updateSectionItems:sectionItems ];
}

- (void)reloadData {
    [self.collectionViewComponent.collectionView reloadData];
}

- (void)startRefreshing {
    [self.collectionViewComponent.collectionView.refreshView startRefreshing];
}

- (void)stopRefreshing {
    [self.collectionViewComponent.collectionView.refreshView stopRefreshing];
}

- (void)stopLoading {
    [self.collectionViewComponent.collectionView.loadMoreView stopLoading];
}

- (void)setHasMore:(BOOL)hasMore {
    [self.collectionViewComponent.collectionView.loadMoreView setHasMore:hasMore];
}

-(void)doRefresh {
    
}

- (void)loadMore {
    
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    
}

- (void)collectionViewComponent:(CollectionViewComponent *)collectionViewComponent didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self.view setBackgroundColor:[UIColor clearColor]];
    
    [self buildCollectionViewComponent];
}

- (void)buildCollectionViewComponent {
    __weak typeof(self) weakSelf = self;
    self.collectionViewComponent = [[CollectionViewComponent alloc] initWithSectionItems:nil mapItemClassToViewClassBlock:^(CollectionViewComponent *collectionViewComponent) {
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

- (void)configRefreshAndLoadMore {
    __weak typeof(self) weakSelf = self;
    self.collectionViewComponent.collectionView.refreshView = [RefreshView refreshWithFrame:CGRectMake(0.0f, 0.0f - self.collectionViewComponent.collectionView.height, self.collectionViewComponent.collectionView.width, self.collectionViewComponent.collectionView.height) refreshingBlock:^{
        [weakSelf doRefresh];
    }];
    
    self.collectionViewComponent.collectionView.loadMoreView = [LoadMoreView loadMoreWithFrame:CGRectMake(0.0f, 0.0f - self.collectionViewComponent.collectionView.height, self.collectionViewComponent.collectionView.width, self.collectionViewComponent.collectionView.height) loadingBlock:^{
        [weakSelf loadMore];
    }];
    
    [self startRefreshing];
}

@end
