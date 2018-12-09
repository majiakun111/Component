//
//  SectionItem.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TableViewCellItem;
@class HeaderOrFooterViewItem;

@interface TableViewSectionItem : NSObject

@property (nonatomic, strong) __kindof HeaderOrFooterViewItem *headerViewItem;
@property (nonatomic, strong) NSMutableArray<__kindof TableViewCellItem *> *cellItems;
@property (nonatomic, strong) __kindof HeaderOrFooterViewItem *footerViewItem;

@end
