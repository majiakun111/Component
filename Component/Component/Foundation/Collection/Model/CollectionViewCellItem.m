//
//  CollectionViewCellItem.m
//  Component
//
//  Created by Ansel on 16/3/5.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "CollectionViewCellItem.h"

@implementation CollectionViewCellItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _size = CGSizeMake(120, 120);
    }
    
    return self;
}

@end
