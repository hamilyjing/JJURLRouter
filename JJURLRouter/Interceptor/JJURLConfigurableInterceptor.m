//
//  JJURLConfigurableInterceptor.m
//  PANewToapAPP
//
//  Created by JJ on 16/2/22.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLConfigurableInterceptor.h"

@implementation JJURLConfigurableInterceptor

- (BOOL)isMatchURLWithInput:(JJURLInput *)input
{
    NSString *baseUrl = input.pattern.lowercaseString;
    if (baseUrl.length == 0) {
        return NO;
    }
    
    for (NSString *url in self.except) {
        if ([baseUrl compare:url options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return NO;
        }
    }
    for (NSString *pattern in self.exceptPrefixs) {
        if ([baseUrl hasPrefix:pattern]) {
            return NO;
        }
    }
    for (NSString *url in self.urls) {
        if ([baseUrl compare:url options:NSCaseInsensitiveSearch] == NSOrderedSame) {
            return YES;
        }
    }
    for (NSString *pattern in self.urlPrefixs) {
        if ([baseUrl hasPrefix:pattern]) {
            return YES;
        }
    }
    return NO;
}

@end
