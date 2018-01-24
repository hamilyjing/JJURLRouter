//
//  JJURLRouter.h
//  PANewToapAPP
//
//  Created by JJ on 16/2/16.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJURLInput.h"
#import "JJURLResult.h"
#import "JJURLContext.h"
#import "UIViewController+JJURLRouter.h"
#import "JJURLSupport.h"

@interface JJURLRouter : NSObject

/**
 *  加载配置文件
 */
+ (void)loadConfiguration;

/**
 *  是否可以打开URL
 *
 *  @param URL
 *
 *  @return
 */
+ (BOOL)canOpenURL:(NSString *)URL;

/**
 *  打开此 URL
 *  会在已注册的 URL -> Handler 中寻找，如果找到，则执行 Handler
 *
 *  @param URL 带 Scheme，如 mgj://beauty/3
 */
+ (void)openURL:(NSString *)URL;

/**
 *  打开此 URL，带上附加信息，同时当操作完成时，执行额外的代码
 *
 *  @param URL        带 Scheme 的 URL，如 mgj://beauty/4
 *  @param userInfo 附加参数
 *  @param completion URL 处理完成后的 callback，完成的判定跟具体的业务相关
 */
+ (void)openURL:(NSString *)url options:(JJURLOpenOptions *)options completion:(void (^)(JJURLResult *result))completion;

+ (UIViewController *)viewControllerWithURL:(NSString *)url options:(JJURLOpenOptions *)options;

+ (JJURLContext *)context;

@end
