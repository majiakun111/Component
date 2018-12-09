//
//  CollectionViewCell.m
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "CollectionViewCell.h"
#import "CollectionViewCellItem.h"

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    
    return self;
}

- (void)buildUI
{
    
}

- (void)updateUI
{
    
}

#pragma mark - property

- (void)setItem:(__kindof CollectionViewCellItem *)item
{
    if (_item != item) {
        _item = nil;
        _item = item;
        
        [self updateUI];
    }
}

@end
