//
//  TableViewHeaderView.h
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderOrFooterViewItem;

@interface TableViewHeaderOrFooterView : UIView

@property (nonatomic, strong) __kindof HeaderOrFooterViewItem *item;

- (void)buildUI;

- (void)updateUI;

@end
