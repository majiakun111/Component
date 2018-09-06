//
//  ViewController.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Highlight.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    [button setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateNormal];
    [button setHighlightImageWithScale:0];
    [button setImage:[UIImage imageNamed:@"PullToLoadMore"] forState:UIControlStateSelected];
    [button setHighlightSelectedImageWithScale:0];
    [button addTarget:self action:@selector(didClickButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //[button setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateSelected];
    
}

- (void)didClickButton:(UIButton *)sender {
    sender.selected = !(sender.selected);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
