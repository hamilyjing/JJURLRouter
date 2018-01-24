//
//  JJURLInterceptor.m
//  PANewToapAPP
//
//  Created by JJ on 16/2/17.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLInterceptor.h"
#import "JJURLRouter.h"
#import "NSError+JJURLRouter.h"

@interface JJURLInterceptor ()

@end

@implementation JJURLInterceptor

+ (Class)modelCustomClassForDictionary:(NSDictionary *)dic
{
    NSString *className = dic[@"class"];
    if (className.length > 0) {
        Class clz = NSClassFromString(className);
        if (clz) {
            return clz;
        }
    }
    return self.class;
}

- (BOOL)isMatchURLWithInput:(JJURLInput *)input
{
    return NO;
}

- (void)interceptWithURL:(NSString *)url originalInput:(JJURLInput *)originalInput originalCompletion:(void (^)(JJURLResult *))originalCompletion
{
    JJURLOpenOptions *options = originalInput.options ?: [JJURLOpenOptions new];
    if (!options.sourceURL) {
        options.sourceURL = originalInput.url;
    }
    [JJURLRouter openURL:url options:options completion:^(JJURLResult *r2) {
        if (originalCompletion) {
            NSError *error = [NSError jjurl_interceptErrorWithURL:originalInput.url interceptor:self];
            JJURLResult *result = [JJURLResult resultWithInput:originalInput source:nil destination:nil error:error];
            result.refer = r2;
            originalCompletion(result);
        }
    }];
}

@end
