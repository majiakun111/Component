//
//  SwizzleCollectionMethod.h
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwizzleCollectionMethod : NSObject

+ (BOOL)swizzleCollectionMethod:(SEL)originalSel withMethod:(SEL)swizzledSel forClass:(Class)class;

@end
