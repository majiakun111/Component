//
//  NSString+AES.m
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import "NSString+AES.h"
#import "NSData+AES.h"

@implementation NSString (AES)

- (NSString *)AES256EncryptWithKey:(NSString *)key
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptedData = [data AES256EncryptWithKey:key];
    
    NSString *base64String = [encryptedData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
   
    return base64String;
}

- (NSString *)AES256DecryptWithKey:(NSString *)key
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSData *decryptedData = [data AES256DecryptWithKey:key];
    
    NSString *decryptedString = [[NSString alloc] initWithData:decryptedData encoding:NSUTF8StringEncoding];
    
    return decryptedString;
}

@end
