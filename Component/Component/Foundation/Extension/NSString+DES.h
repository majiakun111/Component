//
//  NSString+DES.h
//  Test
//
//  Created by Ansel on 16/4/6.
//  Copyright © 2016年 MJK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DES)

- (NSString *)DESEncryptWithKey:(NSString *)key;

- (NSString *)DESDecryptWithKey:(NSString *)key;


@end
