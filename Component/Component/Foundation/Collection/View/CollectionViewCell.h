//
//  CollectionViewCell.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionViewCellDelegate <NSObject>
@optional

@end

@class CollectionViewCellItem;

@interface CollectionViewCell : UICollectionViewCell
{
    @protected
    CollectionViewCellItem *_item;
}

@property (nonatomic, strong) __kindof CollectionViewCellItem *item;

@property (nonatomic, weak) id <CollectionViewCellDelegate> delegate;

- (void)buildUI;

- (void)updateUI;

@end
