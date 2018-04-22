//
//  ServiceAlipayResult.h
//  Dandanjia
//
//  Created by qiuyoubo on 15/7/7.
//  Copyright (c) 2015年 xiandanjia.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceAlipayResult : NSObject
@property (strong, nonatomic) NSString *resultString;
@property (strong, nonatomic) NSString *signString;

- (id)initWithResultString:(NSString *)string;
@end
