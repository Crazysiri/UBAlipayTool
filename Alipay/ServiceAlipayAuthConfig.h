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

@end
