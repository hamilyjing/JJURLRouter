//
//  NSBundle+JJ.h
//  
//
//  Created by JJ on 17/08/2017.
//  Copyright © 2017 JJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (JJURLRouter)

+ (NSString *)jjurl_pathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType;

+ (NSString *)jjurl_filePathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType;

+ (NSString *)jjurl_imagePathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType;

+ (NSString *)jjurl_mediaPathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType;

@end
