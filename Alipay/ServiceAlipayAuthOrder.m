//
//  ServiceAlipayAuthOrder.m
//  UBAlipayTool
//
//  Created by qiuyoubo on 2018/11/22.
//

#import "ServiceAlipayAuthOrder.h"

#import "ServiceAlipayAuthConfig.h"

#import "APAuthV2Info.h"

#import "RSADataSigner.h"

#import "RSADataVerifier.h"

@interface ServiceAlipayAuthOrder ()

@property (nonatomic,copy) NSString *authType;

@property (nonatomic,copy) NSString *generateString;

@end

@implementation ServiceAlipayAuthOrder
/*
 用1 或 2 生成order  然后 调用3 生成generate字符串
 */

//1
+ (id)orderWithAuthType:(NSString *)type {
    
    ServiceAlipayAuthOrder *order = [[ServiceAlipayAuthOrder alloc] init];
    //auth type
    if (!type) {
        NSString *authType = [[NSUserDefaults standardUserDefaults] objectForKey:@"authType"];
        type = authType;
    }
    order.authType = type;
    return order;
}
//2
+ (id)orderWithServerGenerateString:(NSString *)generate {
    //服务端生成校验的字符串
    ServiceAlipayAuthOrder *order = [[ServiceAlipayAuthOrder alloc] init];
    order.generateString = generate;
    return order;
}
//3
- (NSString *)generateWithConfig:(ServiceAlipayAuthConfig *)config {
    
    if (self.generateString) return self.generateString;
    
    //生成 auth info 对象
    APAuthV2Info *authInfo = [APAuthV2Info new];
    authInfo.pid = config.pid;
    authInfo.appID = config.appId;
    
    authInfo.authType = self.authType;
        
    // 将授权信息拼接成字符串
    NSString *authInfoStr = [authInfo description];
    
    // 获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    NSString *signedString = nil;
    RSADataSigner* signer = [[RSADataSigner alloc] initWithPrivateKey:config.privateKey];
    signedString = [signer signString:authInfoStr withRSA2:YES];

    if (signedString.length > 0) {
        authInfoStr = [NSString stringWithFormat:@"%@&sign=%@&sign_type=%@", authInfoStr, signedString, @"RSA2"];
        return authInfoStr;
    }
    return nil;
}
@end
