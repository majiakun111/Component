//
//  CollectionViewNestPageContainerViewControllerViewController.m
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "NestCollectionViewController.h"
#import "Masonry.h"
#import "NestCollectionViewComponent.h"

NSInteger const NestCollectionViewPageContainerCellRow = 0;

@interface NestCollectionViewController ()<NestPageContainerReusableViewDelegate, NestPageContainerCellDelegate>

@property(nonatomic, strong) NestCollectionViewComponent *collectionViewComponent;
@property(nonatomic, strong) NSArray<__kindof CollectionViewSectionItem *> *sectionItems;

@end

@implementation NestCollectionViewController

- (instancetype)initWithSectioItems:(NSArray<__kindof CollectionViewSectionItem *> *)sectionItems {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _sectionItems = sectionItems;
        [_sectionItems enumerateObjectsUsingBlock:^(__kindof CollectionViewSectionItem * _Nonnull sectionItem, NSUInteger idx, BOOL * _Nonnull stop) {
            [sectionItem.cellItems enumerateObjectsUsingBlock:^(__kindof CollectionViewCellItem * _Nonnull cellItem, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([cellItem isKindOfClass:[NestPageContainerCellItem class]]) {
                    [cellItem setParentViewController:self];
                }
            }];
        }];
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
    
    [self.view addSubview:self.collectionViewComponent.collectionView];
    [self.collectionViewComponent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[NestPageContainerCell class] cellItemClass:[NestPageContainerCellItem class]];

    [collectionViewComponent mapReuseableViewClass:[NestPageContainerReusableView class] reuseableViewItemClass:[NestPageContainerReusableViewItem class] forKind:UICollectionElementKindSectionHeader];
}

#pragma mark - NestPageContainerReusableViewDelegate

- (void)reusableView:(NestPageContainerReusableView *)reusableView pageTitleCurrentIndex:(NSInteger)pageTitleCurrentIndex {
    NestPageContainerCellItem *cellItem = [self.collectionViewComponent cellItemForRow:NestCollectionViewPageContainerCellRow inSection:[self.sectionItems count] - 1];
    cellItem.pageIndex = pageTitleCurrentIndex;
}

#pragma mark - NestPageContainerCellDelegate

- (void)collectionViewCell:(NestPageContainerCell *)collectionViewCell pageContainerViewControllerScrollToContentOffset:(CGPoint)contentOffset {
    NestPageContainerReusableViewItem *headerViewItem = [self.collectionViewComponent reuseableViewItemForSection:[self.sectionItems count] - 1 kind:UICollectionElementKindSectionHeader];
    headerViewItem.indexProgress = contentOffset.x / self.view.bounds.size.width;
}

- (void)pageContainerViewControllerWillLeaveTopForCollectionViewCell:(NestPageContainerCell *)collectionViewCell {
    [self.collectionViewComponent setCanUpDownScroll:YES];
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self buildCollectionViewComponent];
}

@end
