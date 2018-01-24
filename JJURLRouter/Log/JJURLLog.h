//
//  JJURLLog.h
//  
//
//  Created by JJ on 16/4/20.
//  Copyright © 2016年 JJ. All rights reserved.
//

#ifndef JJURLLog_h
#define JJURLLog_h

#ifdef DEBUG
#define JJURLLog(fmt, ...) NSLog(@" %s line:%d\n----------- JJURLLog -----------\n" fmt @"\n", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define JJURLLog(fmt, ...)
#endif

#endif /* JJURLLog_h */
