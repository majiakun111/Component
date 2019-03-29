//
//  ViewController.m
//  Component
//
//  Created by Ansel on 2018/9/6.
//  Copyright © 2018年 MJK. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+Highlight.h"
#import "UIImage+Color.h"
#import "ImagesConvertVideo.h"
#import "NSThread+KeepAlive.h"

@interface ViewController ()

@property(nonatomic, strong) NSThread *thread;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.thread = [NSThread keepAliveThread];
    [self.thread start];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:nil];
}

- (void)test {
    NSLog(@"x----");
 
    [self.thread setIsStop:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
