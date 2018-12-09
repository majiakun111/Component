//
//  NSData+AES.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "NSData+AES.h"
#import <CommonCrypto/CommonCryptor.h>

@implementation NSData (AES)

- (NSData *)AES256EncryptWithKey:(NSString *)key
{
    char cKey[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(cKey, sizeof(cKey)); // fill with zeroes (for padding)
    
    [key getCString:cKey maxLength:sizeof(cKey) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesEncrypted);
    NSData *encryptedData = nil;
    if (cryptStatus == kCCSuccess) {
        encryptedData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
    }
    
    free(buffer);
    return encryptedData;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key
{
    char cKey[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    bzero(cKey, sizeof(cKey)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:cKey maxLength:sizeof(cKey) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          cKey,
                                          kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes],
                                          dataLength, /* input */
                                          buffer,
                                          bufferSize, /* output */
                                          &numBytesDecrypted);
    
    NSData *decryptedData = nil;
    if (cryptStatus == kCCSuccess) {
        decryptedData = [NSData dataWithBytes:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return decryptedData;
}

@end
