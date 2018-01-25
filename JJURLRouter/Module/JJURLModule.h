//
//  JJURLModule.h
//  
//
//  Created by JJ on 2017/10/17.
//  Copyright © 2017年 JJ. All rights reserved.
//

#import "JJURLHandler.h"
#import "JJURLModuleProtocol.h"

@interface JJURLModule : JJURLHandler <JJURLModuleProtocol>

@property (nonatomic, strong) NSMutableDictionary *configList;

@end
