//
//  NSData+SHA.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "NSData+SHA.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (SHA)

- (NSData *)SHA
{
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(self.bytes, (uint32_t)self.length, digest);
    
    NSData *encryptData = [[NSData alloc]initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    return encryptData;
}

@end
