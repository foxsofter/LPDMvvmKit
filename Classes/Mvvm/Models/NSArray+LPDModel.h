//
//  NSArray+LPDModel.h
//  LPDTeam
//
//  Created by foxsofter on 16/2/19.
//  Copyright © 2016年 me.ele. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (LPDModel)

@property (nonatomic, copy) NSString *errorCode;

@property (nonatomic, copy) NSString *errorMessage;

+ (NSArray *)modelArrayWithClass:(Class)cls json:(id)json;

@end
