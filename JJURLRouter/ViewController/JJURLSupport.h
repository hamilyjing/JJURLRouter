//
//  JJURLSupport.h
//  
//
//  Created by JJ on 16/4/4.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JJURLInput.h"

/**
 *  此接口用来支持URL跳转时的自定义处理
 */
@protocol JJURLSupport <NSObject>

/**
 *  一个ViewController实现此接口用来接收URL的传参
 *  
 *  @param input  打开URL时的入参
 */
- (void)prepareWithURLInput:(JJURLInput *)input;

@end
