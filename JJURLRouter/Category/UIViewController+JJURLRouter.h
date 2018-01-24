//
//  UIViewController+JJURLRouter.h
//  
//
//  Created by JJ on 16/3/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJURLContext;
@class JJURLOpenOptions;
@class JJURLResult;

@interface UIViewController (JJURLRouter)

/**
 *  链式语法调起URL
 *
 *  @discussion self.jj_url(@"patoa://JJ.com/login").parameters(@{@"force":@"1"}).animated(YES).open();
 */
@property (readonly) JJURLContext *(^jj_url)(NSString *url);

/**
 *  使用自己的navigationController作为额外参数来打开URL
 *
 *  @param url        带 Scheme 的 URL，如 mgj://beauty/4;如果要用POST方式打开URL，需要在url后面拼接“isPostRequest=YES”
 */
- (void)jjurl_openURL:(NSString *)url;

/**
 *  使用自己的navigationController作为额外参数来打开URL
 *
 *  @param url        带 Scheme 的 URL，如 mgj://beauty/4
 *  @param options    附加参数
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
- (void)jjurl_openURL:(NSString *)url options:(JJURLOpenOptions *)options completion:(void (^)(JJURLResult *result))completion;

@end
