//
//  NSData+CCCrypt.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "NSData+MD5.h"
#import "NSString+MD5.h"

@implementation NSData (MD5)

- (NSData *)MD5_16
{
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    NSString *md5String = [string MD5_16];
    
    return [md5String dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSData *)MD5_64
{
    NSString *string = [[NSString alloc] initWithData:self encoding:NSUTF8StringEncoding];
    NSString *md5String = [string MD5_64];
    
    return [md5String dataUsingEncoding:NSUTF8StringEncoding];
}

@end
