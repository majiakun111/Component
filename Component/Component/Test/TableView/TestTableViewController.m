//
//  TestTableViewController.m
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "TestTableViewController.h"
#import "TableViewSectionItem.h"
#import "TestTableViewCellItem.h"
#import "TestTableViewCell.h"
#import "TestTableViewHeaderOrFooterViewItem.h"
#import "TestTableViewHeaderOrFooterView.h"

@implementation TestTableViewController

-(void)doRefresh {
    [super doRefresh];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self stopRefreshing];
        
        TableViewSectionItem *sectionItem = [[TableViewSectionItem alloc] init];
        TestTableViewHeaderOrFooterViewItem *headerViewItem = [[TestTableViewHeaderOrFooterViewItem alloc] init];
        [headerViewItem setTitle:@"head"];
        headerViewItem.height = 20.0f;
        [sectionItem setHeaderViewItem:headerViewItem];
        
        TestTableViewHeaderOrFooterViewItem *footerViewItem = [[TestTableViewHeaderOrFooterViewItem alloc] init];
        [footerViewItem setTitle:@"footer"];
        [footerViewItem setHeight:20.0f];
        [sectionItem setFooterViewItem:footerViewItem];
        
        NSMutableArray *cellItems = [[NSMutableArray alloc] init];
        for (int i = 0; i < 30; i++) {
            TestTableViewCellItem *cellItem =  [[TestTableViewCellItem alloc] init];
            [cellItem setTitle:[NSString stringWithFormat:@"%d", i]];
            cellItem.height = 50;
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
        
        for (int i = 31; i < 60; i++) {
            TestTableViewCellItem *cellItem =  [[TestTableViewCellItem alloc] init];
            [cellItem setTitle:[NSString stringWithFormat:@"%d", i]];
            cellItem.height = 50;
            
            [[[self.tableViewComponent.sectionItems lastObject] cellItems] addObject:cellItem];
        }
        
        [self reloadData];
    });
}

- (void)mapItemClassToViewClassWithTableViewComponent:(TableViewComponent *)tableViewComponent {
    [super mapItemClassToViewClassWithTableViewComponent:tableViewComponent];
    
    [tableViewComponent mapCellClass:[TestTableViewCell class] cellItemClass:[TestTableViewCellItem class]];
    
    [tableViewComponent mapHeaderOrFooterViewClass:[TestTableViewHeaderOrFooterView class] headerOrFooterViewItemClass:[TestTableViewHeaderOrFooterViewItem class]];
}

@end
