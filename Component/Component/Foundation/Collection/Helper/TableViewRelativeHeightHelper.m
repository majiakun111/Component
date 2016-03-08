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

- (CGFloat)getCellHeightWithItem:(TableViewCellItem *)item cellClass:(Class)cellClass
{
    CGFloat height = 0.0;
    
    if ([item respondsToSelector:@selector(height)]) {
        height = [item height];
    }
    
    return height;
}

- (CGFloat)getHeaderOrFooterHeightWithItem:(HeaderOrFooterViewItem *)item headerClass:(Class)headerClass
{
    CGFloat height = 0.0;
    
    if ([item respondsToSelector:@selector(height)]) {
        height = [item height];
    }
    
    return height;
}

@end
