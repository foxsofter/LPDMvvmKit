//
//  LPDAppApiClient.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDAppApiClient.h"

@implementation LPDAppApiClient

+ (instancetype)sharedInstance {
  static LPDAppApiClient *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    LPDApiServer *apiServer = [[LPDApiServer alloc] init];
    [apiServer setServerUrl:@"https://jsonplaceholder.typicode.com/" forServerType:LPDApiServerTypeAlpha];
    [apiServer setServerType:LPDApiServerTypeAlpha];
    
    instance = [[LPDAppApiClient alloc] initWithServer:apiServer];
  });
  return instance;
}

@end
