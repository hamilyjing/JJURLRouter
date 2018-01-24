//
//  JJURLHandler.m
//  PANewToapAPP
//
//  Created by JJ on 16/2/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLHandler.h"
#import <objc/runtime.h>
#import "NSError+JJURLRouter.h"
#import "JJURLLog.h"

static int __JJURLHandlerKey;

@interface JJURLHandler ()

@property (nonatomic, strong) NSDictionary *viewProperties;

@end

@implementation JJURLHandler

#pragma mark - YYModel

+ (Class)modelCustomClassForDictionary:(NSDictionary *)dic
{
    NSString *className = dic[@"class"];
    if (className.length > 0) {
        Class clz = NSClassFromString(className);
        if (clz) {
            return clz;
        }
    }
    return self.class;
}

#pragma mark - public

- (void)openURLWithInput:(JJURLInput *)input completion:(void (^)(JJURLResult *))completion
{
    if (self.redirectURL) {
        JJURLOpenOptions *options = input.options ?: [JJURLOpenOptions new];
        if (!options.sourceURL) {
            options.sourceURL = input.url;
        }
        options.parameters = input.parameters;
        [JJURLRouter openURL:self.redirectURL options:options completion:completion];
        return;
    }
    
    Class clz = NSClassFromString(self.viewController);
    if (clz == nil) {
        if (completion) {
            completion([JJURLResult errorResultWithInput:input code:JJURLErrorDestinationViewControllerNull messsage:[NSString stringWithFormat:@"Class not found: %@", self.viewController]]);
        }
        return;
    }
    
    UIViewController *vc = [[clz alloc] init];
    if (!vc) {
        if (completion) {
            completion([JJURLResult errorResultWithInput:input code:JJURLErrorDestinationViewControllerNull messsage:[NSString stringWithFormat:@"Creating viewController failed: %@", self.viewController]]);
        }
        return;
    }
    
    [self openViewController:vc withInput:input completion:completion];
}

#pragma mark - protected

- (void)setViewProperty:(id)object forKey:(NSString *)key
{
    NSMutableDictionary *params = nil;
    if ([self.viewProperties isKindOfClass:[NSMutableDictionary class]]) {
        params = (NSMutableDictionary *)self.viewProperties;
    } else {
        params = [NSMutableDictionary dictionary];
        if (self.viewProperties.count > 0) {
            [params addEntriesFromDictionary:self.viewProperties];
        }
    }
    if (object) {
        params[key] = object;
    } else {
        [params removeObjectForKey:key];
    }
    self.viewProperties = params;
}

- (void)setOwner:(id)owner
{
    if (_owner != owner) {
        if (_owner) {
            objc_setAssociatedObject(_owner, &__JJURLHandlerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
        _owner = owner;
        if (_owner) {
            objc_setAssociatedObject(_owner, &__JJURLHandlerKey, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
}

- (UIViewController *)viewControllerWithInput:(JJURLInput *)input
{
    if (self.redirectURL) {
        JJURLOpenOptions *options = input.options ?: [JJURLOpenOptions new];
        if (!options.sourceURL) {
            options.sourceURL = input.url;
        }
        options.parameters = input.parameters;
        return [JJURLRouter viewControllerWithURL:self.redirectURL options:options];
    }
    
    Class clz = NSClassFromString(self.viewController);
    if (clz == nil) {
        return nil;
    }
    
    UIViewController *vc = [[clz alloc] init];
    if (!vc) {
        return nil;
    }
    
    return [self preprocessViewController:vc withInput:input completion:nil] ? vc : nil;
}

- (BOOL)preprocessViewController:(UIViewController *)vc withInput:(JJURLInput *)input completion:(void (^)(JJURLResult *))completion
{
    if (self.redirectURL) {
        JJURLOpenOptions *options = input.options ?: [JJURLOpenOptions new];
        if (!options.sourceURL) {
            options.sourceURL = input.url;
        }
        options.parameters = input.parameters;
        [JJURLRouter openURL:self.redirectURL options:options completion:completion];
        return NO;
    }
    
    vc.hidesBottomBarWhenPushed = YES;
    if ([vc respondsToSelector:@selector(prepareWithURLInput:)]) {
        [(id<JJURLSupport>)vc prepareWithURLInput:input];
    }
    
    NSDictionary *vps = input.options.viewProperties;
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    if (self.viewProperties.count > 0) {
        [properties addEntriesFromDictionary:self.viewProperties];
    }
    if (vps.count > 0) {
        [properties addEntriesFromDictionary:vps];
    }
    if (properties.count > 0) {
        @try {
            [properties enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                [vc setValue:obj forKeyPath:key];
            }];
        } @catch (NSException *exception) {
            
            if (completion) {
                completion([JJURLResult resultWithInput:input source:nil destination:vc error:[NSError jjurl_errorWithURLException:exception]]);
            }
            return NO;
             
        } @finally {
        }
    }
    
    UIViewController *sourceViewController = input.options.sourceViewController;
    UIViewController *oldVc = vc; /// for error
    if (input.options.preparation) {
        __weak typeof(input) winput = input;
        vc = input.options.preparation(sourceViewController, vc, winput);
    }
    if (!vc) {
        if (completion) {
            completion([JJURLResult errorResultWithInput:input code:-1 messsage:[NSString stringWithFormat:@"preparation cancelled: %@", oldVc]]);
        }
        return NO;
    }
    
    return YES;
}

- (void)openViewController:(UIViewController *)vc withInput:(JJURLInput *)input completion:(void (^)(JJURLResult *))completion
{
    if(![self preprocessViewController:vc withInput:input completion:completion]) {
        return;
    }
    
    NSString *action = input.options.action ?: self.action;
    if (action == nil) {
        action = JJURLOpenActionPush;
    }
    BOOL animated = input.options ? input.options.animated : YES;
    
    UIViewController *sourceViewController = input.options.sourceViewController;
    if ([action isEqualToString:JJURLOpenActionPush]) {
        if (sourceViewController && ![sourceViewController isKindOfClass:[UINavigationController class]] && sourceViewController.navigationController.topViewController != sourceViewController) {
            if (completion) {
                completion([JJURLResult errorResultWithInput:input code:-1 messsage:@"Source ViewController is not current topViewController."]);
            }
            return;
        }
        
        UINavigationController *nav = [sourceViewController isKindOfClass:[UINavigationController class]] ? sourceViewController : sourceViewController.navigationController;
        if (nav) {
            [nav pushViewController:vc animated:animated];
            if (completion) {
                completion([JJURLResult resultWithInput:input source:nil destination:nil error:nil]);
            }
        } else {
            if (completion) {
                completion([JJURLResult errorResultWithInput:input code:JJURLErrorSourceViewControllerNull messsage:@"Can't find navigation controller."]);
            }
        }
    } else if ([action isEqualToString:JJURLOpenActionPresent]) {
        UIViewController *presentingViewController = sourceViewController ?: [UIApplication sharedApplication].delegate.window.rootViewController;
        if (!input.options.autoNavigationDisabled) {
            if (![vc isKindOfClass:[UINavigationController class]] && ![vc isKindOfClass:[UITabBarController class]]) {
                vc = [[UINavigationController alloc] initWithRootViewController:vc];
            }
        }
        [presentingViewController presentViewController:vc animated:animated completion:^{
            if (completion) {
                completion([JJURLResult resultWithInput:input source:presentingViewController destination:vc error:nil]);
            }
        }];
    } else {
        if (completion) {
            completion([JJURLResult errorResultWithInput:input code:JJURLErrorUnsupportedAction messsage:[NSString stringWithFormat:@"Unsupported action: %@", action]]);
        }
    }
}

- (void)dealloc
{
    JJURLLog(@"handler dealloc: %@, %@", self, self.url);
}

@end
