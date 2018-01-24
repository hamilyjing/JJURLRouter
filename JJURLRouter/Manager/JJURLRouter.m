//
//  JJURLRouter.m
//  PANewToapAPP
//
//  Created by JJ on 16/2/16.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLRouter.h"
#import "JJURLManager.h"

#import <YYModel/YYModel.h>

@implementation JJURLRouter

#pragma mark - public
+ (void)loadConfiguration
{
    [JJURLManager sharedInstance];
}

+ (BOOL)canOpenURL:(NSString *)URL
{
    if (![URL isKindOfClass:[NSString class]] || [URL stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        return NO;
    }
    
    /// for test
    if ([URL.lowercaseString hasPrefix:@"patoa://JJ.com/test"]) {
//#ifndef DEBUG
        return NO;
//#endif
    }
    
    return [[JJURLManager sharedInstance] canOpenURL:URL];
}

+ (void)openURL:(NSString *)URL
{
    return [self openURL:URL options:nil completion:nil];
}

+ (void)openURL:(NSString *)url options:(JJURLOpenOptions *)options completion:(void (^)(JJURLResult *))completion
{
    [[JJURLManager sharedInstance] openURL:url options:options completion:completion];
}

+ (UIViewController *)viewControllerWithURL:(NSString *)url options:(JJURLOpenOptions *)options
{
    return [[JJURLManager sharedInstance] viewControllerWithURL:url options:options];
}

+ (JJURLContext *)context
{
    return [JJURLContext new];
}

@end
