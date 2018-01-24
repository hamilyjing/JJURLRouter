//
//  JJURLModule.m
//  JJ_iOS_UrlRouterService
//
//  Created by paux on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JJURLModule.h"

#import "JJURLManager.h"
#import "NSBundle+JJURLRouter.h"

@implementation JJURLModule

+ (void)load {
    Protocol *moduleProtocol = [self JJ_moduleProtocol];
    if (moduleProtocol) {
        [[JJURLManager sharedInstance] registerProtocolClass:[self class] protocol:moduleProtocol];
    }
}

+ (Protocol *)JJ_moduleProtocol {
    return nil;
}

- (NSString *)JJ_bundleName {
    return nil;
}

- (NSDictionary *)canHandleLinkMappingRelation {
    if (self.configList.count != 0) {
        return self.configList[@"handlers"];
    }
    NSString *bundleName = [self JJ_bundleName];
    if (bundleName.length != 0) {
        NSString *url = [NSBundle jjurl_filePathWithClass:self.class bundleName:bundleName fileName:@"JJURLConfiguration" fileType:@"plist"];
        if (url.length != 0) {
            NSURL *configURL = [[NSURL alloc] initFileURLWithPath:url];
            if (configURL) {
                self.configList = [NSMutableDictionary dictionaryWithContentsOfURL:configURL];
                return self.configList[@"handlers"];
            }
        }
        return nil;
    }else {
        return nil;
    }
}

- (NSDictionary *)interceptorsLinkMap {
    if (self.configList.count != 0) {
        return self.configList[@"interceptors"];
    }
    NSString *bundleName = [self JJ_bundleName];
    if (bundleName.length != 0) {
        NSString *url = [NSBundle jjurl_filePathWithClass:self.class bundleName:bundleName fileName:@"JJURLConfiguration" fileType:@"plist"];
        if (url.length != 0) {
            NSURL *configURL = [[NSURL alloc] initFileURLWithPath:url];
            if (configURL) {
                self.configList = [NSMutableDictionary dictionaryWithContentsOfURL:configURL];
                return self.configList[@"interceptors"];
            }
        }
        return nil;
    }else {
        return nil;
    }
}

@end
