

//
//  CollectionViewSectionItem.m
//  Component
//
//  Created by Ansel on 16/3/8.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "CollectionViewSectionItem.h"
#import "CollectionViewCellItem.h"

@implementation CollectionViewSectionItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _inset = UIEdgeInsetsZero;
        _minimumInteritemSpacing = 0.0f;
        _minimumLineSpacing = 0.0f;
    }
    
    return self;
}

- (NSMutableArray<__kindof CollectionViewCellItem *> *)cellItems
{
    if (_cellItems == nil) {
        _cellItems = [NSMutableArray array];
    }
    
    return _cellItems;
}

@end
