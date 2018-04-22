//
//  ServiceAlipayResult.m
//  Dandanjia
//
//  Created by qiuyoubo on 15/7/7.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import "ServiceAlipayResult.h"

@implementation ServiceAlipayResult
- (id)initWithResultString:(NSString *)string {
    if (self = [super init]) {
        
        do {
            NSString *result = string;
            NSRange valueRange = [result rangeOfString:@"&sign_type=\""];
            if (valueRange.location == NSNotFound) {
                break;
            }
            self.resultString = [result substringToIndex:valueRange.location];
            valueRange.location += valueRange.length;
            valueRange.length = [result length] - valueRange.location;
            NSRange tempRange = [result rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:valueRange];
            if (tempRange.location == NSNotFound) {
                break;
            }
            valueRange.length = tempRange.location - valueRange.location;
            if (valueRange.length <= 0) {
                break;
            }
            //
            // 签名字符串
            //
            valueRange.location = tempRange.location;
            valueRange.length = [result length] - valueRange.location;
            valueRange = [result rangeOfString:@"sign=\"" options:NSCaseInsensitiveSearch range:valueRange];
            if (valueRange.location == NSNotFound) {
                break;
            }
            valueRange.location += valueRange.length;
            valueRange.length = [result length] - valueRange.location;
            tempRange = [result rangeOfString:@"\"" options:NSCaseInsensitiveSearch range:valueRange];
            if (tempRange.location == NSNotFound) {
                break;
            }
            valueRange.length = tempRange.location - valueRange.location;
            if (valueRange.length <= 0) {
                break;
            }
            self.signString = [result substringWithRange:valueRange];

        }while (0);
        
    }
    return self;
}
@end
