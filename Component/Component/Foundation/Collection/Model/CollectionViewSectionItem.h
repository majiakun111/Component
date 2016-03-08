//
//  CollectionViewSectionItem.h
//  Component
//
//  Created by Ansel on 16/3/8.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReusableViewItem;
@class CollectionViewCellItem;

@interface CollectionViewSectionItem : NSObject

@property (nonatomic, strong) __kindof ReusableViewItem *headerViewItem;
@property (nonatomic, strong) NSMutableArray<__kindof CollectionViewCellItem *> *cellItems;
@property (nonatomic, strong) __kindof ReusableViewItem *footerViewItem;

@property (nonatomic, assign) UIEdgeInsets inset;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing; //最小列间距
@property (nonatomic, assign) CGFloat minimumLineSpacing; //最小行间距

@end
