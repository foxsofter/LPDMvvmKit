//
//  LPDPostModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDPostModel.h"
#import <LPDMvvmKit/LPDMvvmKit.h>

NSString *const kLPDApiEndpointPosts = @"posts";

@implementation LPDPostModel

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [LPDApiClient setResponseClass:LPDPostModel.class forEndpoint:kLPDApiEndpointPosts];
  });
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier": @"id",
  };
}

@end
