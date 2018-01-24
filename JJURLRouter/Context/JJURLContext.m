//
//  JJURLContext.m
//  
//
//  Created by JJ on 16/5/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLContext.h"
#import "JJURLRouter.h"

@interface JJURLContextParam : NSObject

@property (nonatomic, strong) JJURLOpenOptions *options;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, copy) void (^completion)(JJURLResult *result);

@end

@implementation JJURLContextParam

@end

@interface JJURLContext ()

@property (nonatomic, strong) JJURLContextParam *param;

@property (nonatomic, copy) JJURLContext *(^url)(NSString *url);
@property (nonatomic, copy) JJURLContext *(^parameters)(NSDictionary *parameters);
@property (nonatomic, copy) JJURLContext *(^viewProperties)(NSDictionary *viewProperties);
@property (nonatomic, copy) JJURLContext *(^userInfo)(NSDictionary *userInfo);
@property (nonatomic, copy) JJURLContext *(^animated)(BOOL animated);
@property (nonatomic, copy) JJURLContext *(^interceptedFallbackURL)(NSString *interceptedFallbackURL);
@property (nonatomic, copy) JJURLContext *(^action)(NSString *action);
@property (nonatomic, copy) JJURLContext *(^sourceViewController)(UIViewController *sourceViewController);
@property (nonatomic, copy) JJURLContext *(^preparation)(UIViewController *(^preparation)(UIViewController *source, UIViewController *destination, JJURLInput *input));

@property (nonatomic, copy) JJURLContext *(^options)(JJURLOpenOptions *options);
@property (nonatomic, copy) JJURLContext *(^completion)(void (^completion)(JJURLResult *result));

@property (nonatomic, copy) void (^open)(void);

@end

@implementation JJURLContext

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.param = [JJURLContextParam new];
        self.param.options = [JJURLOpenOptions new];
        
        __weak typeof(self) wself = self;
        self.url = ^JJURLContext *(NSString *url){
            wself.param.url = url;
            return wself;
        };
        
        self.parameters = ^JJURLContext *(NSDictionary *parameters){
            wself.param.options.parameters = parameters;
            return wself;
        };
        
        self.viewProperties = ^JJURLContext *(NSDictionary *viewProperties){
            wself.param.options.viewProperties = viewProperties;
            return wself;
        };
        
        self.userInfo = ^JJURLContext *(NSDictionary *userInfo){
            wself.param.options.userInfo = userInfo;
            return wself;
        };
        
        self.action = ^JJURLContext *(NSString *action){
            wself.param.options.action = action;
            return wself;
        };
        
        self.options = ^JJURLContext *(JJURLOpenOptions *options){
            wself.param.options = options;
            return wself;
        };
        
        self.animated = ^JJURLContext *(BOOL animated){
            wself.param.options.animated = animated;
            return wself;
        };
        
        self.interceptedFallbackURL = ^JJURLContext *(NSString *interceptedFallbackURL){
            wself.param.options.interceptedFallbackURL = interceptedFallbackURL;
            return wself;
        };
        
        self.sourceViewController = ^JJURLContext *(UIViewController *sourceViewController){
            wself.param.options.sourceViewController = sourceViewController;
            return wself;
        };
        
        self.preparation = ^JJURLContext *(UIViewController *(^preparation)(UIViewController *source, UIViewController *destination, JJURLInput *input)){
            wself.param.options.preparation = preparation;
            return wself;
        };
        
        self.completion = ^JJURLContext *(void (^completion)(JJURLResult *result)){
            wself.param.completion = completion;
            return wself;
        };
        
        self.open = ^{
            [JJURLRouter openURL:wself.param.url options:wself.param.options completion:wself.param.completion];
        };
    }
    return self;
}

- (BOOL)canOpen
{
    return [JJURLRouter canOpenURL:self.param.url];
}

- (UIViewController *)viewController
{
    return [JJURLRouter viewControllerWithURL:self.param.url options:self.param.options];
}

@end
