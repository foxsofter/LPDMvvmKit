//
//  LPDApiClient.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/19.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDApiClient.h"
#import "LPDModel.h"
#import "LPDModelProtocol.h"
#import "NSArray+LPDModel.h"


@implementation LPDResponseResolveResult

+ (instancetype)resultWithModel:(NSObject *)responseModel error:(NSError *)error {
  LPDResponseResolveResult *result = [[LPDResponseResolveResult alloc] init];
  result.responseModel = responseModel;
  result.error = error;
  return result;
}

@end

NS_ASSUME_NONNULL_BEGIN

@interface LPDApiClient ()

@property (nonatomic, strong, readwrite) AFHTTPSessionManager *sessionManager;

@property (nonatomic, strong) NSMutableURLRequest *request;

@end

@implementation LPDApiClient

#pragma mark - life cycle

- (instancetype)init {
  return [self initWithServer:nil];
}

- (instancetype)initWithServer:(nullable NSObject<LPDApiServerProtocol> *)server {
  self = [super init];
  if (self) {
    _server = server;
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.URLCache = nil;
    _sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil sessionConfiguration:configuration];

    _sessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
  }
  return self;
}

#pragma mark - public methods

- (RACSignal *)rac_GET:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"GET"]
    setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"HEAD"]
    setNameWithFormat:@"%@ -rac_HEAD: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"POST"]
    setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path
                 parameters:(nullable id)parameters
  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block {
  parameters = [self addExtraParams:parameters];
  @weakify(self);
  return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);
     NSMutableURLRequest * request = [self.sessionManager.requestSerializer
      multipartFormRequestWithMethod:@"POST"
                           URLString:[[NSURL URLWithString:path
                                             relativeToURL:[NSURL URLWithString:self.server.serverUrl]] absoluteString]
                          parameters:parameters
           constructingBodyWithBlock:block
                               error:nil];
    request = [self addExtraHTTPHeader:request withParameters:parameters];
    NSURLSessionDataTask *task = [self.sessionManager
      dataTaskWithRequest:self.request
        completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
          @strongify(self);
          LPDResponseResolveResult *result = [self resolveResponse:(NSHTTPURLResponse *)response endpoint:path responseObject:responseObject error:error];
          NSObject *responseModel = result.responseModel;
          NSError *err = result.error;
          if (err) {
            [subscriber sendError:err];
          }
          if (responseModel) {
            [subscriber sendNext:RACTuplePack(responseModel, response)];
          }
          [subscriber sendCompleted];
        }];
    [task resume];

    return [RACDisposable disposableWithBlock:^{
      [task cancel];
    }];
  }] setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@, constructingBodyWithBlock:", self.class, path, parameters];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"PUT"]
    setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"PATCH"]
    setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters {
  return [[self rac_requestPath:path parameters:parameters method:@"DELETE"]
    setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(nullable id)parameters method:(NSString *)method {
  parameters = [self addExtraParams:parameters];
  @weakify(self);
  return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);
    NSString *urlString = nil;
    if ([path containsString:@"http"]) {
      urlString = path;
    } else {
      urlString = [[NSURL URLWithString:path relativeToURL:[NSURL URLWithString:self.server.serverUrl]] absoluteString];
    }
    NSMutableURLRequest * request = [self.sessionManager.requestSerializer requestWithMethod:method
                                                                  URLString:urlString
                                                                 parameters:parameters
                                                                      error:nil];
    request = [self addExtraHTTPHeader:request withParameters:parameters];
    NSURLSessionDataTask *task = [self.sessionManager
      dataTaskWithRequest:request
        completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
          @strongify(self);
            LPDResponseResolveResult *result = [self resolveResponse:(NSHTTPURLResponse *)response endpoint:path responseObject:responseObject error:error];
            NSObject *responseModel = result.responseModel;
            NSError *err = result.error;
            if (err) {
              [subscriber sendError:err];
            }
            if (responseModel) {
              [subscriber sendNext:RACTuplePack(responseModel, response)];
            }
            [subscriber sendCompleted];
        }];

    [task resume];

    return [RACDisposable disposableWithBlock:^{
      [task cancel];
    }];
  }];
}

+ (NSMutableDictionary<NSString *, Class> *)dictionaryOfEndpointClasses {
  static NSMutableDictionary<NSString *, Class> *dictionaryOfEndpointClasses = nil;
  if (!dictionaryOfEndpointClasses) {
    dictionaryOfEndpointClasses = [NSMutableDictionary dictionary];
  }

  return dictionaryOfEndpointClasses;
}

+ (nullable Class)getResponseClass:(NSString *)endpoint {
  NSDictionary *endpointClasses = [self dictionaryOfEndpointClasses];
  __block id cls = [endpointClasses objectForKey:endpoint];
  if (cls) {
    return cls;
  }

  [endpointClasses enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, Class obj, BOOL * _Nonnull stop) {
    if ([key containsString:@"%@"]) {
      NSString *endpointPattern = [key stringByReplacingOccurrencesOfString:@"%@" withString:@"*"];
      NSError *error = nil;
      NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:endpointPattern options:NSRegularExpressionCaseInsensitive error:&error];
      NSRange matchRange = [regex rangeOfFirstMatchInString:endpoint options:NSMatchingReportProgress range:NSMakeRange(0, endpoint.length)];
      if (matchRange.location != NSNotFound) {
        cls = obj;
        *stop = YES;
      }
    }
  }];
  
  return cls;
}
+ (void)setResponseClass:(Class)responseClass forEndpoint:(NSString *)endpoint {
  [[self dictionaryOfEndpointClasses] setObject:responseClass forKey:endpoint];
}


/**
 *  @brief override to handle response
 *
 */
- (nullable LPDResponseResolveResult *)resolveResponse:(NSHTTPURLResponse *)response
                              endpoint:(NSString *)endpoint
                        responseObject:(id)responseObject
                                 error:(NSError *)error {
  if (error) {
    return [LPDResponseResolveResult resultWithModel:nil error:[NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo]];
  }
  id responseModel = responseObject;
  id model = [self modelWithResponseObject:responseObject endpoint:endpoint];
  if (model) {
    responseModel = model;
  }
  return [LPDResponseResolveResult resultWithModel:responseModel error:nil];
}

- (NSObject *)modelWithResponseObject:(id)responseObject endpoint:(NSString *)endpoint {
  id model = nil;
  Class responseClass = [self.class getResponseClass:endpoint];
  if (responseClass) {
    if ([responseObject isKindOfClass:NSArray.class]) {
      model = [NSArray modelArrayWithClass:responseClass json:responseObject];
    } else {
      model = [responseClass modelWithJSON:responseObject];
    }
  }
  return model;
}

// add extra headers
- (NSMutableURLRequest *)addExtraHTTPHeader:(NSMutableURLRequest *)request withParameters:(nullable id)parameters {
  return request;
}

//add extra params like timestamp
- (id)addExtraParams:(id)parameters {
  return parameters;
}


@end

NS_ASSUME_NONNULL_END
