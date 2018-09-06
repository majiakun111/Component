//
//  ViewController.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 PingAn. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Highlight.h"
#import "UIImage+Color.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 80, 80)];
    UIImage *image = [UIImage imageWithSize:CGSizeMake(80, 80) color:[UIColor redColor] cornerRadius:20 borderWidth:10 borderColor:[UIColor blueColor]];
    [button setImage:image forState:UIControlStateNormal];
    [button setHighlightImageWithScale:0];
    [self.view addSubview:button];
    //[button setImage:[UIImage imageNamed:@"loading"] forState:UIControlStateSelected];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
