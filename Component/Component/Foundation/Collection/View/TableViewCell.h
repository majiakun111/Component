//
//  TableViewCell.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CellItem;

@protocol TableViewCellDelegate <NSObject>
@optional

@end

@interface TableViewCell : UITableViewCell

@property (nonatomic, strong) __kindof CellItem *item; //通常是 __kindof  TableViewCellItem

@property (nonatomic, weak) id <TableViewCellDelegate> delegate;

- (void)buildUI;

- (void)updateUI;

@end
