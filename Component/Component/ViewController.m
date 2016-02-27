//
//  ViewController.m
//  Component
//
//  Created by Ansel on 16/2/26.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "ViewController.h"
#import "CALayer+Aniamtion.h"

@interface ViewController ()

@property (nonatomic, strong) UIView *aniamtionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _aniamtionView = [[UIView alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
    [_aniamtionView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_aniamtionView];
    
    [self addAniamtion];
}

- (void)addAniamtion
{
    CABasicAnimation *translation = [CABasicAnimation animationWithKeyPath:@"position"];
    translation.fromValue = [NSValue valueWithCGPoint:CGPointMake(75, 75)];
    translation.toValue = [NSValue valueWithCGPoint:CGPointMake(175, 400)];
    translation.duration = 4;
    translation.repeatCount = INT32_MAX;
    translation.autoreverses = YES;
    
//    CABasicAnimation *rotation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    rotation.toValue = [NSNumber numberWithFloat:4 * M_PI];
//    rotation.duration = 2;
//    rotation.repeatCount = HUGE_VALF;
//    rotation.autoreverses = YES;
    
//    CAAnimationGroup *group= [CAAnimationGroup animation];
//    [group setAnimations:@[translation, rotation]];
    [self.aniamtionView.layer addAnimation:translation forKey:@"animation" completeBlock:^{
        NSLog(@"--finish--");
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
