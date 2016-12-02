//
//  LKUserDefaultsProxy.h
//  LKUserDefaults
//
//  Created by Hiroshi Hashiguchi on 2014/01/08.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import "LKPropertyHook.h"
#import <Foundation/Foundation.h>

@class LKUserDefaults;
@interface LKUserDefaultsProxy : LKPropertyHook

#pragma mark - API
- (id)initWithUserDefaults:(LKUserDefaults *)userDefaults;

@end
