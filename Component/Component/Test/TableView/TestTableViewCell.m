//
//  TestTableViewCell.m
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TestTableViewCell.h"

@interface TestTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TestTableViewCell

- (void)buildUI
{
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    [_titleLabel setBackgroundColor:[UIColor yellowColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    [self.contentView addSubview:_titleLabel];
}

- (void)updateUI
{
    [super updateUI];
    
    self.titleLabel.text = [self.item title];
}

@end
