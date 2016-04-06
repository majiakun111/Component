
//
//  NSString+CCCrypt.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSString+MD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (MD5)

- (NSString *)MD5_16
{
    return [self MD5WithLength:CC_MD5_DIGEST_LENGTH];
}

- (NSString *)MD5_64
{
    return [self MD5WithLength:CC_MD5_BLOCK_BYTES];
}

- (NSString *)MD5WithLength:(NSInteger)length
{
    const char * cString = [self UTF8String];
    unsigned char cMd5[length];
    CC_MD5(cString, (unsigned int)strlen(cString), cMd5);
    
    NSMutableString *md5String = [NSMutableString string];
    for (NSInteger index = 0; index < length; index++) {
        [md5String appendFormat:@"%02X", cMd5[index]];
    }
    
    return md5String;
}

@end
