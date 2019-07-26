//
//  CollectionViewNestPageContainerViewControllerViewController.h
//  Component
//
//  Created by Ansel on 2018/12/12.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NestCollectionViewComponent.h"

NS_ASSUME_NONNULL_BEGIN

@interface NestCollectionViewController : UIViewController

- (instancetype)initWithSectioItems:(NSArray<__kindof CollectionViewSectionItem *> *)sectionItems NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;

- (void)mapItemClassToViewClassWithCollectionViewComponent:(CollectionViewComponent *)collectionViewComponent;

@end

NS_ASSUME_NONNULL_END
