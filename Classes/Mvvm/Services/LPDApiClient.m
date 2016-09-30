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

//    [_sessionManager setSecurityPolicy:[self customSecurityPolicy]];
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

#pragma mark - private methods

- (AFSecurityPolicy *)customSecurityPolicy {
  NSLog(@"security policy");

  /* 配置1：验证锁定的证书，需要在项目中导入eleme.cer根证书*/
  // /先导入证书
  NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"eleme" ofType:@"cer"]; //证书的路径
  // NSLog(@"certPath  % @",cerPath);
  NSData *certData = [NSData dataWithContentsOfFile:cerPath];
  // NSLog(@"certData %@",certData);

  // AFSSLPinningModeCertificate 使用证书验证模式
  AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];

  // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
  // 如果是需要验证自建证书，需要设置为YES
  securityPolicy.allowInvalidCertificates = YES;

  // validatesDomainName 是否需要验证域名，默认为YES；
  //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
  //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
  //如置为NO，建议自己添加对应域名的校验逻辑。
  securityPolicy.validatesDomainName = YES;

  securityPolicy.pinnedCertificates = [NSSet setWithObject:certData];
  /*配置1结束*/

  /* 配置2：一般的验证证书，允许信任（包括系统自带的和个人安装的）的证书库中证书签名的任何证书
   * 下面的配置可以验证HTTPS的证书。不过如果在iOS设备上安装了自建证书，那也会验证通过。
   * 如把抓包工具的证书安装在iOS设备上，仍然可以抓到HTTPS的数据包
   AFSecurityPolicy *securityPolicy = [[AFSecurityPolicy alloc] init];
   securityPolicy.allowInvalidCertificates = NO;
   securityPolicy.validatesDomainName = YES;
   mgr.securityPolicy = securityPolicy;
   配置2结束*/

  return securityPolicy;
}

@end

NS_ASSUME_NONNULL_END
