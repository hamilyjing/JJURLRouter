//
//  JJURLInterceptor.h
//  PANewToapAPP
//
//  Created by JJ on 16/2/17.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJURLInput.h"
#import "JJURLResult.h"

@protocol JJURLInterceptor <NSObject>

@optional
/// 执行前拦截，返回YES表示中断后续处理

/**
 *  执行前处理，判断是否要打开URL，并可以对打开参数进行修改
 *
 *  @param input routerParameters Router参数，详见｀JJURLRouter｀
 *  @return 是否要继续打开URL
 */
- (BOOL)shouldOpenURLWithInput:(JJURLInput *)input completion:(void (^)(JJURLResult *result))completion;

/**
 *  执行后处理
 *
 *  @param input OpenURL的输入，详见｀JJURLInput｀
 *  @param result OpenURL的结果，详见｀JJURLResult｀
 */
- (JJURLResult *)didOpenURLWithInput:(JJURLInput *)input result:(JJURLResult *)result;

@end

/**
 * 用来拦截JJURLRouter的block操作，实现简单的面向切片的功能
 */
@interface JJURLInterceptor : NSObject <JJURLInterceptor>

/// 拦截器的名字，可用来调试
@property (nonatomic, strong) NSString *name;

/// 顺序，用于多个interceptor排序
@property (nonatomic, strong) NSNumber *sort;

/**
 *  检查当前拦截器是否匹配一个URL
 *
 *  @param input urlPattern 待匹配的URL parameters 待匹配的参数
 */
- (BOOL)isMatchURLWithInput:(JJURLInput *)input;

/**
 *  protected method. used for subclass.
 */
- (void)interceptWithURL:(NSString *)url originalInput:(JJURLInput *)originalInput originalCompletion:(void (^)(JJURLResult *result))originalCompletion;

@end
