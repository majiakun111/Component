//
//  TestTableViewHeaderOrFooterView.m
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TestTableViewHeaderOrFooterView.h"
#import "TestTableViewHeaderOrFooterViewItem.h"

@interface TestTableViewHeaderOrFooterView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TestTableViewHeaderOrFooterView

- (void)buildUI
{
    [super buildUI];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    [_titleLabel setBackgroundColor:[UIColor redColor]];
    [_titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    
    [self addSubview:_titleLabel];
}

- (void)updateUI
{
    [super updateUI];
    
    [_titleLabel setText:[(TestTableViewHeaderOrFooterViewItem *)self.item title]];
}

@end
