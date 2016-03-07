//
//  CollectionViewController.h
//  Component
//
//  Created by Ansel on 16/3/4.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SectionItem;

@interface CollectionViewController : UIViewController

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray <SectionItem *> *sectionItems;

- (void)buildCollectionView;

@end
