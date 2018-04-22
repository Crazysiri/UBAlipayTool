//
//  ServiceAlipayConfig.m
//  Dandanjia
//
//  Created by qiuyoubo on 15/6/29.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import "ServiceAlipayConfig.h"

@implementation ServiceAlipayConfig
- (id)init {
    if (self = [super init]) {
        self.appId = @"";
        self.privateKey = @"";
    }
    return self;
}

@end
