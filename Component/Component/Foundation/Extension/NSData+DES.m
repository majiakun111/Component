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
    char cKey[kCCKeySizeAES256+1];
    bzero(cKey, sizeof(cKey));
    
    [key getCString:cKey maxLength:sizeof(cKey) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          cKey,
                                          kCCBlockSizeDES,
                                          NULL,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    
    NSData *encryptData = nil;
    if (cryptStatus == kCCSuccess) {
        encryptData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return encryptData;
}

- (NSData *)DESDecryptWithKey:(NSString *)key
{
    char cKey[kCCKeySizeAES256+1];
    bzero(cKey, sizeof(cKey));
    
    [key getCString:cKey maxLength:sizeof(cKey) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(dataLength);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          cKey,
                                          kCCBlockSizeDES,
                                          NULL,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          dataLength,
                                          &numBytesDecrypted);
    
    NSData *decryptData = nil;
    if (cryptStatus == kCCSuccess) {
        decryptData = [NSData dataWithBytes:buffer length:numBytesDecrypted];
    }
    
    free(buffer);
    return decryptData;
}


@end
