//
//  JJURLResult.h
//  
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJURLError.h"

@class JJURLInput;

/**
 *  OpenURL的结果，会在openURL之后通过completion返回。
 */
@interface JJURLResult : NSObject

/// 是否成功
@property (nonatomic) BOOL success;

/// 源viewController
@property (nonatomic, weak) UIViewController *sourceViewController;
/// 跳向的viewController
@property (nonatomic, weak) UIViewController *destinationViewController;

/// 返回的结果（有请求的时候）
@property (nonatomic, strong) id response;

/// 错误信息
@property (nonatomic, strong) NSError *error;

/// 自定义信息
@property (nonatomic, strong) NSDictionary *userInfo;

/// OpenURL的输入
@property (nonatomic, strong) JJURLInput *input;

/// 引用的结果，目前可可能是被interceptor打断后interceptor跳转的结果
@property (nonatomic, strong) JJURLResult *refer;

+ (instancetype)resultWithInput:(JJURLInput *)input source:(UIViewController *)source destination:(UIViewController *)destination error:(NSError *)error;
+ (instancetype)errorResultWithInput:(JJURLInput *)input code:(NSInteger)errorCode messsage:(NSString *)message;

@end
