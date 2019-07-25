//
//  CollectionViewReusableView.h
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReusableViewItem;

NS_ASSUME_NONNULL_BEGIN

@protocol ReusableViewDelegate <NSObject>

@end

//header 和 footer
@interface ReusableView : UICollectionReusableView
{
    ReusableViewItem *_item;
}
@property(nonatomic, weak) id<ReusableViewDelegate> delegate;
@property (nonatomic, strong) __kindof ReusableViewItem *item;

- (void)buildUI;

- (void)updateUI;

@end

NS_ASSUME_NONNULL_END
