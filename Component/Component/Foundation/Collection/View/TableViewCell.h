//
//  TableViewCell.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TableViewCellItem;

@protocol TableViewCellDelegate <NSObject>
@optional

@end

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) __kindof TableViewCellItem *item; //通常是 __kindof  TableViewCellItem

@property (nonatomic, weak) id <TableViewCellDelegate> delegate;

- (void)buildUI;

- (void)updateUI;

@end
