//
//  CollectionViewReusableView.h
//  Component
//
//  Created by Ansel on 16/3/7.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReusableViewItem;

//header 和 footer
@interface ReusableView : UICollectionReusableView

@property (nonatomic, strong) __kindof ReusableViewItem *item;

- (void)buildUI;

- (void)updateUI;

@end
