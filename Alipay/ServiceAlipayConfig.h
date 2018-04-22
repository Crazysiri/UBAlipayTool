//
//  ServiceAlipayConfig.h
//  Dandanjia
//
//  Created by qiuyoubo on 15/6/29.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceAlipayConfig : NSObject
//new
@property (nonatomic, strong) NSString *    appId;
//old
@property (nonatomic, retain) NSString *	parnter;
@property (nonatomic, retain) NSString *	seller;
@property (nonatomic, retain) NSString *	publicKey;
//public
@property (nonatomic, retain) NSString *	privateKey;
@property (nonatomic, retain) NSString *	notifyURL;

@property (nonatomic, copy)   NSString *    alipay_scheme;//跳转回来用的scheme，在info.plist中配置
@end
