//
//  RACSignal+LPDAddition.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/24.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "RACSignal+LPDAddition.h"

@implementation RACSignal (LPDAddition)

- (RACSignal *)doAfterNext:(void (^)(id x))block
{
    NSCParameterAssert(block != NULL);

    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [self subscribeNext:^(id x) {
            [subscriber sendNext:x];
            block(x);
        }
                      error:^(NSError *error) {
            [subscriber sendError:error];
        }
                  completed:^{
            [subscriber sendCompleted];
        }];
        return [RACDisposable disposableWithBlock:^{
        }];
    }] setNameWithFormat:@"[%@] -%@", self.name, NSStringFromSelector(_cmd)];
}

@end
