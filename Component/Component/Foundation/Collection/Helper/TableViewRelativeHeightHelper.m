//
//  TableViewRelativeHeightHelper.m
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TableViewRelativeHeightHelper.h"
#import "TableViewCellItem.h"
#import "HeaderOrFooterViewItem.h"
#import "TableViewCell.h"

@implementation TableViewRelativeHeightHelper

- (CGFloat)getCellHeightWithItem:(CellItem *)item cellClass:(Class)cellClass
{
    CGFloat height = 0.0;
    
    if ([cellClass isSubclassOfClass:[TableViewCell class]]) {
        height = [(TableViewCellItem *)item height];
    }
    
    return height;
}

- (CGFloat)getHeaderOrFooterHeightWithItem:(HeaderOrFooterViewItem *)item headerClass:(Class)headerClass
{
    return item.height;
}

@end
