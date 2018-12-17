//
//  TestNestTableViewController.m
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "TestNestTableViewController.h"
#import "TestCollectionViewCell.h"
#import "TestCollectionViewCellItem.h"

@implementation TestNestTableViewTopSectionCellItem

@end

@implementation TestNestTableViewTopSectionCell

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

@interface TestNestTableViewController ()

@end

@implementation TestNestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - Overrdir
- (void)mapItemClassToViewClassWithTableViewComponent:(TableViewComponent *)tableViewComponent {
    [super mapItemClassToViewClassWithTableViewComponent:tableViewComponent];
    
    [tableViewComponent mapCellClass:[TestNestTableViewTopSectionCell class] cellItemClass:[TestNestTableViewTopSectionCellItem class]];
}

@end
