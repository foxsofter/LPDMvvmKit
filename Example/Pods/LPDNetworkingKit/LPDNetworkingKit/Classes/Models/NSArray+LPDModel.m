//
//  NSArray+LPDModel.m
//  LPDTeam
//
//  Created by foxsofter on 16/2/19.
//  Copyright © 2016年 me.ele. All rights reserved.
//

#import "NSArray+LPDModel.h"
#import <YYModel/YYModel.h>

@implementation NSArray (LPDModel)

- (NSString *)errorCode {
  return objc_getAssociatedObject(self, @selector(setErrorCode:));
}

- (void)setErrorCode:(NSString *)errorCode {
  objc_setAssociatedObject(self, @selector(setErrorCode:), errorCode, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)errorMessage {
  return objc_getAssociatedObject(self, @selector(setErrorMessage:));
}

- (void)setErrorMessage:(NSString *)errorMessage {
  objc_setAssociatedObject(self, @selector(setErrorMessage:), errorMessage, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

+ (NSArray *)modelArrayWithClass:(Class)cls json:(id)json {
  return [NSArray yy_modelArrayWithClass:cls json:json];
}

@end
