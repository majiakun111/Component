//
//  NSData+DES.h
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (DES)

- (NSData *)DESEncryptWithKey:(NSString *)key;

- (NSData *)DESDecryptWithKey:(NSString *)key;

@end
