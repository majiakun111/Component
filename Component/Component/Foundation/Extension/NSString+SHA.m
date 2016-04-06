//
//  NSString+SHA.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSString+SHA.h"
#import "NSData+SHA.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (SHA)

- (NSString *)SHA
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (uint32_t)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int index = 0; index < CC_SHA1_DIGEST_LENGTH; index++) {
        [output appendFormat:@"%02x", digest[index]];
    }
    
    return output;
}

@end
