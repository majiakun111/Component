//
//  CollectionViewReusableView.m
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "ReusableView.h"
#import "ReusableViewItem.h"

@implementation ReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
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

- (void)setItem:(__kindof ReusableViewItem *)item
{
    if (_item != item) {
        _item = nil;
        _item = item;
        
        [self updateUI];
    }
}


@end
