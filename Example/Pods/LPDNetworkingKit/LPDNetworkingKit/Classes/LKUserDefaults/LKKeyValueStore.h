//
//  LKKeyValueStore.h
//  LKUserDefaults
//
//  Created by Hiroshi Hashiguchi on 2014/01/10.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKKeyValueStore : NSObject

#pragma mark - API
+ (instancetype)sharedInstance;
+ (void)removeUserDefaults;

#pragma mark - Callback (must be overwritten in subclass)
+ (id)proxyInstance;

@end
