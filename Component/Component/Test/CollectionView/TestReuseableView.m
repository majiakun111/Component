//
//  TestReuseableView.m
//  Component
//
//  Created by Ansel on 16/3/9.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "TestReuseableView.h"
#import "TestReusableViewItem.h"

@interface TestReuseableView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TestReuseableView

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
    
    TestReusableViewItem *item = self.item;
    [_titleLabel setText:[item title]];
}

@end
