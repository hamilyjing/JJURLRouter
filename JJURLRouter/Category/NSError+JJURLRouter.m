//
//  NSError+JJURLRouter.m
//
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "NSError+JJURLRouter.h"

@implementation NSError (URLRouter)

+ (instancetype)jjurl_errorWithURLException:(NSException *)exception
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (exception) {
        userInfo[JJURLErrorExceptionKey] = exception;
        if (exception.name) {
            userInfo[NSLocalizedDescriptionKey] = exception.name;
        }
        if (exception.reason) {
            userInfo[NSLocalizedFailureReasonErrorKey] = exception.reason;
        }
    }
    return [self errorWithDomain:JJURLErrorDomain code:-1 userInfo:userInfo];
}

+ (instancetype)jjurl_interceptErrorWithURL:(NSString *)url interceptor:(JJURLInterceptor *)interceptor
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    if (url) {
        userInfo[JJURLErrorURLKey] = url;
    }
    if (interceptor) {
        userInfo[JJURLErrorInterceptorKey] = interceptor;
    }
    userInfo[NSLocalizedDescriptionKey] = [NSString stringWithFormat:@"Interceptor test failed: <%@: %p; name = %@; url = %@>", NSStringFromClass(interceptor.class), interceptor, interceptor.name, url];
    return [self errorWithDomain:JJURLErrorDomain code:-1 userInfo:userInfo];
}

@end
