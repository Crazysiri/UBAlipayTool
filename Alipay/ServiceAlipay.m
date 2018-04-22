//
//  ServiceAlipay.m
//  Dandanjia
//
//  Created by qiuyoubo on 15/6/29.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import "ServiceAlipay.h"
#import "RSADataSigner.h"
#import "RSADataVerifier.h"
#import "ServiceAlipayResult.h"
#import "ServiceAlipayAuthConfig.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"

typedef void(^ServiceAlipayReturnBlock)(void);
@interface ServiceAlipay () {
    ServiceAlipayConfig *_config;
    ServiceAlipayAuthConfig *_authConfig;
}
@property (strong, nonatomic) ServiceAlipayReturnBlock failedBlock;
@property (strong, nonatomic) ServiceAlipayReturnBlock succeedBlock;
@end

@implementation ServiceAlipay

+ (id)sharedInstance {
    static ServiceAlipay *config = nil;
    static dispatch_once_t onceT;
    dispatch_once(&onceT, ^{
        config = [[self alloc] init];
    });
    return config;
}


- (ServiceAlipayConfig *)config {
    if (!_config) {
        _config = [[ServiceAlipayConfig alloc]init];
    }
    return _config;
}

- (ServiceAlipayAuthConfig *)authConfig {
    if (_authConfig) {
        _authConfig = [[ServiceAlipayAuthConfig alloc]init];
    }
    return _authConfig;
}

- (void)reset {
    self.failedBlock = nil;
    self.succeedBlock = nil;
}

- (void)payWithOrder:(ServiceAlipayOrder *)order succeed:(void(^)(void))succeed failed:(void(^)(void))failed{
    

    self.failedBlock = failed;
    self.succeedBlock = succeed;
    __weak typeof(self) weakself = self;
    NSString *appScheme = self.config.alipay_scheme;
    NSString *orderString = [order generateWithConfig:self.config];
    
    if (!orderString) {
        self.errorCode = AlipayStatusErrorInstallAlipay;
        self.errorDesc = @"订单数据无效";
        self.failedBlock();
        return;
    }
    
    if (!appScheme) {
        self.errorCode = AlipayStatusErrorInvalidData;
        self.errorDesc = @"订单数据无效";
        self.failedBlock();
        return;
    }
    
//    if (![self installed]) {
//        self.errorCode = AlipayStatusErrorInstallAlipay;
//        self.errorDesc = @"请先安装支付宝";
//        self.failedBlock();
//        return;
//    }
//
    
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [weakself handleResultDictionary:resultDic];
    }];
}

+ (BOOL)installed {
    NSString *	urlSafypayString = [NSString stringWithFormat:@"safepay://alipayclient"];
    
    NSURL *		safepayUrl = [NSURL URLWithString:urlSafypayString];
    
    if ( [[UIApplication sharedApplication] canOpenURL:safepayUrl] )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (BOOL)installed
{
    return [ServiceAlipay installed];
}

- (void)handleResultDictionary:(NSDictionary *)resultDic {
    NSInteger resultStatus = [resultDic[@"resultStatus"]integerValue];
    switch (resultStatus) {
        case AlipayStatusSuccess:
        {
            self.errorCode = AlipayStatusSuccess;
            self.errorDesc = @"支付成功";
            self.succeedBlock();
        }
            break;
        default: {
            self.errorDesc = @"订单支付失败";
            self.errorCode = resultStatus;
            self.failedBlock();
        }
            break;
    }
    [self reset];
}

- (BOOL)verifyWithResult:(NSString *)result sign:(NSString *)signString{

   RSADataVerifier *verfifier =  [[RSADataVerifier alloc]initWithPublicKey:self.config.publicKey];
    if ( nil == verfifier )
    {
        NSLog( @"Alipay, failed to pay" );
        
        return NO;
    }
    BOOL succeed = [verfifier verifyString:result withSign:signString withRSA2:YES];
    if ( NO == succeed )
    {
        NSLog( @"Alipay, invalid signature" );
        
        return NO;
    }
    
    NSLog( @"Alipay, succeed" );
    
    return YES;
}

- (void)handleResultUrl:(NSURL *)url {
    if (!url) {
        return;
    }
    
    if ([url.host isEqualToString:@"safepay"]) {
        __weak typeof(self) weakself = self;
        //支付回调
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            [weakself handleResultDictionary:resultDic];

        }];
        
        
        
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
}

#pragma mark - auth

- (void)auth {
    //生成 auth info 对象
    APAuthV2Info *authInfo = [APAuthV2Info new];
    authInfo.pid = self.authConfig.pid;
    authInfo.appID = self.authConfig.appId;
    
    //auth type
    NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
    if (authType) {
        authInfo.authType = authType;
    }
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = self.config.alipay_scheme;
    
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    NSLog(@"authInfoStr = %@",authInfoStr);
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:self.authConfig.privateKey];
    signedString = [signer signString:authInfoStr withRSA2:YES];

    
    // 将签名成功字符串格式化为订单字符串,请严格按照该格式
    if (signedString.length > 0) {
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA2"];
        [[AlipaySDK defaultService] auth_V2WithInfo:authInfoStr
                                         fromScheme:appScheme
                                           callback:^(NSDictionary *resultDic) {
                                               NSLog(@"result = %@",resultDic);
                                               // 解析 auth code
                                               NSString *result = resultDic[@"result"];
                                               NSString *authCode = nil;
                                               if (result.length>0) {
                                                   NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                                                   for (NSString *subResult in resultArr) {
                                                       if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                                                           authCode = [subResult substringFromIndex:10];
                                                           break;
                                                       }
                                                   }
                                               }
                                               NSLog(@"授权结果 authCode = %@", authCode?:@"");
                                           }];
    }

}
@end