//
//  LPDApiClient.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/19.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "LPDApiServerProtocol.h"
#import "LPDModelProtocol.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDApiClient : NSObject

/**
 *  @brief init
 */
- (instancetype)initWithServer:(nullable NSObject<LPDApiServerProtocol> *)server;

/**
 *  @brief api server
 */
@property (nonatomic, strong, nullable) NSObject<LPDApiServerProtocol> *server;

/**
 *  @brief AFHTTPSessionManager
 */
@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;

/**
 *  @brief A convenience around -GET:parameters:success:failure: that returns a cold
 *         signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_GET:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -HEAD:parameters:success:failure: that returns a cold
 *         signal of the resulting response headers or error.
 */
- (RACSignal *)rac_HEAD:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -POST:parameters:success:failure: that returns a cold
 *         signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_POST:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -POST:parameters:constructingBodyWithBlock:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_POST:(NSString *)path
                 parameters:(nullable id)parameters
  constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block;

/**
 *  @brief A convenience around -PUT:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_PUT:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -PATCH:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief A convenience around -DELETE:parameters:success:failure:
 *         that returns a cold signal of the resulting JSON object and response headers or error.
 */
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(nullable id)parameters;

/**
 *  @brief get container of model class.
 *
 *  @return container of model class
 */
+ (NSMutableDictionary<NSString *, Class> *)dictionaryOfEndpointClasses;

/**
 *  @brief get response model class by endpoint.
 *
 *  @param endpoint endpoint
 *
 *  @return response model class
 */
+ (nullable Class)getResponseClass:(NSString *)endpoint;

/**
 *  @brief set response model class for endpoint.
 *
 *  @param responseClass response model class
 *  @param endpoint      endpoint
 */
+ (void)setResponseClass:(Class)responseClass forEndpoint:(NSString *)endpoint;

/**
 *  @brief deserialization response object to response model.
 *
 *  @param response       response
 *  @param endpoint       endpoint
 *  @param responseObject response object
 *
 *  @return response model
 */
- (nullable NSObject *)resolveResponse:(NSHTTPURLResponse *)response
                              endpoint:(NSString *)endpoint
                        responseObject:(id)responseObject;

@end

NS_ASSUME_NONNULL_END
