//
//  SectionItem.m
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "SectionItem.h"

@implementation SectionItem

- (NSMutableArray<__kindof CellItem *> *)cellItems {
    if (_cellItems == nil) {
        _cellItems = [NSMutableArray array];
    }
    return _cellItems;
}

@end
