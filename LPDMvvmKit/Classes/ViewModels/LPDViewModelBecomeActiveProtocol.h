//
//  LPDViewModelBecomeActiveProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/3/17.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LPDViewModelBecomeActiveProtocol <NSObject>

@property (nonatomic, assign, getter = isActive) BOOL active;

@property (nonatomic, strong, readonly) RACSignal *didBecomeActiveSignal;

@property (nonatomic, strong, readonly) RACSignal *didBecomeInactiveSignal;

@end

NS_ASSUME_NONNULL_END
