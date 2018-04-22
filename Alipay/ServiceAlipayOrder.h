//
//  ServiceAlipayOrder.h
//  Dandanjia
//
//  Created by qiuyoubo on 15/6/29.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ServiceAlipayConfig;
@interface ServiceAlipayOrder : NSObject

/*
    用1 或 2 生成order  然后 调用3 生成generate字符串
 */

//1
+ (id)orderWithOrderNo:(NSString *)no name:(NSString *)name description:(NSString *)description price:(NSString *)price payId:(NSString *)payId notifyUrl:(NSString *)notifyUrl;
//2
+ (id)orderWithServerGenerateString:(NSString *)generate;//服务端生成校验的字符串

//3
- (NSString *)generateWithConfig:(ServiceAlipayConfig *)config;
@end
