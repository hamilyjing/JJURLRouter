//
//  NSError+JJURLRouter.h
//  
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJURLInterceptor.h"
#import "JJURLError.h"

@interface NSError (JJURLRouter)

+ (instancetype)jjurl_errorWithURLException:(NSException *)exception;
+ (instancetype)jjurl_interceptErrorWithURL:(NSString *)url interceptor:(JJURLInterceptor *)interceptor;

@end
