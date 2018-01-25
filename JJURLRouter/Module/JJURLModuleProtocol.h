//
//  JJURLModuleProtocol.h
//
//
//  Created by JJ on 2017/9/4.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol JJURLModuleProtocol <NSObject>

@optional
+ (Protocol *)jj_moduleProtocol;
- (NSString *)jj_bundleName;
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
