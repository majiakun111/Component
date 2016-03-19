//
//  WebViewProxy.m
//  JSWebView
//
//  Created by Ansel on 16/3/15.
//  Copyright © 2016年 PingAn. All rights reserved.
//

#import "JavascriptWebViewBridgeHelper.h"
#import "JavascriptInterfaceManager.h"

#import <objc/runtime.h>

#define kCustomProtocolScheme @"mjkscheme"
#define kQueueHasMessage      @"__MJK_QUEUE_MESSAGE__"

typedef void (^ResponseCallback)(NSString *status, id responseData);

@implementation JavascriptWebViewBridgeHelper

/**
 * js -> oc
 *   {
 *      interfaceIdentifier : '',//接口标识
 *      methodName: @"setData: forKey: callback:",  //webView需要自己加入
 *      args:[
 *        {
 *          type:'object', //参数类型
 *          value:'Ansel',//参数的值
 *        },
 *        
 *        {
 *          type = 'function',  // 当type是function时 value 是 callbackId
 *          value: 'callbackId',
 *        }
 *      ],
 *
 *   }
 *
 *   oc -> js  //oc call js  callback
 *   {
 *      responseId:'',
 *      status:'',
 *      responseData : ''
 *   }
 *
 */


- (void)handleFromJSMessage:(NSString *)messageString forWebView:(UIWebView *)webView
{
    id messages = [self deserializeMessageJSON:messageString];
    
    if (![messages isKindOfClass:[NSArray class]]) {
        NSLog(@"JavascriptWebViewBridge: WARNING: Invalid %@ received: %@", [messages class], messages);
        return;
    }
    
    for (NSDictionary* message in messages) {
        if (![message isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JavascriptWebViewBridge: WARNING: Invalid %@ received: %@", [message class], message);
            continue;
        }
        
        NSString *interfaceIdentifier = message[@"interfaceIdentifier"];
        
        id interface = [[JavascriptInterfaceManager shareInstance] getJavascriptInterfaceInterfaceIdentifier:interfaceIdentifier];
       
        NSMutableString *method  = [NSMutableString stringWithFormat:@"%@", message[@"methodName"]];
        //还原webView参数和callback:参数, 在尾部追加webView:callback:
        [method appendString:@"webView:callback:"];
         SEL selector = NSSelectorFromString(method);
        
        if (![interface respondsToSelector:selector]) {
            NSLog(@"JavascriptWebViewBridge: WARNING:  %@ not found", method);
            return;
        }

        // execute the interfacing method
        NSMethodSignature* sig = [[interface class] instanceMethodSignatureForSelector:selector];
        NSInvocation* invoker = [NSInvocation invocationWithMethodSignature:sig];
        invoker.selector = selector;
        invoker.target = interface;
        
        NSMutableArray *args = [NSMutableArray arrayWithArray:message[@"args"]];
        if ([args count] >= 1) {
            NSDictionary *webViewArg = @{@"type": @"object", @"value" : webView};
            [args insertObject:webViewArg atIndex:[args count] -1];
        }
        
        ResponseCallback responseCallback = nil;
        for (NSInteger index = 0; index < [args count]; index++) {
            NSDictionary *arg = args[index];
            id value = arg[@"value"];

            NSString *type = arg[@"type"];
            if ([type isEqualToString:@"object"]) {
                [invoker setArgument:&value atIndex:(index + 2)];
            }
            else if ([type isEqualToString:@"function"]) {
                __block id callbackId = [value copy];
                if (callbackId) { //value 是callbackId
                    responseCallback = ^(NSString *status, id responseData) {
                        if (responseData == nil) {
                            responseData = @"";
                        }

                        NSDictionary* msg = @{ @"responseId": callbackId, @"status":status, @"responseData":responseData};
                        [self dispatchMessage:msg];
                        callbackId = nil;
                    };
                } else {
                    responseCallback = ^(NSString *status, id ignoreResponseData) {
                        // Do nothing
                    };
                }
                
                [invoker setArgument:&responseCallback atIndex:(index + 2)];
            }
        }
        
        [invoker invoke];
    }
}

- (void)injectJavascriptFile
{
    //需要修改
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JavascriptWebViewBridge.js" ofType:@"txt"];
    NSString *js = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    [self evaluateJavascript:js];
}

- (void)injectInterfaces
{
    NSMutableString* injection = [[NSMutableString alloc] init];
    NSDictionary *interfacesMap = [[JavascriptInterfaceManager shareInstance] getInterfacesMap];
    
    //inject the javascript interface
    for(NSString *interfaceIdentifier in interfacesMap) {
        NSObject* interface = [interfacesMap objectForKey:interfaceIdentifier];
        
        [injection appendString:@"JavascriptWebViewBridge.inject(\""];
        [injection appendString:interfaceIdentifier];
        [injection appendString:@"\", ["];
        
        unsigned int mc = 0;
        Class cls = object_getClass(interface);
        Method * mlist = class_copyMethodList(cls, &mc);
        for (int i = 0; i < mc; i++){
            [injection appendString:@"\'"];
            //去掉webView:callback:
            NSMutableString *name = [NSMutableString stringWithUTF8String:sel_getName(method_getName(mlist[i]))];
            [name replaceOccurrencesOfString:@"webView:callback:" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [name length])];
            [injection appendString:name];
            [injection appendString:@"\'"];
            
            if (i != mc - 1){
                [injection appendString:@", "];
            }
        }
        
        free(mlist);
        
        [injection appendString:@"]);"];
    }
    
    [self.delegate evaluateJavascript:injection];
}

-(BOOL)isCorrectProcotocolScheme:(NSURL*)url
{
    if([[url scheme] isEqualToString:kCustomProtocolScheme]){
        return YES;
    } else {
        return NO;
    }
}

-(BOOL)isCorrectHost:(NSURL*)url
{
    if([[url host] isEqualToString:kQueueHasMessage]){
        return YES;
    } else {
        return NO;
    }
}

-(void)logUnkownMessage:(NSURL*)url
{
    NSLog(@"JavascriptWebViewBridge: WARNING: Received unknown JavascriptWebViewBridge command %@://%@", kCustomProtocolScheme, [url path]);
}

#pragma mark - PrivateMethod

- (void) evaluateJavascript:(NSString *)javascriptCommand
{
    [self.delegate evaluateJavascript:javascriptCommand];
}

- (void)dispatchMessage:(NSDictionary *)message {
    NSString *messageJSON = [self serializeMessage:message];

    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\'" withString:@"\\\'"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\f" withString:@"\\f"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2028" withString:@"\\u2028"];
    messageJSON = [messageJSON stringByReplacingOccurrencesOfString:@"\u2029" withString:@"\\u2029"];
    
    NSString* javascriptCommand = [NSString stringWithFormat:@"JavascriptWebViewBridge.handleMessageFromObjC('%@');", messageJSON];
    if ([[NSThread currentThread] isMainThread]) {
        [self evaluateJavascript:javascriptCommand];
        
    } else {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self evaluateJavascript:javascriptCommand];
        });
    }
}

- (NSString *)serializeMessage:(id)message
{
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:message options:0 error:nil] encoding:NSUTF8StringEncoding];
}

- (NSArray*)deserializeMessageJSON:(NSString *)messageJSON
{
    return [NSJSONSerialization JSONObjectWithData:[messageJSON dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingAllowFragments error:nil];
}

@end
