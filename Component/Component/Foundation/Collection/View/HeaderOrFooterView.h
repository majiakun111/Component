//
//  TableViewHeaderView.h
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HeaderOrFooterViewItem;

@interface HeaderOrFooterView : UIView

@property (nonatomic, strong) __kindof HeaderOrFooterViewItem *item;

- (void)buildUI;

- (void)updateUI;

@end
