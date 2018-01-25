//
//  JJURLCommonURIHandler.m
//
//
//  Created by JJ on 16/6/1.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLCommonURIHandler.h"
#import "JJURLResult.h"

@implementation JJURLCommonURIHandler

- (void)openURLWithInput:(JJURLInput *)input completion:(void (^)(JJURLResult *))completion
{
    NSURL *url = [NSURL URLWithString:input.url];
    if ([input.scheme.lowercaseString isEqualToString:@"tel"]) {
        NSString *title = input.parameters[@"title"] ?: url.host;
        url = [NSURL URLWithString:input.pattern];
        if (kCFCoreFoundationVersionNumber > kCFCoreFoundationVersionNumber_iOS_9_x_Max) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            if (completion) {
                completion([JJURLResult resultWithInput:input source:nil destination:nil error:nil]);
            }
            return;
        }
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *call = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        }];
        [alert addAction:cancel];
        [alert addAction:call];
        
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    if (completion) {
        completion([JJURLResult resultWithInput:input source:nil destination:nil error:nil]);
    }
}

@end
