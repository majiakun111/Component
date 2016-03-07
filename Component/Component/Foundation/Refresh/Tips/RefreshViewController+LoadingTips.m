//
//  RefreshViewController+LoadingTips.m
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "RefreshViewController+LoadingTips.h"
#import "BaseLoadingTips.h"
#import <objc/runtime.h>
#import "UIView+Coordinate.h"
#import "NSObject+SwizzleMethod.h"

@interface LoadingTipsFactory : NSObject

+ (nullable __kindof BaseLoadingTips *)createLoadingTipsWithType:(LoadingTipsType)type frame:(CGRect)frame;

@end

@implementation LoadingTipsFactory

+ (nullable __kindof BaseLoadingTips *)createLoadingTipsWithType:(LoadingTipsType)type frame:(CGRect)frame
{
    BaseLoadingTips *loadingTips = nil;
    
    NSString *classString = LoadingTipsTypeToString[type];
    if ([classString  hasPrefix:@"EN"]) {
        classString = [classString substringFromIndex:2];
    }
    
    if ([classString hasSuffix:@"Type"]) {
        classString = [classString substringToIndex:[classString length] - 4];
    }
    
    Class class = NSClassFromString(classString);
    
    loadingTips = [[class alloc] initWithFrame:frame];
    
    return loadingTips;
}

@end


@interface RefreshViewController ()

@property (nonatomic, strong) BaseLoadingTips *loadingTips;

@end

@implementation RefreshViewController (LoadingTips)

@dynamic loadingTipsType;

- (void)setLoadingTipsType:(LoadingTipsType)loadingTipsType
{
     objc_setAssociatedObject(self, @selector(loadingTipsType), @(loadingTipsType), OBJC_ASSOCIATION_ASSIGN);
}

- (LoadingTipsType)loadingTipsType
{
    return [objc_getAssociatedObject(self, @selector(loadingTipsType)) integerValue];
}

- (BaseLoadingTips *)loadingTips
{
    BaseLoadingTips *tmpLoadingTips = objc_getAssociatedObject(self, @selector(loadingTips));
    if (nil == tmpLoadingTips) {
        CGRect rect = CGRectZero;
        if (self.navigationController) {
            rect = CGRectMake(0, STATUS_HEIGHT + NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - STATUS_HEIGHT - NAVIGATION_BAR_HEIGHT);
        }
        else {
            rect = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }
   
        tmpLoadingTips = [LoadingTipsFactory createLoadingTipsWithType:self.loadingTipsType frame:rect];
        
        [self setLoadingTips:tmpLoadingTips];
    }
    
    return tmpLoadingTips;
}

- (void)setLoadingTips:(BaseLoadingTips *)loadingTips
{
    objc_setAssociatedObject(self, @selector(loadingTips), loadingTips, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showLoadingTips
{
    if (![self.loadingTips superview]) {
        [self.view addSubview:self.loadingTips];
    }
    
    [self.view bringSubviewToFront:self.loadingTips];
}

- (void)hiddenLoadingTips
{
    [self.loadingTips removeFromSuperview];
    
    objc_setAssociatedObject(self, @selector(loadingTips), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}



@end
