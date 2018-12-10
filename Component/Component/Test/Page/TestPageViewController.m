//
//  TestPageViewController.m
//  Component
//
//  Created by Ansel on 2018/12/9.
//  Copyright © 2018 PingAn. All rights reserved.
//

#import "TestPageViewController.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewCellItem.h"

@interface TestPageViewController ()

@end

@implementation TestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)(arc4random() % 255) / 255.0 green:(CGFloat)(arc4random() % 255) / 255.0 blue:(CGFloat)(arc4random() % 255) / 255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"--viewWillAppear--vc:%@----", self);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"--viewDidAppear--vc:%@----", self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"--viewWillDisappear--vc:%@----", self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"--viewDidDisappear--vc:%@----", self);
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[TestCollectionViewCell class] cellItemClass:[TestCollectionViewCellItem class]];
}

@end
