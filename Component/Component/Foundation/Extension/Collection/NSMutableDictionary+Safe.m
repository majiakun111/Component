//
//  NSMutableDictionary+Safe.m
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSMutableDictionary+Safe.h"
#import "SwizzleCollectionMethod.h"

@implementation NSMutableDictionary (Safe)

+ (void)load
{
#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class dictionaryM = [[NSMutableDictionary dictionary] class]; //__NSDictionaryM
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(setObject:forKey:) withMethod:@selector(safe_setObject:forKey:) forClass:dictionaryM];
    });
#endif
}

- (void)safe_setObject:(id)object forKey:(id <NSCopying>)key
{
    if (nil == object) {
        NSLog(@"%@ object is nil", NSStringFromSelector(_cmd));
        return;
    }
    
    if (key == nil) {
        NSLog(@"%@ key is nil", NSStringFromSelector(_cmd));
        return;
    }
    
    [self safe_setObject:object forKey:key];
}

@end
