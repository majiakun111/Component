//
//  CollectionViewPageItem.h
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionViewSectionItem.h"

@class PageItem;

NS_ASSUME_NONNULL_BEGIN

@protocol PageItemProtocol <NSObject>

@property(nonatomic, strong) PageItem *pageItem;

- (void)reloadDataWithPageItem:(__kindof PageItem *)pageItem;

@optional
@property(nonatomic, assign) BOOL canUpDownScroll;
@property(nonatomic, copy) void(^pageWillLeaveTopBlock)(void);

@end

@interface PageItem : NSObject

@property(nonatomic, strong) NSArray<__kindof CollectionViewSectionItem *> *sectionItems;

@property(nonatomic, strong) Class viewControllerClass; //PageItemProtocol

@end

NS_ASSUME_NONNULL_END
