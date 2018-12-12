//
//  PageTitleView.h
//  Component
//
//  Created by Ansel on 2018/12/11.
//  Copyright © 2018 MJK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PageTitleViewCurrentIndexChangedBlock)(NSUInteger currentIndex);

NS_ASSUME_NONNULL_BEGIN

@interface PageTitleView : UIView

- (instancetype)initWithTitles:(NSArray<NSString *>*)titles NS_DESIGNATED_INITIALIZER;
+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;

@property(nonatomic, strong) UIColor *titleColor;
@property(nonatomic, strong) UIColor *titleSelectedColor;
@property(nonatomic, strong) UIFont *titleFont;
@property(nonatomic, assign) CGFloat titePadding; //左右间距

- (void)updateIndexProgress:(CGFloat)indexProgress animated:(BOOL)animated;
@property(nonatomic, assign, readonly) NSUInteger currentIndex;
@property(nonatomic, copy) PageTitleViewCurrentIndexChangedBlock currentIndexChangedBlock;

@property(nonatomic, strong) UIColor *underSeparationLineTintColor;
@property(nonatomic, strong) UIColor *selectedIndicatorViewTintColor;

@end

NS_ASSUME_NONNULL_END


