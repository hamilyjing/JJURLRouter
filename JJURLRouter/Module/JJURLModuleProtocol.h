//
//  JJURLModuleProtocol.h
//  JJ_iOS_UrlRouterService
//
//  Created by paux on 2017/9/4.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JJURLModuleProtocol <NSObject>

@optional
+ (Protocol *)JJ_moduleProtocol;
- (NSString *)JJ_bundleName;
- (NSDictionary *)canHandleLinkMappingRelation;
- (NSDictionary *)interceptorsLinkMap;


/*
 * 目前架构不需要实现下面方法
 */
//module life cycle
- (void)initModule;
- (void)destroyModule;

//common behavior
- (BOOL)canOpenURL:(NSString *)url;

@end
