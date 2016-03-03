//
//  NSDictionary+Safe.m
//  Component
//
//  Created by Ansel on 16/3/3.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSDictionary+Safe.h"
#import "NSObject+SwizzleMethod.h"
#import "SwizzleCollectionMethod.h"

@implementation NSDictionary (Safe)

+ (void)load
{
//#if !DEBUG
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{        
        [self swizzleMethod:@selector(initWithObjects:forKeys:)  withMethod:@selector(safe_initWithObjects:forKeys:)];
        
        Class dictionaryI = NSClassFromString(@"__NSDictionaryI");
        [SwizzleCollectionMethod swizzleCollectionMethod:@selector(objectForKey:) withMethod:@selector(safe_objectForKey:) forClass:dictionaryI];
    });
//#endif
}

- (instancetype)safe_initWithObjects:(NSArray *)objects forKeys:(NSArray <NSCopying> *)keys
{
    if ([objects count] != [keys count]) {
        NSLog(@"%@ [objects count] != [keys count]", NSStringFromSelector(_cmd));
        
        return nil;
    }
    
    return [self safe_initWithObjects:objects forKeys:keys];
}

- (id)safe_objectForKey:(id)key
{
    if (nil == key) {
        NSLog(@"%@ key is nil", NSStringFromSelector(_cmd));

        return nil;
    }
    
    id object = [self safe_objectForKey:key];
    if ([object isKindOfClass:[NSNull class]]) {
        object = nil;
    }
    
    return object;
}

@end
