//
//  HorizontalTableView.h
//  Component
//
//  Created by Ansel on 2018/12/6.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class HorizontalTableView;

@protocol HorizontalTableViewDataSource <NSObject>

@required
- (NSInteger)tableView:(HorizontalTableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (__kindof HorizontalTableViewCell *)tableView:(HorizontalTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionsInTableView:(HorizontalTableView *)tableView;

@end

@protocol HorizontalTableViewDelegate <NSObject, UIScrollViewDelegate>

@optional
- (CGFloat)tableView:(HorizontalTableView *)tableView widthForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(HorizontalTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(HorizontalTableView *)tableView willDisplayCell:(__kindof HorizontalTableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(HorizontalTableView *)tableView didEndDisplayingCell:(__kindof HorizontalTableViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface HorizontalTableView : UIScrollView

@property (nonatomic, weak) id<HorizontalTableViewDataSource> dataSource;
@property (nonatomic, weak) id<HorizontalTableViewDelegate> delegate;

- (__kindof HorizontalTableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;

- (void)reloadData;

@end


NS_ASSUME_NONNULL_END
