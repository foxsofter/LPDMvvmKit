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

NS_ASSUME_NONNULL_BEGIN

@interface LPDApiClient ()

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

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
  @weakify(self);
  return [[RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);
    self.request = [self.sessionManager.requestSerializer
      multipartFormRequestWithMethod:@"POST"
                           URLString:[[NSURL URLWithString:path
                                             relativeToURL:[NSURL URLWithString:self.server.serverUrl]] absoluteString]
                          parameters:parameters
           constructingBodyWithBlock:block
                               error:nil];

    NSURLSessionDataTask *task = [self.sessionManager
      dataTaskWithRequest:self.request
        completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
          @strongify(self);
          if (error) {
            [subscriber sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo]];
          } else {
            NSObject *responseModel = nil;
            if (responseObject) {
              responseModel =
                [self resolveResponse:(NSHTTPURLResponse *)response endpoint:path responseObject:responseObject];
            }
            if (responseModel) {
              [subscriber sendNext:RACTuplePack(responseModel, response)];
            } else {
              [subscriber sendNext:RACTuplePack(responseObject, response)];
            }
            [subscriber sendCompleted];
          }
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
  @weakify(self);
  return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
    @strongify(self);
    NSString *urlString = nil;
    if ([path containsString:@"http"]) {
      urlString = path;
    } else {
      urlString = [[NSURL URLWithString:path relativeToURL:[NSURL URLWithString:self.server.serverUrl]] absoluteString];
    }
    self.request = [self.sessionManager.requestSerializer requestWithMethod:method
                                                                  URLString:urlString
                                                                 parameters:parameters
                                                                      error:nil];

    NSURLSessionDataTask *task = [self.sessionManager
      dataTaskWithRequest:self.request
        completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
          @strongify(self);
          if (error) {
            [subscriber sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:error.userInfo]];
          } else {
            NSObject *responseModel = nil;
            if (responseObject) {
              responseModel =
                [self resolveResponse:(NSHTTPURLResponse *)response endpoint:path responseObject:responseObject];
            }
            if (responseModel) {
              [subscriber sendNext:RACTuplePack(responseModel, response)];
            } else {
              [subscriber sendNext:RACTuplePack(responseObject, response)];
            }
            [subscriber sendCompleted];
          }
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

  id cls = [[self dictionaryOfEndpointClasses] objectForKey:endpoint];
  if (cls) {
    return cls;
  }

  return [[self dictionaryOfEndpointClasses] objectForKey:[endpoint stringByDeletingLastPathComponent]];
}
+ (void)setResponseClass:(Class)responseClass forEndpoint:(NSString *)endpoint {
  [[self dictionaryOfEndpointClasses] setObject:responseClass forKey:endpoint];
}

- (nullable NSObject *)resolveResponse:(NSHTTPURLResponse *)response
                              endpoint:(NSString *)endpoint
                        responseObject:(id)responseObject {
  id responseModel = nil;
  Class responseClass = [self.class getResponseClass:endpoint];
  if (responseClass) {
    if ([responseObject isKindOfClass:NSArray.class]) {
      responseModel = [NSArray modelArrayWithClass:responseClass json:responseObject];
    } else {
      responseModel = [responseClass modelWithJSON:responseObject];
    }
  }
  return responseModel;
}

#pragma mark - properties

- (AFHTTPRequestSerializer *)requestSerializer {
  return _sessionManager.requestSerializer;
}

- (void)setRequestSerializer:(AFHTTPRequestSerializer<AFURLRequestSerialization> *)requestSerializer {
  _sessionManager.requestSerializer = requestSerializer;
}

- (AFHTTPResponseSerializer *)responseSerializer {
  return _sessionManager.responseSerializer;
}

- (void)setResponseSerializer:(AFHTTPResponseSerializer<AFURLResponseSerialization> *)responseSerializer {
  _sessionManager.responseSerializer = responseSerializer;
}


@end

NS_ASSUME_NONNULL_END
