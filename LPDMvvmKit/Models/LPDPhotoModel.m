//
//  LPDPhotoModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDPhotoModel.h"
#import "LPDMvvm.h"

NSString *const kLPDApiEndpointPhotos = @"photos";

@implementation LPDPhotoModel

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [LPDApiClient setResponseClass:LPDPhotoModel.class forEndpoint:kLPDApiEndpointPhotos];
  });
}

+ (NSDictionary *)modelCustomPropertyMapper {
  return @{
    @"identifier": @"id",
  };
}

@end
