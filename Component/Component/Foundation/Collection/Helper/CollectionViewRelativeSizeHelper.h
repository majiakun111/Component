//
//  CollectionViewRelativeSizeHelper.h
//  Component
//
//  Created by Ansel on 16/3/8.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CollectionViewCellItem;
@class ReusableViewItem;

@interface CollectionViewRelativeSizeHelper : NSObject

- (CGSize)getCellSizetWithItem:(CollectionViewCellItem *)item cellClass:(Class)cellClass;

- (CGSize)getReuseableViewSizeWithItem:(ReusableViewItem *)item reuseableView:(Class)reuseableView;

@end
