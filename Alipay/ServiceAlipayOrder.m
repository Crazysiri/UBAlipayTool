//
//  ServiceAlipayOrder.m
//  Dandanjia
//
//  Created by qiuyoubo on 15/6/29.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import "ServiceAlipayOrder.h"

#import "Order.h"
#import "ServiceAlipayConfig.h"
#import "APAuthV2Info.h"
#import "RSADataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
@interface ServiceAlipayOrder ()
@property (nonatomic, retain) NSString *	no;
@property (nonatomic, retain) NSString *	name;
@property (nonatomic, retain) NSString *	desc;
@property (nonatomic, retain) NSString *	price;

@property (nonatomic, strong) NSString *    pay_id;
@property (nonatomic, strong) NSString *    notify_Url;

@property (nonatomic, strong) NSString *    serverGenerateString;

@end

@implementation ServiceAlipayOrder

+ (id)orderWithOrderNo:(NSString *)no name:(NSString *)name description:(NSString *)description price:(NSString *)price payId:(NSString *)payId notifyUrl:(NSString *)notifyUrl {
    ServiceAlipayOrder *order = nil;
    order = [[ServiceAlipayOrder alloc]init];
    order.no = no;
    order.name = name;
    order.desc = description;
    order.price = price;
    order.pay_id = payId;
    order.notify_Url = notifyUrl;
    return order;
}

+ (id)orderWithServerGenerateString:(NSString *)generate {
    ServiceAlipayOrder *order = nil;
    order = [[ServiceAlipayOrder alloc]init];
    order.serverGenerateString = generate;
    return order;
}//服务端生成校验的字符串


- (NSString *)generateWithConfig:(ServiceAlipayConfig *)config {
    
    if (_serverGenerateString) {
        _serverGenerateString = [_serverGenerateString stringByReplacingOccurrencesOfString:@"amp;" withString:@""];
        return _serverGenerateString;
    }


    Order * order = [[Order alloc] init];
    // NOTE: app_id设置
    order.app_id	= config.appId;
    
    // NOTE: 支付接口名称
    order.method = @"alipay.trade.app.pay";
    
    // NOTE: 参数编码格式
    order.charset = @"utf-8";
 
    
    // NOTE: 当前时间点
    NSDateFormatter* formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    order.timestamp = [formatter stringFromDate:[NSDate date]];
    
    // NOTE: 支付版本
    order.version = @"1.0";
    
    // NOTE: sign_type 根据商户设置的私钥来决定
    order.sign_type = @"RSA2"; //RSA
    
    
    // NOTE: 商品数据
    order.biz_content = [BizContent new];
    order.biz_content.body = self.desc;
    order.biz_content.subject = self.name;
    order.biz_content.out_trade_no = self.no; //订单ID（由商家自行制定）
    order.biz_content.timeout_express = @"30m"; //超时时间设置
    order.biz_content.total_amount = [NSString stringWithFormat:@"%.2f", 0.01]; //商品价格
    
    //将商品信息拼接成字符串
    NSString *orderInfo = [order orderInfoEncoded:NO];
    NSString *orderInfoEncoded = [order orderInfoEncoded:YES];
    NSLog(@"orderSpec = %@",orderInfo);
    
    // NOTE: 获取私钥并将商户信息签名，外部商户的加签过程请务必放在服务端，防止公私钥数据泄露；
    //       需要遵循RSA签名规范，并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:config.privateKey];
    signedString = [signer signString:orderInfo withRSA2:YES];
    NSString *orderString = nil;
    if (signedString) {
        // NOTE: 将签名成功字符串格式化为订单字符串,请严格按照该格式
        orderString = [NSString stringWithFormat:@"%@&sign=%@",
                                 orderInfoEncoded, signedString];
    }
    return orderString;
}
@end
