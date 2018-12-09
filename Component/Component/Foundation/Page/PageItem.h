//
//  CollectionViewPageItem.h
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectionViewSectionItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageItem : NSObject

@property(nonatomic, strong) NSArray<__kindof CollectionViewSectionItem *> *sectionItems;

@end

NS_ASSUME_NONNULL_END
