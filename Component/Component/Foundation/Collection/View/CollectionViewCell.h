//
//  CollectionViewCell.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCellItem.h"

@interface CollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) __kindof CollectionViewCellItem *item;

@end
