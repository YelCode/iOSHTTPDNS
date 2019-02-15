//
//  CustomDNSManager.h
//  ShaXianStoreManagerApp
//
//  Created by YellBinn on 2018/12/4.
//  Copyright © 2018年 StarMan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDNSManager : NSObject

//单例
+ (instancetype)sharedClient;

/**
 获取请求的IP

 @param host host
 @return ip
 */
- (NSString *)requestIPWithHost:(NSString *)host;

/**
 替换请求的host

 @param request 请求
 @return 替换后的请求
 */
- (NSMutableURLRequest*)redirectHostInRequset:(NSMutableURLRequest*)request;

@end
