//
//  JSWebView.m
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JavascriptInterfaceManager.h"

@class JSCallNavtiveInterface;

@interface JavascriptInterfaceManager ()

@property (nonatomic, strong) NSMutableDictionary<NSString *, JSCallNavtiveInterface*> *interfacesMap;

@end

@implementation JavascriptInterfaceManager

+ (instancetype)shareInstance
{
    static JavascriptInterfaceManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[JavascriptInterfaceManager alloc] init];
        }
    });
    
    return instance;
}

- (void)addJavascriptInterface:(id)interface interfaceIdentifier:(NSString *)interfaceIdentifier
{
    [self.interfacesMap setObject:interface forKey:interfaceIdentifier];
}

- (id)getJavascriptInterfaceInterfaceIdentifier:(NSString *)interfaceIdentifier
{
    return [self.interfacesMap objectForKey:interfaceIdentifier];
}

- (NSDictionary *)getInterfacesMap
{
    return self.interfacesMap;
}

#pragma mark - 

- (NSMutableDictionary *)interfacesMap
{
    if (nil == _interfacesMap) {
        _interfacesMap = [[NSMutableDictionary alloc] init];
    }
    
    return _interfacesMap;
}

@end
