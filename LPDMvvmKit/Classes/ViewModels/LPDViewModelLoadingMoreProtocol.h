//
//  LPDViewModelLoadingMoreProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/6.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM (NSUInteger, LPDLoadingMoreState) {
    LPDLoadingMoreStateEnd,
    LPDLoadingMoreStateBegin,
    LPDLoadingMoreStateNoMore,
};

@protocol LPDViewModelLoadingMoreProtocol <NSObject>

/**
 *  @brief  列表中上滑加载更多数据
 */
@property (nonatomic, assign) LPDLoadingMoreState loadingMoreState;

/**
 *  @brief  上滑加载的信号，需由子类赋值，当设为nil时表示没有更多数据需要加载了
 *
 *  @return loadingMore RACSignal
 */
@property (nullable, nonatomic, strong) RACSignal *loadingMoreSignal;

@end

NS_ASSUME_NONNULL_END
