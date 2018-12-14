//
//  TableViewHeaderView.h
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderOrFooterViewItem.h"

@protocol HeaderOrFooterViewDelegate <NSObject>

@end

@interface HeaderOrFooterView : UITableViewHeaderFooterView
{
    @protected
    __kindof HeaderOrFooterViewItem *_item;
}

@property(nonatomic, strong) __kindof HeaderOrFooterViewItem *item;

@property(nonatomic, assign) id<HeaderOrFooterViewDelegate> delegate;

- (void)buildUI;

- (void)updateUI;

@end
