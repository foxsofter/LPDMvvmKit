//
//  LPDApiServer.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "AFNetworkReachabilityManager.h"
#import "LPDApiServer.h"
#import "ReactiveCocoa.h"

@interface LPDApiServer ()

@property (nonatomic, strong) AFNetworkReachabilityManager *reachability;

@property (nonatomic, strong) NSMutableDictionary *dictionaryOfServerUrls;

@end

static RACSubject *networkStatusSubject;

@implementation LPDApiServer

@synthesize serverType = _serverType;

- (instancetype)init {
  self = [super init];
  if (self) {
    _dictionaryOfServerUrls = [NSMutableDictionary dictionaryWithCapacity:3];

    self.reachability = [AFNetworkReachabilityManager sharedManager];
    [self.reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
      if (networkStatusSubject) {
        [networkStatusSubject sendNext:@(status)];
      }
    }];
  }
  return self;
}

- (void)setServerUrl:(NSString *)serverUrl forServerType:(LPDApiServerType)serverType {
  if ([[_dictionaryOfServerUrls objectForKey:@(serverType)] isEqualToString:serverUrl]) {
    return;
  }
  [_dictionaryOfServerUrls setObject:serverUrl forKey:@(serverType)];
  if (_serverType != serverType) {
    return;
  }
}

- (void)startMonitoring {
  [_reachability startMonitoring];
}

- (void)stopMonitoring {
  [_reachability stopMonitoring];
}

#pragma mark - properties

- (void)setServerType:(LPDApiServerType)serverType {
  if (serverType == LPDApiServerTypeNone || _serverType == serverType) {
    return;
  }
  _serverType = serverType;
}

- (NSString *)serverUrl {
  return _serverType == LPDApiServerTypeNone ? nil : [_dictionaryOfServerUrls objectForKey:@(_serverType)];
}

- (LPDNetworkStatus)networkStatus {
  return (LPDNetworkStatus)_reachability.networkReachabilityStatus;
}

- (BOOL)isReachable {
  return _reachability.reachable;
}

- (BOOL)isReachableViaWWAN {
  return _reachability.reachableViaWWAN;
}

- (BOOL)isReachableViaWiFi {
  return _reachability.reachableViaWiFi;
}

- (RACSignal *)networkStatusSignal {
  return networkStatusSubject
           ?: (networkStatusSubject = [[RACSubject subject] setNameWithFormat:@"networkStatusSignal"]);
}

@end
