//
//  ServiceAlipayConfig.h
//  Dandanjia
//
//  Created by qiuyoubo on 15/6/29.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceAlipayAuthConfig : NSObject

@property (nonatomic, strong) NSString *    pid;
@property (nonatomic, strong) NSString *    appId;
@property (nonatomic, retain) NSString *	publicKey;
@property (nonatomic, retain) NSString *	privateKey;

@property (nonatomic, copy)   NSString *    alipay_scheme;//跳转回来用的scheme，在info.plist中配置
@end
