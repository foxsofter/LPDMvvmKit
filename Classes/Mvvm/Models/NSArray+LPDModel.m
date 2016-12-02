//
//  NSArray+LPDModel.m
//  LPDTeam
//
//  Created by foxsofter on 16/2/19.
//  Copyright © 2016年 me.ele. All rights reserved.
//

#import "NSArray+LPDModel.h"
#import "NSObject+LPDAssociatedObject.h"
#import <YYModel/YYModel.h>

@implementation NSArray (LPDModel)

- (NSString *)errorCode {
  return [self object:@selector(setErrorCode:)];
}

- (void)setErrorCode:(NSString *)errorCode {
  [self setCopyNonatomicObject:errorCode withKey:@selector(setErrorCode:)];
}

- (NSString *)errorMessage {
  return [self object:@selector(setErrorMessage:)];
}

- (void)setErrorMessage:(NSString *)errorMessage {
  [self setCopyNonatomicObject:errorMessage withKey:@selector(setErrorMessage:)];
}

+ (NSArray *)modelArrayWithClass:(Class)cls json:(id)json {
  return [NSArray yy_modelArrayWithClass:cls json:json];
}

@end
