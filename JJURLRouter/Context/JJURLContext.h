//
//  JJURLContext.h
//  
//
//  Created by JJ on 16/5/31.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JJURLResult;
@class JJURLInput;
@class JJURLOpenOptions;

@interface JJURLContext : NSObject

@property (nonatomic, readonly, copy) JJURLContext *(^url)(NSString *url);
@property (nonatomic, readonly, copy) JJURLContext *(^parameters)(NSDictionary *parameters);
@property (nonatomic, readonly, copy) JJURLContext *(^viewProperties)(NSDictionary *viewProperties);
@property (nonatomic, readonly, copy) JJURLContext *(^userInfo)(NSDictionary *userInfo);
@property (nonatomic, readonly, copy) JJURLContext *(^animated)(BOOL animated);
@property (nonatomic, readonly, copy) JJURLContext *(^interceptedFallbackURL)(NSString *interceptedFallbackURL);
@property (nonatomic, readonly, copy) JJURLContext *(^action)(NSString *action);
@property (nonatomic, readonly, copy) JJURLContext *(^sourceViewController)(UIViewController *sourceViewController);
@property (nonatomic, readonly, copy) JJURLContext *(^preparation)(UIViewController *(^preparation)(UIViewController *source, UIViewController *destination, JJURLInput *input));

@property (nonatomic, readonly, copy) JJURLContext *(^options)(JJURLOpenOptions *options);
@property (nonatomic, readonly, copy) JJURLContext *(^completion)(void (^completion)(JJURLResult *result));

@property (nonatomic, readonly, copy) void (^open)(void);
@property (readonly) BOOL canOpen;
@property (readonly) UIViewController *viewController;

@end
