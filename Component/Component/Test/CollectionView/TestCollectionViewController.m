//
//  TestCollectionViewController.m
//  Component
//
//  Created by Ansel on 16/3/8.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TestCollectionViewController.h"
#import "CollectionViewSectionItem.h"
#import "TestCollectionViewCellItem.h"
#import "TestCollectionViewCell.h"
#import "TestReusableViewItem.h"
#import "TestReuseableView.h"

@implementation TestCollectionViewController


-(void)doRefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.collectionView.refreshView stopRefreshing];
        
        self.sectionItems = [[NSMutableArray alloc] init];
        
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
        
        [self.sectionItems addObject:sectionItem];
        
        [self reloadData];
    });
}

- (void)loadMore
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.collectionView.loadMoreView stopLoading];
        
        for (int i = 101; i < 200; i++) {
            TestCollectionViewCellItem *cellItem =  [[TestCollectionViewCellItem alloc] init];
            [cellItem setTitle:[NSString stringWithFormat:@"%d", i]];
            cellItem.size = CGSizeMake(80, 80);
            
            [[[self.sectionItems lastObject] cellItems] addObject:cellItem];
        }
        
        [self reloadData];
    });
    
}

- (void)mapItemClassToViewClass;
{
    [self mapCellClass:[TestCollectionViewCell class] cellItemClass:[TestCollectionViewCellItem class]];
    
    [self mapReuseableViewClass:[TestReuseableView class] reuseableViewItem:[TestReusableViewItem class] forKind:UICollectionElementKindSectionHeader];
    [self mapReuseableViewClass:[TestReuseableView class] reuseableViewItem:[TestReusableViewItem class] forKind:UICollectionElementKindSectionFooter];    
}


@end
