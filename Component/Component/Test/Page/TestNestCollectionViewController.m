//
//  TestNestTableViewController.m
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "TestNestCollectionViewController.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewCellItem.h"

@implementation TestNestCollectionViewTopSectionCellItem

@end

@implementation TestNestCollectionViewTopSectionCell

- (void)buildUI {
    [super buildUI];
    
    [self setBackgroundColor:[UIColor redColor]];
}

@end

@implementation TestNestPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor colorWithRed:(CGFloat)(arc4random() % 255) / 255.0 green:(CGFloat)(arc4random() % 255) / 255.0 blue:(CGFloat)(arc4random() % 255) / 255.0 alpha:1.0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSLog(@"--viewWillAppear--page:%@----", self);
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSLog(@"--viewDidAppear--page:%@----", self);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSLog(@"--viewWillDisappear--page:%@----", self);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    NSLog(@"--viewDidDisappear--page:%@----", self);
}

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [collectionViewComponent mapCellClass:[TestCollectionViewCell class] cellItemClass:[TestCollectionViewCellItem class]];
}

@end

@interface TestNestCollectionViewController ()

@end

@implementation TestNestCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Overrdie
//majiakun
- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent {
    [super mapItemClassToViewClassWithCollectionViewComponent:collectionViewComponent];
    
    [collectionViewComponent mapCellClass:[TestNestCollectionViewTopSectionCell class] cellItemClass:[TestNestCollectionViewTopSectionCellItem class]];
}

@end
