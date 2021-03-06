//
//  TableViewCell.m
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "TableViewCell.h"
#import "CommonDefine.h"
#import "TableViewCellItem.h"

@implementation TableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

- (void)setItem:(__kindof TableViewCellItem *)item
{
    if (_item != item) {
        _item = nil;
        _item = item;
        
        [self updateUI];
    }
}

@end
