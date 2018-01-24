//
//  JJURLModule.h
//  JJ_iOS_UrlRouterService
//
//  Created by paux on 2017/10/17.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "JJURLHandler.h"
#import "JJURLModuleProtocol.h"

@interface JJURLModule : JJURLHandler <JJURLModuleProtocol>

@property (nonatomic, strong) NSMutableDictionary *configList;

@end
