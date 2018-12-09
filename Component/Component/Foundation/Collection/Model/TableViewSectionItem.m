//
//  SectionItem.m
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "TableViewSectionItem.h"

@implementation TableViewSectionItem

- (NSMutableArray<__kindof TableViewCellItem *> *)cellItems
{
    if (_cellItems == nil) {
        _cellItems = [NSMutableArray array];
    }
    
    return _cellItems;
}

@end
