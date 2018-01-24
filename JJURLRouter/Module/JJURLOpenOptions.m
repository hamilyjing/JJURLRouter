//
//  JJURLOpenOptions.m
//  
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLOpenOptions.h"

NSString *const JJURLOpenActionPush = @"push";
NSString *const JJURLOpenActionPresent = @"present";

@implementation JJURLOpenOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        _animated = YES;
    }
    return self;
}

+ (instancetype)optionsWithViewProperties:(NSDictionary *)viewProperties
{
    JJURLOpenOptions *options = self.new;
    options.viewProperties = viewProperties;
    return options;
}

+ (instancetype)optionsWithParameters:(NSDictionary *)parameters
{
    JJURLOpenOptions *options = self.new;
    options.parameters = parameters;
    return options;
}

- (id)copyWithZone:(NSZone *)zone
{
    JJURLOpenOptions *obj = self.class.new;
    obj.sourceURL = self.sourceURL;
    obj.interceptedFallbackURL = self.interceptedFallbackURL;
    obj.sourceViewController = self.sourceViewController;
    obj.parameters = self.parameters;
    obj.viewProperties = self.viewProperties;
    obj.action = self.action;
    obj.animated = self.animated;
    obj.preparation = self.preparation;
    obj.userInfo = self.userInfo;
    return obj;
}

- (BOOL)isSourceViewControllerValid
{
    UIViewController *sourceViewController = self.sourceViewController;
    if (!sourceViewController) {
        return NO;
    }
    if(![sourceViewController isKindOfClass:[UINavigationController class]] && sourceViewController.navigationController.topViewController != sourceViewController) {
        return NO;
    }
    return YES;
}

@end
