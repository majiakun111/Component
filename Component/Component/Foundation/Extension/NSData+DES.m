//
//  NSData+DES.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSData+DES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (DES)

- (NSData *)DESEncryptWithKey:(NSString *)key
{
    return [self DESWitKey:key operation:kCCEncrypt];
}

- (NSData *)DESDecryptWithKey:(NSString *)key
{
    return [self DESWitKey:key operation:kCCDecrypt];
}

#pragma mark - PrivateMethod

- (NSData *)DESWitKey:(NSString *)key operation:(CCOperation)operation
{
    size_t bufferSize = ([self length] + kCCKeySizeDES) & ~(kCCKeySizeDES - 1);
    void *buffer = malloc(bufferSize);
    memset(buffer, 0x00, bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          NULL,
                                          [self bytes],
                                          [self length],
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    NSData *data = nil;
    if (cryptStatus == kCCSuccess) {
        data = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return data;
}

@end
