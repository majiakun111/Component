//
//  JSInterface.m
//  JSWebView
//
//  Created by Ansel on 16/3/16.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JSCallNavtiveInterface.h"

@implementation JSCallNavtiveInterface

- (void)setData: (NSString*)data forKey: (NSString*)key webView:(UIWebView *)webview callback:(void(^)(NSString *status, NSString *data))callback;
{
    if (callback) {
        callback(@"1", nil);
        callback = nil;
    }
}

- (void)getDataForKey:(NSString*)key webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback
{
    if (callback) {
        callback(@"1", @"Ansel");
        callback = nil;
    }
}

@end
