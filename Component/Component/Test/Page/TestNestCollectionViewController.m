//
//  TestNestTableViewController.m
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "TestNestCollectionViewController.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewCellItem.h"
#import "NestCollectionViewComponent.h"
#import "Masonry.h"

@implementation TestNestCollectionViewTopCellItem

@end

@implementation TestNestCollectionViewTopCell

- (void)buildUI {
    [super buildUI];
    
    [self setBackgroundColor:[UIColor redColor]];
}

@end

@implementation TestNestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)(arc4random() % 255) / 255.0 green:(CGFloat)(arc4random() % 255) / 255.0 blue:(CGFloat)(arc4random() % 255) / 255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"--viewWillAppear--page:%@----", self);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"--viewDidAppear--page:%@----", self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"--viewWillDisappear--page:%@----", self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"--viewDidDisappear--page:%@----", self);
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[TestCollectionViewCell class] cellItemClass:[TestCollectionViewCellItem class]];
}

@end

@interface TestNestCollectionViewController ()

@property(nonatomic, strong) NestCollectionViewComponent *collectionViewComponent;
@property(nonatomic, strong) NSArray<__kindof CollectionViewSectionItem *> *sectionItems;

@end

@implementation TestNestCollectionViewController

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
        [weakSelf mapItemClassToViewClassWithCollectionViewComponent:collectionViewComponent];
    }];
    
    [self.view addSubview:self.collectionViewComponent.collectionView];
    [self.collectionViewComponent.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - PrivateUI

- (void)buildUI {
    [self.view setBackgroundColor:[UIColor clearColor]];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    [self buildCollectionViewComponent];
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
     [collectionViewComponent mapCellClass:[TestNestCollectionViewTopCell class] cellItemClass:[TestNestCollectionViewTopCellItem class]];
    [collectionViewComponent mapCellClass:[NestPageContainerCell class] cellItemClass:[NestPageContainerCellItem class]];
    
    [collectionViewComponent mapReuseableViewClass:[NestPageContainerReusableView class] reuseableViewItemClass:[NestPageContainerReusableViewItem class] forKind:UICollectionElementKindSectionHeader];
}

@end
