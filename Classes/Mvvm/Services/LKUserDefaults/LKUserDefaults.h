//
//  LKUserDefaults.h
//  LKUserDefaults
//
//  Created by Hiroshi Hashiguchi on 2014/01/08.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKKeyValueStore.h"

@interface LKUserDefaults : LKKeyValueStore

#pragma mark - API
- (void)registerDefaults;           // Should be overwritten in subclass
- (instancetype)registeredDefaults; // Get registerDefaults's values

@end
