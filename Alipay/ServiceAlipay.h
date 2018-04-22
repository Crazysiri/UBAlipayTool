//
//  ServiceAlipay.h
//  Dandanjia
//
//  Created by qiuyoubo on 15/6/29.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#define USING_ALIPAY 1

#import <Foundation/Foundation.h>
#import "ServiceAlipayConfig.h"
#import "ServiceAlipayOrder.h"
/**
 *  使用方法：
 *          1.在appdelegate 中设置 ServiceAlipayConfig（单例）中相关参数（包括alipay_scheme）
 *          3.生成ServiceAlipayOrder *order;
 *          4.调用ServiceAlipay 中payWithOrder:方法
 *          5.appdelegate 回调openURL中调用 ServiceAlipay的handleResultUrl:方法;
 *          
 *
 */


typedef NS_ENUM(NSInteger, AlipayStatus) {
    AlipayStatusSuccess = 9000,
    AlipayStatusErrorSystem = 4000,
    AlipayStatusErrorBadFormat = 4002,
    AlipayStatusErrorBadAccount = 4003,
    AlipayStatusErrorUnbinded = 4004,
    AlipayStatusErrorCannotBind = 4005,
    AlipayStatusErrorExpired = 4010,
    AlipayStatusErrorMaintenance = 6000,
    AlipayStatusErrorUserCancel = 6001,
    AlipayStatusErrorInvalidData = -1,
    AlipayStatusErrorInstallAlipay = -2,
    AlipayStatusErrorSignature = -3
};

@interface ServiceAlipay : NSObject
@property (readonly, nonatomic) ServiceAlipayConfig *config;

@property (nonatomic, readonly) BOOL					ready;
@property (nonatomic, readonly) BOOL					installed;
@property (nonatomic, assign) AlipayStatus				errorCode;
@property (nonatomic, retain) NSString *				errorDesc;


+ (id)sharedInstance;

+ (BOOL)installed;

- (void)payWithOrder:(ServiceAlipayOrder *)order succeed:(void(^)(void))succeed failed:(void(^)(void))failed;
- (void)handleResultUrl:(NSURL *)url;
@end
