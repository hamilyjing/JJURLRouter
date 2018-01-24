//
//  JJURLOpenOptions.h
//  
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 通过push的方式打开
extern NSString *const JJURLOpenActionPush;

/// 通过present的方式打开
extern NSString *const JJURLOpenActionPresent;

@class JJURLInput;

/*!
 *  打开URL时可以传进来额外参数
 */
@interface JJURLOpenOptions : NSObject <NSCopying>

/*!
 *  源URL
 *
 *  @discussion - 对于重定向打开的URL，这里会存放重定向之前的URL
 *  @discussion - 对于因为Interceptor打开的URL（登陆、实名认证等URL），这里会存放被拦截的URL
 */
@property (nonatomic, strong) NSString *sourceURL;

/*!
 *  被拦截之后将会跳转的URL
 */
@property (nonatomic, strong) NSString *interceptedFallbackURL;

/// 打开URL的源视图控制器
@property (nonatomic, weak) UIViewController *sourceViewController;

/*!
 *  打开URL时的额外参数，会和从URL里解析出来的参数拼在一起
 *
 *  @note  如果名称和URL里带的参数名称重复，则会覆盖URL里的参数
 *  @note  不要进行URL编码
 */
@property (nonatomic, strong) NSDictionary *parameters;

/// 打开URL时传给被打开的ViewController的属性，会以keyPath的形式赋值给被打开的ViewController
@property (nonatomic, strong) NSDictionary *viewProperties;

/*!
 *  打开URL时的行为，会覆盖URL配置的行为
 *
 *  @see JJURLOpenActionPush
 *  @see JJURLOpenActionPresent
 */
@property (nonatomic, strong) NSString *action;

/// 是否自动添加UINavigationController容器
@property (nonatomic) BOOL autoNavigationDisabled;

/// 打开URL时是否带动画，默认为YES
@property (nonatomic) BOOL animated;

/*!
 *  打开URL之前的处理
 *  
 *  @param source 打开URL的源视图控制器
 *  @param destination 打开URL的目标视图控制器
 *  @param input 打开URL时的入参
 */
@property (nonatomic, copy) UIViewController *(^preparation)(UIViewController *source, UIViewController *destination, JJURLInput *input);

/// 打开URL时的额外信息，可以传入任意值
@property (nonatomic, strong) NSDictionary *userInfo;

@property (nonatomic) BOOL isSourceViewControllerValid;

+ (instancetype)optionsWithViewProperties:(NSDictionary *)viewProperties;
+ (instancetype)optionsWithParameters:(NSDictionary *)parameters;

@end
