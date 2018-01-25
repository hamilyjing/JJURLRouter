//
//  JJURLBackHandler.m
//
//
//  Created by JJ on 16/5/20.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLBackHandler.h"
#import "JJURLResult.h"

@implementation JJURLBackHandler

- (void)openURLWithInput:(JJURLInput *)input completion:(void (^)(JJURLResult *))completion
{
    [input.options.sourceViewController.navigationController popViewControllerAnimated:YES];
}

@end
