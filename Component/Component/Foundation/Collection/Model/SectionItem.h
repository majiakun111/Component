//
//  SectionItem.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeaderOrFooterViewItem.h"

@class CellItem;

@interface SectionItem : NSObject

@property (nonatomic, strong) __kindof HeaderOrFooterViewItem *headerViewItem;
@property (nonatomic, strong) NSMutableArray<__kindof CellItem *> *cellItems;
@property (nonatomic, strong) __kindof HeaderOrFooterViewItem *footerViewItem;

@end
