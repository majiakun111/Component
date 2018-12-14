//
//  PageTitleView.m
//  Component
//
//  Created by Ansel on 2018/12/11.
//  Copyright © 2018 MJK. All rights reserved.
//

#import "PageTitleView.h"
#import "CollectionViewCellItem.h"
#import "CollectionViewCell.h"
#import "Masonry.h"
#import "CollectionViewComponent.h"
#import "CollectionViewSectionItem.h"
#import "UIView+Coordinate.h"

CGFloat const PageTitleViewForUnderSeparationLineHeight = 1.0;
CGFloat const PageTitleViewForSelectionIndicatorViewHeight = 2.0;

NSInteger const PageTitleViewDefalutSelectedIndex = 0;

#define PageTitleViewTitleDefaultColor [UIColor redColor]
#define PageTitleViewTitleSelectedDefaultColor [UIColor purpleColor]
#define PageTitleViewTitleDefaultFont [UIFont systemFontOfSize:16]
NSInteger const PageTitleViewTitleDefalutPadding = 10;

#define PageTitleViewUnderSeparationLineDefaultColor [UIColor grayColor]
#define PageTitleViewSelectedIndicatorViewDefaultColor [UIColor redColor]

@interface PageTitleLabel : UILabel

@property(nonatomic, assign) CGFloat selectedIndicatorViewWidth;

@end

@implementation PageTitleLabel

@end

//category view
@interface PageTitleView ()

@property(nonatomic, strong) NSArray<NSString *> *titles;
@property(nonatomic, strong) NSArray<PageTitleLabel *> *titleLabels;
@property(nonatomic, strong) UIScrollView *containerView;
@property(nonatomic, strong) UIView *innerContainerView;

@property(nonatomic, strong) UIView *underSeparationLine;
@property(nonatomic, strong) UIView *selectedIndicatorView;

@property (nonatomic, assign) NSUInteger currentIndex;
@property (nonatomic, assign) CGFloat indexProgress;

@end

@implementation PageTitleView

- (instancetype)initWithTitles:(NSArray<NSString *>*)titles {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _currentIndex = PageTitleViewDefalutSelectedIndex;
        _titePadding = PageTitleViewTitleDefalutPadding;
        _titles = titles;
    }
    
    return self;
}

- (void)updateIndexProgress:(CGFloat)indexProgress animated:(BOOL)animated {
    if (self.indexProgress == indexProgress) {
        return;
    }
    
    self.indexProgress = MAX(0, MIN(indexProgress, self.titles.count - 1));
    [self updateTitleColorAndSelectedIndicatorView];
    
    NSUInteger index = 0;
    if (self.currentIndex < self.indexProgress) {
        index = (NSUInteger)floor(self.indexProgress);
    }  else {
        index = (NSUInteger)ceil(self.indexProgress);
    }
    
    if (self.currentIndex == index) {
        return;
    }
    [self updateIndex:index animated:animated needExcuteCurrentIndexChangedBlock:NO];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(self.bounds, CGRectZero)) {
        [self layoutIfNeeded];
        [self.selectedIndicatorView setTop:self.height - PageTitleViewForSelectionIndicatorViewHeight];
        [self.selectedIndicatorView setHeight:PageTitleViewForSelectionIndicatorViewHeight];
        
        [self scrollToIndex:self.currentIndex animated:NO needExcuteCurrentIndexChangedBlock:NO];
    }
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    [self buildUI];
}

#pragma mark - Property

- (UIColor *)titleColor {
    return _titleColor ?: PageTitleViewTitleDefaultColor;
}

- (UIColor *)titleSelectedColor {
    return _titleSelectedColor ?: PageTitleViewTitleSelectedDefaultColor;
}

- (UIFont *)titleFont {
    return _titleFont ?: PageTitleViewTitleDefaultFont;
}

- (UIColor *)selectedIndicatorViewTintColor {
    return _selectedIndicatorViewTintColor ?: PageTitleViewSelectedIndicatorViewDefaultColor;
}

#pragma mark - PrivateUI

- (void)buildUI {
    if ([self.titles count] <= 0) {
        return;
    }
    
    [self.containerView removeFromSuperview];
    self.containerView = nil;
    
    [self setBackgroundColor:[UIColor clearColor]];
    [self addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.containerView addSubview:self.innerContainerView];
    [self.innerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
        make.height.equalTo(self.containerView.mas_height);
    }];
    
    NSMutableArray<PageTitleLabel *> *titleLabels = @[].mutableCopy;
    __block PageTitleLabel *preLabel = nil;
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull title, NSUInteger index, BOOL * _Nonnull stop) {
        PageTitleLabel *label = [[PageTitleLabel alloc] init];
        [label setText:title];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setFont:self.titleFont];
        [label setTag:index];
        [label setUserInteractionEnabled:YES];
        [label setBackgroundColor:[UIColor clearColor]];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTitleLabel:)];
        [label addGestureRecognizer:tapGestureRecognizer];
        
        CGFloat selectedIndicatorViewWidth = [self getWidthWithFont:self.titleFont height:INT_MAX forString:title];
        [label setSelectedIndicatorViewWidth:selectedIndicatorViewWidth];
        CGFloat width = selectedIndicatorViewWidth + self.titePadding * 2;
        [self.innerContainerView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(preLabel ? preLabel.mas_right : @0);
            make.width.equalTo(@(width));
            make.top.equalTo(self.innerContainerView.mas_top);
            make.bottom.equalTo(self.innerContainerView.mas_bottom);
        }];
        
        if (index == self.currentIndex) {
            [label setTextColor:self.titleSelectedColor];
        } else {
            [label setTextColor:self.titleColor];
        }
        
        [titleLabels addObject:label];
        preLabel = label;
    }];
    self.titleLabels = titleLabels;
    [self.innerContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(preLabel.mas_right);
    }];
    
    [self.innerContainerView addSubview:self.underSeparationLine];
    [self.underSeparationLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.mas_bottom);
        make.height.mas_equalTo(PageTitleViewForUnderSeparationLineHeight);
    }];

    [self.innerContainerView addSubview:self.selectedIndicatorView];
}

#pragma mark - PrivateProperty

- (UIScrollView *)containerView {
    if (nil == _containerView) {
        _containerView = [[UIScrollView alloc] init];
        [_containerView setBackgroundColor:[UIColor clearColor]];
        [_containerView setShowsVerticalScrollIndicator:NO];
        [_containerView setShowsHorizontalScrollIndicator:NO];
    }
    
    return _containerView;
}

- (UIView *)innerContainerView {
    if (nil == _innerContainerView) {
        _innerContainerView = [[UIView alloc] init];
        [_innerContainerView setBackgroundColor:[UIColor clearColor]];
    }
    
    return _innerContainerView;
}

- (UIView *)underSeparationLine {
    if (nil == _underSeparationLine) {
        _underSeparationLine = [[UIView alloc] initWithFrame:CGRectZero];
        [_underSeparationLine setBackgroundColor:self.underSeparationLineTintColor];
        [_underSeparationLine setUserInteractionEnabled:YES];
    }
    
    return _underSeparationLine;
}

- (UIView *)selectedIndicatorView {
    if (nil == _selectedIndicatorView) {
        _selectedIndicatorView = [[UIView alloc] initWithFrame:CGRectZero];
        [_selectedIndicatorView setBackgroundColor:self.selectedIndicatorViewTintColor];
        [_selectedIndicatorView.layer setCornerRadius:1.0];
        [_selectedIndicatorView.layer setMasksToBounds:YES];
        [_selectedIndicatorView setUserInteractionEnabled:YES];
    }
    
    return _selectedIndicatorView;
}

#pragma mark - PrivateMethod

- (void)tapTitleLabel:(UITapGestureRecognizer *)gestureRecognizer {
    [self updateIndex:[gestureRecognizer view].tag animated:YES needExcuteCurrentIndexChangedBlock:YES];
}

-(CGFloat)getWidthWithFont:(UIFont *)font height:(float)height forString:(NSString *)string {
    NSDictionary *attributes = @{NSFontAttributeName:font};
    CGRect rect = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:attributes context:nil];
    return rect.size.width;
}

- (void)updateIndex:(NSInteger)index animated:(BOOL)animated needExcuteCurrentIndexChangedBlock:(BOOL)needExcuteCurrentIndexChangedBlock {
    if (index == self.currentIndex) {
        return;
    }
    
    [self scrollToIndex:index animated:animated needExcuteCurrentIndexChangedBlock:needExcuteCurrentIndexChangedBlock];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated needExcuteCurrentIndexChangedBlock:(BOOL)needExcuteCurrentIndexChangedBlock {
    CGFloat lastIndex = self.currentIndex;
    PageTitleLabel *lastTitleLable = [self.titleLabels objectAtIndex:lastIndex];
    [lastTitleLable setTextColor:self.titleColor];
    
    self.currentIndex = self.titles.count ? MIN(self.titles.count - 1, index) : 0;
    PageTitleLabel *currentTitleLabel = [self.titleLabels objectAtIndex:self.currentIndex];
    [currentTitleLabel setTextColor:self.titleSelectedColor];
    
    CGFloat offsetX = 0.0;
    if (self.containerView.contentSize.width  <= self.containerView.width ||
        currentTitleLabel.left < (self.containerView.width - currentTitleLabel.width) / 2) {
        offsetX = 0.0;
    } else if (currentTitleLabel.left  > self.containerView.contentSize.width - (self.containerView.width + currentTitleLabel.width) / 2) {
        offsetX = self.containerView.contentSize.width - self.containerView.width;
    } else {
        offsetX = currentTitleLabel.left - (self.containerView.width - currentTitleLabel.width) / 2;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.selectedIndicatorView setWidth:currentTitleLabel.selectedIndicatorViewWidth];
        [self.selectedIndicatorView setCenterX:currentTitleLabel.centerX];
        [self.containerView setContentOffset:CGPointMake(offsetX, 0)];
    } completion:^(BOOL finished) {
        if (needExcuteCurrentIndexChangedBlock && self.currentIndexChangedBlock) {
            self.currentIndexChangedBlock(self.currentIndex);
        }
    }];
}

- (void)updateTitleColorAndSelectedIndicatorView {
    NSUInteger preIndex = (NSUInteger)floorf(self.indexProgress);
    PageTitleLabel *preTitleLabel = [self.titleLabels objectAtIndex:preIndex];

    NSUInteger nextIndex = (NSUInteger)ceilf(self.indexProgress);
    PageTitleLabel *nextTitleLabel = [self.titleLabels objectAtIndex:nextIndex];
    
    CGFloat lableCenterXGap = nextTitleLabel.centerX - preTitleLabel.centerX;
    if (self.indexProgress > self.currentIndex) {
        CGFloat progress = self.indexProgress - preIndex;
        [preTitleLabel setTextColor:[self colorFrom:self.titleSelectedColor to:self.titleColor progress:progress ignoreAlpha:NO]];
        [nextTitleLabel setTextColor:[self colorFrom:self.titleColor to:self.titleSelectedColor progress:progress ignoreAlpha:NO]];
        
        if (progress * lableCenterXGap > self.titePadding + preTitleLabel.selectedIndicatorViewWidth / 2) {
            [self.selectedIndicatorView setWidth:nextTitleLabel.selectedIndicatorViewWidth];
        } else {
            [self.selectedIndicatorView setWidth:preTitleLabel.selectedIndicatorViewWidth];
        }
        [self.selectedIndicatorView setCenterX:(preTitleLabel.centerX) + lableCenterXGap * progress];
    } else {
        CGFloat progress = nextIndex - self.indexProgress;
        [preTitleLabel setTextColor:[self colorFrom:self.titleColor to:self.titleSelectedColor progress:progress ignoreAlpha:NO]];
        [nextTitleLabel setTextColor:[self colorFrom:self.titleSelectedColor to:self.titleColor progress:progress ignoreAlpha:NO]];
        
        if (progress * lableCenterXGap > self.titePadding + nextTitleLabel.selectedIndicatorViewWidth / 2) {
            [self.selectedIndicatorView setWidth:preTitleLabel.selectedIndicatorViewWidth];
        } else {
            [self.selectedIndicatorView setWidth:nextTitleLabel.selectedIndicatorViewWidth];
        }
        [self.selectedIndicatorView setCenterX:(nextTitleLabel.centerX) - lableCenterXGap * progress];
    }
}

- (UIColor *)colorFrom:(UIColor *)fromColor to:(UIColor *)toColor progress:(CGFloat)progress ignoreAlpha:(BOOL)ignoreAlpha {
    if (!fromColor || !toColor) {
        return nil;
    }
    
    if (progress <= 0) {
        return fromColor;
    }
    if (progress >= 1) {
        return toColor;
    }
    
    CGFloat fromRed = 0.0, fromGreen = 0.0, fromBlue = 0.0, fromAlpha = 0.0;
    [fromColor getRed:&fromRed
                green:&fromGreen
                 blue:&fromBlue
                alpha:&fromAlpha];
    
    CGFloat toRed = 0.0, toGreen = 0.0, toBlue = 0.0, toAlpha = 0.0;
    [toColor getRed:&toRed
              green:&toGreen
               blue:&toBlue
              alpha:&toAlpha];
    
    return [[UIColor alloc] initWithRed:(fromRed + (toRed - fromRed) * progress)
                                  green:(fromGreen + (toGreen - fromGreen) * progress)
                                   blue:(fromBlue + (toBlue - fromBlue) * progress)
                                  alpha:(ignoreAlpha ? 1 : (fromAlpha + (toAlpha - fromAlpha) * progress))];
}


@end

