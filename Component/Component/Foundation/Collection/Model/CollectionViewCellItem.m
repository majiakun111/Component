//
//  CollectionViewCellItem.m
//  Component
//
//  Created by Ansel on 16/3/5.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "CollectionViewCellItem.h"

@implementation CollectionViewCellItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _size = CGSizeMake(100, 100);
    }
    
    return self;
}

@end
