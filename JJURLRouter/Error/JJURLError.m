//
//  JJURLError.m
//  
//
//  Created by JJ on 2016/9/27.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLError.h"

NSString *const JJURLErrorDomain = @"JJURLErrorDomain";
NSString *const JJURLErrorURLKey = @"url";
NSString *const JJURLErrorExceptionKey = @"exception";
NSString *const JJURLErrorInterceptorKey = @"interceptor";

NSInteger const JJURLErrorHandlerNotFound = -9999;
NSInteger const JJURLErrorSourceViewControllerNull = -9998;
NSInteger const JJURLErrorDestinationViewControllerNull = -9997;
NSInteger const JJURLErrorUnsupportedAction = -9996;
NSInteger const JJURLErrorUnknown = -1;
