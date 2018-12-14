//
//  NestPageViewController.m
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "NestPageViewController.h"

@interface NestPageViewController ()

@end

@implementation NestPageViewController

@synthesize canUpDownScroll = _canUpDownScroll;
@synthesize pageWillLeaveTopBlock = _pageWillLeaveTopBlock;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)buildCollectionViewComponent {
    [super buildCollectionViewComponent];
    
    __weak typeof(self) weakSelf = self;
    [self.collectionViewComponent setDidScrollBlock:^(__kindof CollectionViewComponent *collectionViewComponent) {
        [weakSelf scrollViewDidScroll:collectionViewComponent];
    }];
}

- (void)setCanUpDownScroll:(BOOL)canUpDownScroll {
    _canUpDownScroll = canUpDownScroll;

    if (!_canUpDownScroll) {
        [self.collectionViewComponent.collectionView setContentOffset:CGPointZero];
    }
}

#pragma mark - PrivateMethod

- (void)scrollViewDidScroll:(__kindof CollectionViewComponent *)collectionViewComponent {
    if (!self.canUpDownScroll) {
        self.collectionViewComponent.collectionView.contentOffset = CGPointZero;
    }
    if (self.collectionViewComponent.collectionView.contentOffset.y <= 0) {
        self.canUpDownScroll = NO;
        self.collectionViewComponent.collectionView.contentOffset = CGPointZero;

        if (self.pageWillLeaveTopBlock) {
            self.pageWillLeaveTopBlock();
        }
    }

    self.collectionViewComponent.collectionView.showsVerticalScrollIndicator = self.canUpDownScroll;
}

@end
