//
//  NSMutableArray+LPDStack.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/1.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (LPDStack)

- (void)pushObject:(id)anObject;

- (nullable id)popObject;

- (nullable id)peekObject;

@end

NS_ASSUME_NONNULL_END
