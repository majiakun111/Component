//
//  PullView.h
//  Refresh
//
//  Created by Ansel on 16/2/21.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    //header
    EGOPullRefreshPulling = 0,
    EGOPullRefreshNormal = 1,
    EGOPullRefreshRefreshing = 2,
    
    //footer
    EGOPullLoadMorePulling = 3,
    EGOPullLoadMorehNormal = 4,
    EGOPullLoadMoreLoading = 5,
} EGOPullState;

#define CONTENT_HEIGHT 60.f
#define REAL_WIDTH 94.0f //(image + label 及他们之间的间隙 所占的大小)
#define ANIMATION_TIME 0.2
#define ROTATION_ANIMATION_TIME 0.8

#define OFFSET_THRESHOLD 65.0
#define INSET  60.0f

@interface PullView : UIView
{
    UILabel *_statusLabel;
    CALayer *_arrowImageLayer;
    UIImageView *_loadingImageView;
    
    EGOPullState _state;
}

@property(nonatomic ,assign) EGOPullState state;
@property(nonatomic, retain) UILabel *statusLabel;
@property(nonatomic, retain) CALayer *arrowImageLayer;
@property(nonatomic, retain) UIImageView *loadingImageView;

@property (nonatomic, copy) NSString *normalStatusText;
@property (nonatomic, copy) NSString *pullingStatusText;
@property (nonatomic, copy) NSString *loadingStatusText;

@property (nonatomic, weak) __kindof UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame arrowImage:(NSString *)arrowImagName;

- (void)buildUI;

- (void)setState:(EGOPullState)aState;

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change;
- (void)scrollViewPanStateDidChange:(NSDictionary *)change;

@end
