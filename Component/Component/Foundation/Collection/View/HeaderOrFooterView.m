//
//  TableViewHeaderView.m
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "HeaderOrFooterView.h"
#import "HeaderOrFooterViewItem.h"

@implementation HeaderOrFooterView

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
    [self setBackgroundColor:[UIColor clearColor]];
}

- (void)updateUI
{
    
}

#pragma mark - property

- (void)setItem:(__kindof HeaderOrFooterViewItem *)item
{
    if (_item != item) {
        _item = nil;
        _item = item;
        
        [self updateUI];
    }
}

@end
