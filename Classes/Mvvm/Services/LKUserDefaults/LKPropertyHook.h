//
//  LKPropertyHook.h
//  LKUserDefaults
//
//  Created by Hiroshi Hashiguchi on 2014/01/08.
//  Copyright (c) 2014年 lakesoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LKPropertyHook : NSProxy

@property (strong, nonatomic, readonly) NSObject *target;

#pragma mark - Basics
- (instancetype)initWithTarget:(NSObject *)target;

#pragma mark - API for subclass
- (NSString *)classNameForKey:(NSString *)key;

#pragma mark - Overwritten in subclass
- (void)setPropertyValue:(id)value forKey:(NSString *)key;
- (id)getPropertyValueForKey:(NSString *)key;

@end
