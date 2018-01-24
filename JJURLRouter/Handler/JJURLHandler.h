//
//  JJURLHandler.h
//  PANewToapAPP
//
//  Created by JJ on 16/2/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JJURLRouter.h"

extern NSString *const JJURLOpenActionPush;
extern NSString *const JJURLOpenActionPresent;

@protocol JJURLHandler <NSObject>

/**
 *  打开URL
 *
 *  @param  input 输入参数，详见｀JJURLInput｀
 *  @param  completion 完成的回调
 */
- (void)openURLWithInput:(JJURLInput *)input completion:(void (^)(JJURLResult *result))completion;

@optional

/// 此处理器可处理的URL
@property (nonatomic, strong) NSString *url;

/// 该URL对应的vc，不支持异步，可能为空
- (UIViewController *)viewControllerWithInput:(JJURLInput *)input;

@end

/**
 *  Handler用来处理具体的URL请求
 *  
 *  @discussion 每次请求会创建一个Handler，处理完即被释放。
 *  如需长久存在以接受回调或做其他后续处理，请设置owner属性。
 *  owner为一个在后续处理结束前可以持有Handler的对象，比如说sourceViewController。
 *
 *  @note handler不应该直接或间接的持有任何ViewController对象
 */
@interface JJURLHandler : NSObject <JJURLHandler>

/// Handler的名字，可用来调试
@property (nonatomic, strong) NSString *name;

/// 此处理器可处理的URL
@property (nonatomic, strong) NSString *url;

/// 动作方式，push／present，详见｀JJURLOpenActionPush｀，｀JJURLOpenActionPresent｀
@property (nonatomic, strong) NSString *action;

/// 此处可设置重定向的URL
@property (nonatomic, strong) NSString *redirectURL;

/// 将要打开的ViewController类名
@property (nonatomic, strong) NSString *viewController;

/**
 *  要设置到ViewController里的参数，[KeyPath: Value]
 *  
 *  @note ViewController里必须要有这个keyPath，否则OpenURL会失败
 */
@property (nonatomic, readonly, strong) NSDictionary *viewProperties;

/// 添加一个参数到viewParams里
- (void)setViewProperty:(id)object forKey:(NSString *)key;

/**
 *  protected method. for retain self.
 *  
 *  @discussion 该属性用于需要handler响应回调时保证handler不会被自动释放
 */
@property (nonatomic, weak) id owner;

/// protected method. for subclass calling.
- (BOOL)preprocessViewController:(UIViewController *)vc withInput:(JJURLInput *)input completion:(void (^)(JJURLResult *result))completion;

/// protected method. for subclass calling.
- (void)openViewController:(UIViewController *)viewController withInput:(JJURLInput *)input completion:(void (^)(JJURLResult *result))completion;

@end
