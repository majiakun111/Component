//
//  TestCollectionViewCell.m
//  Component
//
//  Created by Ansel on 16/3/8.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TestCollectionViewCell.h"
#import "TestCollectionViewCellItem.h"

@interface TestCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TestCollectionViewCell

- (void)buildUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [_titleLabel setBackgroundColor:[UIColor yellowColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    [self.contentView addSubview:_titleLabel];
}

- (void)updateUI
{
    [super updateUI];
    
    TestCollectionViewCellItem *item = self.item;
    self.titleLabel.text = [item title];
}


@end
