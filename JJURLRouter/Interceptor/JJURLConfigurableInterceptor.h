//
//  JJURLConfigurableInterceptor.h
//  PANewToapAPP
//
//  Created by JJ on 16/2/22.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLInterceptor.h"

@interface JJURLConfigurableInterceptor : JJURLInterceptor

@property (strong, nonatomic) NSArray<NSString *> *urls;
@property (strong, nonatomic) NSArray<NSString *> *urlPrefixs;
@property (strong, nonatomic) NSArray<NSString *> *except;
@property (strong, nonatomic) NSArray<NSString *> *exceptPrefixs;

/// 是否为全局匹配
@property (nonatomic) BOOL globalMatch;

@end
