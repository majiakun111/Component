//
//  TipsDefine.h
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#ifndef TipsDefine_h
#define TipsDefine_h

/* LoadingTips type */
#define LoadingTipsTypeTable         \
X(ENBaseLoadingTips)                 \

#define X(a)    a
typedef NS_ENUM(NSInteger, LoadingTipsType) {
   LoadingTipsTypeTable
};
#undef X

#define X(a)    @#a
NSString* const LoadingTipsTypeToString[] = {
    LoadingTipsTypeTable
};
#undef X

#endif /* TipsDefine_h */
