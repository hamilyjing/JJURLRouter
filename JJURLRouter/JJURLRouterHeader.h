#import <Foundation/Foundation.h>

#if __has_include(<JJURLRouter/JJURLRouter.h>)

//! Project version number for JJURLRouter.
FOUNDATION_EXPORT double JJURLRouterVersionNumber;

//! Project version string for JJURLRouter.
FOUNDATION_EXPORT const unsigned char JJURLRouterVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <JJURLRouter/PublicHeader.h>
#import <JJURLRouter/JJURLHandler.h>
#import <JJURLRouter/JJURLContext.h>
#import <JJURLRouter/NSBundle+JJURLRouter.h>
#import <JJURLRouter/NSError+JJURLRouter.h>
#import <JJURLRouter/UIViewController+JJURLRouter.h>
#import <JJURLRouter/JJURLResult.h>
#import <JJURLRouter/JJURLOpenOptions.h>
#import <JJURLRouter/JJURLModule.h>
#import <JJURLRouter/JJURLModuleProtocol.h>
#import <JJURLRouter/JJURLInput.h>
#import <JJURLRouter/JJURLManager.h>
#import <JJURLRouter/JJURLLog.h>
#import <JJURLRouter/JJURLSupport.h>
#import <JJURLRouter/JJURLError.h>
#import <JJURLRouter/JJURLConfigurableInterceptor.h>
#import <JJURLRouter/JJURLInterceptor.h>

#else

#import "JJURLHandler.h"
#import "JJURLContext.h"
#import "NSBundle+JJURLRouter.h"
#import "NSError+JJURLRouter.h"
#import "UIViewController+JJURLRouter.h"
#import "JJURLResult.h"
#import "JJURLOpenOptions.h"
#import "JJURLModule.h"
#import "JJURLModuleProtocol.h"
#import "JJURLInput.h"
#import "JJURLManager.h"
#import "JJURLLog.h"
#import "JJURLSupport.h"
#import "JJURLError.h"
#import "JJURLConfigurableInterceptor.h"
#import "JJURLInterceptor.h"

#endif
