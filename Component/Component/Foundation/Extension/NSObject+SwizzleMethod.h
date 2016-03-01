//
//  NSObject+SwizzleMethod.h
//  Component
//
//  Created by Ansel on 16/2/27.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SwizzleMethod)

+ (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)swizzledSel;
- (BOOL)swizzleMethod:(SEL)originalSel withMethod:(SEL)swizzledSel;

@end
