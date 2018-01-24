//
//  UIViewController+JJURLRouter.m
//  
//
//  Created by JJ on 16/3/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "UIViewController+JJURLRouter.h"
#import "JJURLRouter.h"

@implementation UIViewController (JJURLRouter)

- (JJURLContext *(^)(NSString *url))jj_url
{
    return ^JJURLContext *(NSString *url){
        JJURLContext *context = [JJURLContext new];
        return context.url(url).sourceViewController(self);
    };
}

- (void)jjurl_openURL:(NSString *)url
{
    [self jjurl_openURL:url options:nil completion:nil];
}

- (void)jjurl_openURL:(NSString *)url options:(JJURLOpenOptions *)options completion:(void (^)(JJURLResult *))completion
{
    if (!options) {
        options = [JJURLOpenOptions new];
    }
    if (!options.sourceViewController) {
        options.sourceViewController = self;
    }
    [JJURLRouter openURL:url options:options completion:completion];
}

@end
