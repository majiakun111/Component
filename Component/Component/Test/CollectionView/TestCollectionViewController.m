//
//  TestCollectionViewController.m
//  Component
//
//  Created by Ansel on 16/3/8.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "CollectionViewSectionItem.h"
#import "TestCollectionViewCellItem.h"
#import "TestCollectionViewCell.h"
#import "TestReusableViewItem.h"
#import "TestReuseableView.h"

@implementation TestCollectionViewController

-(void)doRefresh {
    [super doRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopRefreshing];
        
        CollectionViewSectionItem *sectionItem = [[CollectionViewSectionItem alloc] init];
        TestReusableViewItem *headerViewItem = [[TestReusableViewItem alloc] init];
        [headerViewItem setTitle:@"head"];
        headerViewItem.size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 20);
        [sectionItem setHeaderViewItem:headerViewItem];
        
        TestReusableViewItem *footerViewItem = [[TestReusableViewItem alloc] init];
        [footerViewItem setTitle:@"footer"];
        footerViewItem.size = CGSizeMake([[UIScreen mainScreen] bounds].size.width, 20);
        [sectionItem setFooterViewItem:footerViewItem];
        
        NSMutableArray *cellItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i++) {
            TestCollectionViewCellItem *cellItem =  [[TestCollectionViewCellItem alloc] init];
            [cellItem setTitle:[NSString stringWithFormat:@"%d", i]];
            cellItem.size = CGSizeMake(80, 80);
            [cellItems addObject:cellItem];
        }
        
        [sectionItem setCellItems:cellItems];
        
        [self updateSectionItems:@[sectionItem]];
    });
}

- (void)loadMore {
    [super loadMore];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self stopLoading];
        
        for (int i = 101; i < 200; i++) {
            TestCollectionViewCellItem *cellItem =  [[TestCollectionViewCellItem alloc] init];
            [cellItem setTitle:[NSString stringWithFormat:@"%d", i]];
            cellItem.size = CGSizeMake(80, 80);
            
            [[[self.collectionViewComponent.sectionItems lastObject] cellItems] addObject:cellItem];
        }
        
        [self setHasMore:NO];

        [self reloadData];
    });
    
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[TestCollectionViewCell class] cellItemClass:[TestCollectionViewCellItem class]];
    
    [collectionViewComponent mapReuseableViewClass:[TestReuseableView class] reuseableViewItemClass:[TestReusableViewItem class] forKind:UICollectionElementKindSectionHeader];
    [collectionViewComponent mapReuseableViewClass:[TestReuseableView class] reuseableViewItemClass:[TestReusableViewItem class] forKind:UICollectionElementKindSectionFooter];
}


@end
