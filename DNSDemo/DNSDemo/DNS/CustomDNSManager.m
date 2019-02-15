//
//  CustomDNSManager.m
//  ShaXianStoreManagerApp
//
//  Created by YellBinn on 2018/12/4.
//  Copyright © 2018年 StarMan. All rights reserved.
//

#import "CustomDNSManager.h"

@interface CustomDNSManager ()

@property (nonatomic,strong)NSMutableDictionary *dnsMap;

@end

@implementation CustomDNSManager

+ (instancetype)sharedClient {
    
    static CustomDNSManager *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        _sharedClient = [[CustomDNSManager alloc] init];
        _sharedClient.dnsMap = [NSMutableDictionary dictionaryWithCapacity:1];
    });
    return _sharedClient;
}

- (NSString *)requestIPWithHost:(NSString *)host {
    
    //本地Map获取IP
    __block NSString *ip = [self.dnsMap objectForKey:host];
    if (!ip) {
        //接口获取IP
        //同步block 可能会阻塞
#warning 此处接口获取host的IP
        NSString *hostIP = @"127.0.0.1";
#warning 此处进行IP缓存，应用生命周期内都有，重启之后清空，更完善的逻辑需要自己实现
        [self.dnsMap setValue:hostIP forKey:host];
        return hostIP;
    }else {
        return ip;
    }
}

- (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request
{
    if ([request.URL host].length == 0) {
        return request;
    }
    
    NSString *originUrlString = [request.URL absoluteString];
    NSString *originHostString = [request.URL host];
    NSRange hostRange = [originUrlString rangeOfString:originHostString];
    if (hostRange.location == NSNotFound) {
        return request;
    }
    
    //接入DNS组件 通过host获取ip
    NSString *ip = [[CustomDNSManager sharedClient] requestIPWithHost:originHostString];
    // 替换host
    NSString *urlString = [originUrlString stringByReplacingCharactersInRange:hostRange withString:ip];
    NSURL *url = [NSURL URLWithString:urlString];
    request.URL = url;
    //    [request setValue:originHostString forHTTPHeaderField:@"host"];
    return request;
}


@end
