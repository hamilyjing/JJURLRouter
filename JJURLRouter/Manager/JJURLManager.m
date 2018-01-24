//
//  JJURLManager.m
//  
//
//  Created by JJ on 16/4/18.
//  Copyright © 2016年 JJ. All rights reserved.
//

#import "JJURLManager.h"
#import <YYModel/YYModel.h>
#import "JJURLConfigurableInterceptor.h"
#import "JJURLHandler.h"
#import "JJURLLog.h"
#import "JJURLModuleProtocol.h"

@interface JJURLManager ()

@property (nonatomic, strong) NSMutableDictionary *handlersMetaCache;
@property (nonatomic, strong) NSMutableArray *interceptors;

/// For effecient of opening url. All refers of interceptors is from self.interceptors
@property (nonatomic, strong) NSMutableDictionary<NSString *, NSMutableArray <JJURLInterceptor *> *>*urlInterceptorsCache;
@property (nonatomic, strong) NSMutableArray<JJURLInterceptor *> *globalInterceptors;
@property (nonatomic, strong) NSMutableDictionary<NSString *, Class> *protocolCache;

@end

@implementation JJURLManager

#pragma mark - lifecycle

+ (instancetype)sharedInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        instance = self.new;
        JJURLLog(@"duration = %f", [NSDate timeIntervalSinceReferenceDate] - start);
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.protocolCache = [NSMutableDictionary dictionary];
        [self loadConfiguration];
    }
    return self;
}

#pragma mark - public

- (BOOL)canOpenURL:(NSString *)urlString
{
    urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (urlString.length == 0) {
        return NO;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    if (components == nil) {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        components = [NSURLComponents componentsWithString:urlString];
    }
    components.query = nil;
    components.fragment = nil;
    components.user = nil;
    components.password = nil;
    NSString *pattern = components.URL.absoluteString.lowercaseString;
    
    BOOL found = pattern && self.handlersMetaCache[pattern];
    if (!found) {
        NSString *scheme = components.scheme.lowercaseString;
        found = scheme && self.handlersMetaCache[scheme];
    }
    return found;
}

- (void)registerProtocolClass:(Class)cls protocol:(Protocol *)proto {
    if (proto && cls) {
        self.protocolCache[NSStringFromProtocol(proto)] = cls;
    }
}

- (Class)classForProtocol:(Protocol *)proto {
    if (proto) {
        return self.protocolCache[NSStringFromProtocol(proto)];
    }else {
        return nil;
    }
}

- (void)openURL:(NSString *)urlString options:(JJURLOpenOptions *)options completion:(void (^)(JJURLResult *))completion
{
    urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    JJURLInput *input = [self parseURLWithString:urlString options:options];
    if (!input) {
        if (completion) {
            completion([JJURLResult errorResultWithInput:input code:-1 messsage:@"Parse URLInput error."]);
        }
        return;
    }
    
    NSMutableArray *interceptors = [NSMutableArray array];
    [interceptors addObjectsFromArray:self.urlInterceptorsCache[input.pattern]];
    [interceptors addObjectsFromArray:self.globalInterceptors];
    [interceptors sortUsingComparator:^NSComparisonResult(JJURLConfigurableInterceptor * obj1, JJURLConfigurableInterceptor *obj2) {
        return [obj1.sort compare:obj2.sort];
    }];
    
    void (^c2)(JJURLResult *result) = ^(JJURLResult *result) {
        JJURLResult *output = [self postprocessWithInput:result.input interceptors:interceptors result:result];
        JJURLLog(@"openURL %@: %@, error: %@", output.success ? @"success" : @"failed", urlString, output.error);
        if (completion) {
            completion(output);
        }
    };
    
    if (![self preprocessWithInput:input interceptors:interceptors completion:c2]) {
        return;
    }
    
    JJURLHandler *handler = [input.configure isKindOfClass:[NSDictionary class]] ? [JJURLHandler yy_modelWithJSON:input.configure] : nil;
    if (!handler) {
        c2([JJURLResult errorResultWithInput:input code:JJURLErrorHandlerNotFound messsage:@"Create handler failed."]);
        return;
    }
    
    [handler openURLWithInput:input completion:c2];
}

- (UIViewController *)viewControllerWithURL:(NSString *)urlString options:(JJURLOpenOptions *)options
{
    urlString = [urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    JJURLInput *input = [self parseURLWithString:urlString options:options];
    if (!input) {
        return nil;
    }
    
    JJURLHandler *handler = [input.configure isKindOfClass:[NSDictionary class]] ? [JJURLHandler yy_modelWithJSON:input.configure] : nil;
    if (![handler respondsToSelector:@selector(viewControllerWithInput:)]) {
        return nil;
    }
    
    return [handler viewControllerWithInput:input];
}

- (JJURLInterceptor *)interceptorForName:(NSString *)name
{
    for (JJURLInterceptor *interceptor in self.interceptors) {
        if ([interceptor.name isEqualToString:name]) {
            return interceptor;
        }
    }
    return nil;
}

#pragma mark - private

- (void)loadConfiguration
{
    NSString *url = [[NSBundle mainBundle] pathForResource:@"JJURLConfiguration" ofType:@"plist"];
    NSURL *configURL = nil;
    if (url) {
       configURL = [[NSURL alloc] initFileURLWithPath:url];
    }
    [self loadConfigurationWithURL:configURL];
}

- (void)loadConfigurationWithURL:(NSURL *)configurationURL
{
    //The default local configuration (handler & interceptor)
    NSDictionary *config = [NSDictionary dictionary];
    if (configurationURL) {
        config = [NSDictionary dictionaryWithContentsOfURL:configurationURL];
    }
    
    //module handler
    NSMutableDictionary *moduleHandlerConfigs = [NSMutableDictionary dictionary];
    //module interceptor
    NSMutableArray<JJURLConfigurableInterceptor *> *moduleInterceptors = [NSMutableArray array];
    
    [self.protocolCache enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class  _Nonnull obj, BOOL * _Nonnull stop) {
        id<JJURLModuleProtocol> protocolImpObject = [obj new];
        if (protocolImpObject) {
            //module url
            if ([protocolImpObject respondsToSelector:@selector(canHandleLinkMappingRelation)]) {
                NSDictionary *tempModuleHandlerConfigs = [protocolImpObject canHandleLinkMappingRelation];
                if ([tempModuleHandlerConfigs isKindOfClass:[NSDictionary class]] && tempModuleHandlerConfigs.count > 0) {
                    [moduleHandlerConfigs addEntriesFromDictionary:tempModuleHandlerConfigs];
                }
            }
            //module interceptor
            if ([protocolImpObject respondsToSelector:@selector(interceptorsLinkMap)]) {
                
                NSDictionary *tempModuleHandlerConfigs = [protocolImpObject interceptorsLinkMap];
                
                [tempModuleHandlerConfigs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    JJURLConfigurableInterceptor *interceptor = [JJURLConfigurableInterceptor yy_modelWithJSON:obj];
                    if (!interceptor) {
                        return;
                    }
                    if (!interceptor.name) {
                        interceptor.name = key;
                    }
                    
                    NSPredicate *alephPredicate = [NSPredicate predicateWithFormat:@"%K ==[cd] %@",@"name",[[interceptor name] lowercaseString]];
                    NSArray *tempArray = [moduleInterceptors filteredArrayUsingPredicate:alephPredicate];
                    if (tempArray.count > 0) {
                        JJURLConfigurableInterceptor *olderInterceptor = tempArray.firstObject;
                        NSMutableArray *interceptorsUrls = [NSMutableArray array];
                        if (olderInterceptor.urls) {
                            [interceptorsUrls addObjectsFromArray:olderInterceptor.urls];
                        }
                        NSMutableArray *interceptorsUrlPrefixs = [NSMutableArray array];
                        if (olderInterceptor.urlPrefixs) {
                            [interceptorsUrlPrefixs addObjectsFromArray:olderInterceptor.urlPrefixs];
                        }
                        NSMutableArray *interceptorsExcept = [NSMutableArray array];
                        if (olderInterceptor.except) {
                            [interceptorsExcept addObjectsFromArray:olderInterceptor.except];
                        }
                        NSMutableArray *interceptorsExceptPrefixs = [NSMutableArray array];
                        if (olderInterceptor.exceptPrefixs) {
                            [interceptorsExceptPrefixs addObjectsFromArray:olderInterceptor.exceptPrefixs];
                        }
                      
                        if (interceptor.urls) {
                            [interceptorsUrls addObjectsFromArray:interceptor.urls];
                        }
                        if (interceptor.urlPrefixs) {
                            [interceptorsUrlPrefixs addObjectsFromArray:interceptor.urlPrefixs];
                        }
                        if (interceptor.except) {
                            [interceptorsExcept addObjectsFromArray:interceptor.except];
                        }
                        if (interceptor.exceptPrefixs) {
                            [interceptorsExceptPrefixs addObjectsFromArray:interceptor.exceptPrefixs];
                        }
                        
                        olderInterceptor.urls = interceptorsUrls;
                        olderInterceptor.urlPrefixs = interceptorsUrlPrefixs;
                        olderInterceptor.except = interceptorsExcept;
                        olderInterceptor.exceptPrefixs = interceptorsExceptPrefixs;
                    }else {
                        [moduleInterceptors addObject:interceptor];
                    }
                }];
                
            }
        }
    }];
    
    // don't parse parameters for efficient.
    NSMutableDictionary *inputs = [NSMutableDictionary dictionary];
    
    {
        NSMutableDictionary *handlerConfigs = [NSMutableDictionary dictionary];
        NSDictionary *baseHandler = config[@"handlers"];
        if ([baseHandler isKindOfClass:[NSDictionary class]] && baseHandler.count > 0) {
            [handlerConfigs addEntriesFromDictionary:baseHandler];
        }
#pragma mark - get urls from modules
        if ([moduleHandlerConfigs isKindOfClass:[NSDictionary class]] && moduleHandlerConfigs.count > 0) {
            [handlerConfigs addEntriesFromDictionary:moduleHandlerConfigs];
        }
#pragma mark - get urls from modules
        
        NSMutableDictionary *handlers = [NSMutableDictionary dictionary];
        
        void (^block)(NSString *url, NSDictionary *meta) = ^(NSString *url, NSDictionary *meta) {
            handlers[url.lowercaseString] = meta;
            JJURLInput *input = [JJURLInput new];
            input.url = url;
            NSURLComponents *components = [NSURLComponents componentsWithString:url];
            components.query = nil;
            components.fragment = nil;
            components.user = nil;
            components.password = nil;
            input.scheme = components.scheme.lowercaseString;
            input.pattern = components.URL.absoluteString.lowercaseString;
            input.configure = meta;
            inputs[url] = input;
        };
        [handlerConfigs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableDictionary *temp = [obj mutableCopy];
            temp[@"name"] = key;
            NSString *url = temp[@"url"];
            NSArray *urls = temp[@"urls"];
            if (urls) {
                [urls enumerateObjectsUsingBlock:^(id  _Nonnull obj2, NSUInteger idx, BOOL * _Nonnull stop2) {
                    temp[@"url"] = obj2;
                    block(obj2, temp);
                }];
            }
            if (url) {
                block(url, temp);
            }
        }];
        self.handlersMetaCache = handlers;
    }
    
    
    {
        NSDictionary *interceptorConfigs = config[@"interceptors"];
        NSMutableArray<JJURLConfigurableInterceptor *> *interceptors = [NSMutableArray array];
        [interceptorConfigs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            JJURLConfigurableInterceptor *interceptor = [JJURLConfigurableInterceptor yy_modelWithJSON:obj];
            if (!interceptor) {
                return;
            }
            
            if (!interceptor.name) {
                interceptor.name = key;
            }
            [interceptors addObject:interceptor];
        }];
        
#pragma mark - get interceptors from modules
        [interceptors enumerateObjectsUsingBlock:^(JJURLConfigurableInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSPredicate *alephPredicate = [NSPredicate predicateWithFormat:@"%K ==[cd] %@",@"name",[[obj name] lowercaseString]];
            NSArray *tempArray = [moduleInterceptors filteredArrayUsingPredicate:alephPredicate];
            if (tempArray.count > 0) {
                JJURLConfigurableInterceptor *lastInterceptor = tempArray.firstObject;
                
                NSMutableArray *interceptorsUrls = [NSMutableArray array];
                if (obj.urls) {
                    [interceptorsUrls addObjectsFromArray:obj.urls];
                }
                NSMutableArray *interceptorsUrlPrefixs = [NSMutableArray array];
                if (obj.urlPrefixs) {
                    [interceptorsUrlPrefixs addObjectsFromArray:obj.urlPrefixs];
                }
                NSMutableArray *interceptorsExcept = [NSMutableArray array];
                if (obj.except) {
                    [interceptorsExcept addObjectsFromArray:obj.except];
                }
                NSMutableArray *interceptorsExceptPrefixs = [NSMutableArray array];
                if (obj.exceptPrefixs) {
                    [interceptorsExceptPrefixs addObjectsFromArray:obj.exceptPrefixs];
                }
            
                if (lastInterceptor.urls) {
                    [interceptorsUrls addObjectsFromArray:lastInterceptor.urls];
                    interceptorsUrls = [interceptorsUrls valueForKeyPath:@"@distinctUnionOfObjects.self"];
                }
                if (lastInterceptor.urlPrefixs) {
                    [interceptorsUrlPrefixs addObjectsFromArray:lastInterceptor.urlPrefixs];
                    interceptorsUrlPrefixs = [interceptorsUrlPrefixs valueForKeyPath:@"@distinctUnionOfObjects.self"];
                }
                if (lastInterceptor.except) {
                    [interceptorsExcept addObjectsFromArray:lastInterceptor.except];
                    interceptorsExcept = [interceptorsExcept valueForKeyPath:@"@distinctUnionOfObjects.self"];
                }
                if (lastInterceptor.exceptPrefixs) {
                    [interceptorsExceptPrefixs addObjectsFromArray:lastInterceptor.exceptPrefixs];
                    interceptorsExceptPrefixs = [interceptorsExceptPrefixs valueForKeyPath:@"@distinctUnionOfObjects.self"];
                }
               
                obj.urls = interceptorsUrls;
                obj.urlPrefixs = interceptorsUrlPrefixs;
                obj.except = interceptorsExcept;
                obj.exceptPrefixs = interceptorsExceptPrefixs;
            }
            
        }];
#pragma mark - get interceptors from modules
        
        [interceptors sortUsingComparator:^NSComparisonResult(JJURLConfigurableInterceptor *obj1, JJURLConfigurableInterceptor *obj2) {
            return [obj1.sort compare:obj2.sort];
        }];
        self.interceptors = interceptors;
        
        NSMutableDictionary *urlInterceptorsCache = [NSMutableDictionary dictionary];
        NSMutableArray *parameterMatchingInterceptors = [NSMutableArray array];
        [interceptors enumerateObjectsUsingBlock:^(JJURLConfigurableInterceptor * _Nonnull interceptor, NSUInteger idx, BOOL * _Nonnull stop) {
            if (interceptor.globalMatch) {
                [parameterMatchingInterceptors addObject:interceptor];
                return;
            }
            
            [inputs enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, JJURLInput *obj, BOOL * _Nonnull stop) {
                if ([interceptor isMatchURLWithInput:obj]) {
                    NSString *key = obj.url;
                    NSMutableArray *temp = urlInterceptorsCache[key];
                    if (!temp) {
                        temp = [NSMutableArray array];
                        urlInterceptorsCache[key] = temp;
                    }
                    [temp addObject:interceptor];
                }
            }];
        }];
        self.urlInterceptorsCache = urlInterceptorsCache;
        self.globalInterceptors = parameterMatchingInterceptors;
    }
}

- (JJURLInput *)parseURLWithString:(NSString *)urlString options:(JJURLOpenOptions *)options
{
    if (urlString.length == 0) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
    if (components == nil) {
        urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        components = [NSURLComponents componentsWithString:urlString];
    }
    NSString *scheme = components.scheme;
    NSString *query = components.percentEncodedQuery;
    
    components.query = nil;
    components.fragment = nil;
    components.user = nil;
    components.password = nil;
    NSString *pattern = components.URL.absoluteString;
    
    NSArray *queryItems = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [queryItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *keyValue = [obj componentsSeparatedByString:@"="];
        if (keyValue.count != 2) {
            return;
        }
        
        NSString *key = [keyValue[0] stringByRemovingPercentEncoding];
        if (key.length == 0) {
            return;
        }
        
        NSString *value = [keyValue[1] stringByRemovingPercentEncoding];
        if (value.length == 0) {
            return;
        }
        
        id oldValue = parameters[key];
        if (oldValue) {
            if (![oldValue isKindOfClass:[NSMutableArray class]]) {
                oldValue = [NSMutableArray arrayWithObject:oldValue];
                parameters[key] = oldValue;
            }
            [oldValue addObject:value];
        } else {
            parameters[key] = value;
        }
    }];
    
    if (options.parameters.count > 0) {
        [parameters addEntriesFromDictionary:options.parameters];
    }
    
    JJURLInput *input = [JJURLInput new];
    input.url = urlString;
    input.scheme = scheme.lowercaseString;
    input.pattern = pattern.lowercaseString;
    input.parameters = parameters;
    input.options = options;
    
    NSDictionary *configure = self.handlersMetaCache[input.pattern];
    if (!configure) {
        configure = self.handlersMetaCache[input.scheme];
    }
    input.configure = configure;
    
    return input;
}

- (BOOL)preprocessWithInput:(JJURLInput *)input interceptors:(NSArray<JJURLInterceptor *> *)interceptors completion:(void (^)(JJURLResult *result))completion
{
    if (!input.pattern) {
        return YES;
    }
    
    __block BOOL pass = YES;
    void (^block)(JJURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) = ^(JJURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj respondsToSelector:@selector(shouldOpenURLWithInput:completion:)]) {
            return;
        }
        if ([obj isKindOfClass:[JJURLConfigurableInterceptor class]] && [(JJURLConfigurableInterceptor *)obj globalMatch] && ![obj isMatchURLWithInput:input]) {
            return;
        }
        if (![obj shouldOpenURLWithInput:input completion:completion]) {
            pass = NO;
            *stop = YES;
        }
    };
    
    [interceptors enumerateObjectsUsingBlock:block];
    return pass;
}

- (JJURLResult *)postprocessWithInput:(JJURLInput *)input interceptors:(NSArray<JJURLInterceptor *> *)interceptors result:(JJURLResult *)result
{
    if (!input.pattern) {
        return result;
    }
    
    __block JJURLResult *output = result;
    void (^block)(JJURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) = ^(JJURLInterceptor * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[JJURLConfigurableInterceptor class]] && [(JJURLConfigurableInterceptor *)obj globalMatch] && ![obj isMatchURLWithInput:input]) {
            return;
        }
        if ([obj respondsToSelector:@selector(didOpenURLWithInput:result:)]) {
            output = [obj didOpenURLWithInput:input result:result];
        }
    };
    [interceptors enumerateObjectsUsingBlock:block];
    return output;
}

@end
