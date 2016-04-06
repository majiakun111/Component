//
//  NSString+AES.h
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AES)

- (NSString *)AES256EncryptWithKey:(NSString *)key;

- (NSString *)AES256DecryptWithKey:(NSString *)key;

@end
