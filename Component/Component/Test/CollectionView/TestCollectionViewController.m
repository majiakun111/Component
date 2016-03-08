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

@implementation TestCollectionViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sectionItems = [[NSMutableArray alloc] init];
        
        CollectionViewSectionItem *sectionItem = [[CollectionViewSectionItem alloc] init];
//        TestTableViewHeaderOrFooterViewItem *headerViewItem = [[TestTableViewHeaderOrFooterViewItem alloc] init];
//        [headerViewItem setTitle:@"head"];
//        headerViewItem.height = 20.0f;
//        [sectionItem setHeaderViewItem:headerViewItem];
        
//        TestTableViewHeaderOrFooterViewItem *footerViewItem = [[TestTableViewHeaderOrFooterViewItem alloc] init];
//        [footerViewItem setTitle:@"footer"];
//        [footerViewItem setHeight:20.0f];
//        [sectionItem setFooterViewItem:footerViewItem];
        
        NSMutableArray *cellItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < 100; i++) {
            TestCollectionViewCellItem *cellItem =  [[TestCollectionViewCellItem alloc] init];
            [cellItem setTitle:[NSString stringWithFormat:@"%d", i]];
            cellItem.size = CGSizeMake(80, 80);
            [cellItems addObject:cellItem];
        }
        
        [sectionItem setCellItems:cellItems];
        
        [self.sectionItems addObject:sectionItem];
    }
    
    return self;
}

- (void)mapItemClassToViewClass;
{
    [self mapCellClass:[TestCollectionViewCell class] cellItemClass:[TestCollectionViewCellItem class]];
    
//    [self mapHeaderOrFooterViewClass:[TestTableViewHeaderOrFooterView class] headerOrFooterViewItem:[TestTableViewHeaderOrFooterViewItem class]];
    
}


@end
