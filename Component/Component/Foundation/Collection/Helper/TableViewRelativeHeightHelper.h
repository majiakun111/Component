//
//  TableViewRelativeHeightHelper.h
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCellItem;
@class HeaderOrFooterViewItem;

@interface TableViewRelativeHeightHelper : NSObject

- (CGFloat)getCellHeightWithItem:(TableViewCellItem *)item cellClass:(Class)cellClass;

- (CGFloat)getHeaderOrFooterHeightWithItem:(HeaderOrFooterViewItem *)item headerClass:(Class)headerClass;

@end
