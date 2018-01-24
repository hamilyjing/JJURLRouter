//
//  NSBundle+JJ.m
//
//
//  Created by JJ on 17/08/2017.
//  Copyright © 2017 JJ. All rights reserved.
//

#import "NSBundle+JJURLRouter.h"

#import <UIKit/UIKit.h>

@implementation NSBundle (JJURLRouter)

+ (NSString *)jjurl_pathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSBundle *bundle = [NSBundle bundleForClass:classObject];
    NSURL *url = [bundle URLForResource:bundleName withExtension:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithURL:url];
    NSString *name = fileName;
    NSString *path = [resourceBundle pathForResource:name ofType:fileType];
    return path;
}

+ (NSString *)jjurl_filePathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSString *name = [NSString stringWithFormat:@"File/%@", fileName];
    NSString *path =  [NSBundle jjurl_pathWithClass:classObject bundleName:bundleName fileName:name fileType:fileType];
    return path;
}

+ (NSString *)jjurl_imagePathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSMutableArray *fileNameArray = [NSMutableArray arrayWithCapacity:3];
    
    if ([[fileType lowercaseString] isEqualToString:@"png"] && NSNotFound == [fileName rangeOfString:@"@"].location)
    {
        NSInteger scale = [UIScreen mainScreen].scale;
        switch (scale) {
            case 2:
                [fileNameArray addObject:[fileName stringByAppendingString:@"@2x"]];
                [fileNameArray addObject:[fileName stringByAppendingString:@"@3x"]];
                break;
                
            case 3:
                [fileNameArray addObject:[fileName stringByAppendingString:@"@3x"]];
                [fileNameArray addObject:[fileName stringByAppendingString:@"@2x"]];
                break;
                
            default:
                break;
        }
    }
    
    [fileNameArray addObject:fileName];
    
    for (NSString *object in fileNameArray)
    {
        NSString *name = [NSString stringWithFormat:@"Image/%@", object];
        NSString *path =  [NSBundle jjurl_pathWithClass:classObject bundleName:bundleName fileName:name fileType:fileType];
        if (path)
        {
            return path;
        }
    }
    
    return nil;
}

+ (NSString *)jjurl_mediaPathWithClass:(Class)classObject bundleName:(NSString *)bundleName fileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSString *name = [NSString stringWithFormat:@"Media/%@", fileName];
    NSString *path =  [NSBundle jjurl_pathWithClass:classObject bundleName:bundleName fileName:name fileType:fileType];
    return path;
}

@end
