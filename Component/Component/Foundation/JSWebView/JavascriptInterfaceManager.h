//
//  JSWebView.h
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JavascriptInterfaceManager : NSObject

+ (instancetype)shareInstance;

- (void)addJavascriptInterface:(id)interface interfaceIdentifier:(NSString *)interfaceIdentifier;

- (id)getJavascriptInterfaceInterfaceIdentifier:(NSString *)interfaceIdentifier;

- (NSDictionary *)getInterfacesMap;

@end
