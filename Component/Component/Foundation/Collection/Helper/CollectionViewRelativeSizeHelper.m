//
//  CollectionViewRelativeSizeHelper.m
//  Component
//
//  Created by Ansel on 16/3/8.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "CollectionViewRelativeSizeHelper.h"
#import "CollectionViewCellItem.h"
#import "ReusableViewItem.h"

@implementation CollectionViewRelativeSizeHelper

- (CGSize)getCellSizetWithItem:(CollectionViewCellItem *)item cellClass:(Class)cellClass;
{
    CGSize size = CGSizeZero;
    if ([item respondsToSelector:@selector(size)]) {
        size = item.size;
    }
    
    return size;
}

- (CGSize)getReuseableViewSizeWithItem:(ReusableViewItem *)item reuseableView:(Class)reuseableView
{
    CGSize size = CGSizeZero;
    if ([item respondsToSelector:@selector(size)]) {
        size = item.size;
    }
    
    return size;
}

@end
