//
//  JJURLManager.h
//  
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJURLOpenOptions.h"
#import "JJURLResult.h"
#import "JJURLInterceptor.h"

@interface JJURLManager : NSObject

+ (instancetype)sharedInstance;

- (BOOL)canOpenURL:(NSString *)url;
- (void)openURL:(NSString *)url options:(JJURLOpenOptions *)options completion:(void (^)(JJURLResult *result))completion;

- (UIViewController *)viewControllerWithURL:(NSString *)url options:(JJURLOpenOptions *)options;

- (JJURLInterceptor *)interceptorForName:(NSString *)name;

- (void)loadConfiguration;
- (void)loadConfigurationWithURL:(NSURL *)configurationURL;

//module for ulr & interceptor source api
- (void)registerProtocolClass:(Class)cls protocol:(Protocol *)proto;
- (Class)classForProtocol:(Protocol *)proto;

@end
