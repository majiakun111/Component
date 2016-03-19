//
//  JSInterface.h
//  JSWebView
//
//  Created by Ansel on 16/3/16.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSCallNavtiveInterface : NSObject

- (void)setData: (NSString*)data forKey: (NSString*)key webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback;

- (void)getDataForKey:(NSString*)key webView:(UIWebView *)webView callback:(void(^)(NSString *status, NSString *data))callback;

@end
