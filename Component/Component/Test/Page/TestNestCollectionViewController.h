//
//  TestNestTableViewController.h
//  Component
//
//  Created by Ansel on 2018/12/13.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "CollectionViewCellItem.h"
#import "CollectionViewCell.h"
#import "PageViewController+Nest.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestNestCollectionViewTopCellItem :CollectionViewCellItem

@end

@interface TestNestCollectionViewTopCell : CollectionViewCell

@end

@interface TestNestPageViewController : PageViewController

@end

@interface TestNestCollectionViewController : UIViewController

- (instancetype)initWithSectioItems:(NSArray<__kindof CollectionViewSectionItem *> *)sectionItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
