//
//  NSString+DES.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "NSString+DES.h"
#import "NSData+DES.h"

@implementation NSString (DES)

- (NSString *)DESEncryptWithKey:(NSString *)key
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptdData = [data DESEncryptWithKey:key];
    
    NSString *base64String = [encryptdData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    return base64String;
}

- (NSString *)DESDecryptWithKey:(NSString *)key
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptedData = [data DESDecryptWithKey:key];
    
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

@end
