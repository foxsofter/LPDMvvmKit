//
//  NSMutableArray+LPDStack.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/1.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (LPDStack)

- (void)pushObject:(id)anObject;

- (id)popObject;

- (id)peekObject;

@end
