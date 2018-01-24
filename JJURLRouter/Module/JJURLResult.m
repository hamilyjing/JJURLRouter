//
//  JJURLResult.m
//  
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLResult.h"
#import "JJURLInput.h"

@implementation JJURLResult

+ (instancetype)resultWithInput:(JJURLInput *)input source:(UIViewController *)source destination:(UIViewController *)destination error:(NSError *)error
{
    JJURLResult *result = [self new];
    result.input = input;
    result.success = error == nil;
    result.sourceViewController = source ?: input.options.sourceViewController;
    result.destinationViewController = destination;
    result.error = error;
    return result;
}

+ (instancetype)errorResultWithInput:(JJURLInput *)input code:(NSInteger)errorCode messsage:(NSString *)message
{
    NSString *desc = [NSString stringWithFormat:@"url: %@, message: %@", input.url, message];
    NSError *error = [NSError errorWithDomain:JJURLErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey: desc}];
    return [self resultWithInput:input source:nil destination:nil error:error];
}

@end
