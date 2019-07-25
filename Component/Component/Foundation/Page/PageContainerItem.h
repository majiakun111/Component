//
//  PageContainerItem.h
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PageItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface PageContainerItem : NSObject

@property(nonatomic, strong) NSArray<__kindof PageItem *> *pageItems;

@end

NS_ASSUME_NONNULL_END
