//
//  TableViewRelativeHeightHelper.h
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellItem;
@class HeaderOrFooterViewItem;

@interface TableViewRelativeHeightHelper : NSObject

- (CGFloat)getCellHeightWithItem:(CellItem *)item cellClass:(Class)cellClass;

- (CGFloat)getHeaderOrFooterHeightWithItem:(HeaderOrFooterViewItem *)item headerClass:(Class)headerClass;

@end
