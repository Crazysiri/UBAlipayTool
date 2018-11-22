//
//  ServiceAlipayAuthOrder.h
//  UBAlipayTool
//
//  Created by qiuyoubo on 2018/11/22.
//

#import <Foundation/Foundation.h>

@class ServiceAlipayAuthConfig;
@interface ServiceAlipayAuthOrder : NSObject
/*
 用1 或 2 生成order  然后 调用3 生成generate字符串
 */

//1
+ (id)orderWithAuthType:(NSString *)type;
//2
+ (id)orderWithServerGenerateString:(NSString *)generate;//服务端生成校验的字符串

//3
- (NSString *)generateWithConfig:(ServiceAlipayAuthConfig *)config;
@end
