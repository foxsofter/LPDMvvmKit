//
//  LPDViewModelReactProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/17.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>


NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewModelReactProtocol <NSObject>

@optional

@property (nonatomic, strong, readonly) RACSignal *didLoadViewSignal;

@property (nonatomic, strong, readonly) RACSignal *didLayoutSubviewsSignal;

@property (nonatomic, strong, readonly) RACSignal *didBecomeActiveSignal;

@property (nonatomic, strong, readonly) RACSignal *didBecomeInactiveSignal;

@end

NS_ASSUME_NONNULL_END
