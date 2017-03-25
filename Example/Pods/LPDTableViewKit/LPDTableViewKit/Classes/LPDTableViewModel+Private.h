//
//  LPDTableViewModel+Private.h
//  Pods
//
//  Created by foxsofter on 16/12/3.
//
//

#import "LPDTableViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDTableViewModel ()

@property (nullable, nonatomic, weak) id<UIScrollViewDelegate> scrollViewDelegate;
@property (nullable, nonatomic, strong, readonly) id<UITableViewDelegate> delegate;
@property (nullable, nonatomic, strong, readonly) id<UITableViewDataSource> dataSource;

#pragma mark - data signal

@property (nullable, nonatomic, strong, readonly) RACSignal *reloadDataSignal;      // 请勿订阅此信号
@property (nullable, nonatomic, strong, readonly) RACSignal *insertSectionsSignal;  // 请勿订阅此信号
@property (nullable, nonatomic, strong, readonly) RACSignal *deleteSectionsSignal;  // 请勿订阅此信号
@property (nullable, nonatomic, strong, readonly) RACSignal *replaceSectionsSignal; // 请勿订阅此信号
@property (nullable, nonatomic, strong, readonly) RACSignal *reloadSectionsSignal;  // 请勿订阅此信号

@property (nullable, nonatomic, strong, readonly) RACSignal *insertRowsAtIndexPathsSignal;  // 请勿订阅此信号
@property (nullable, nonatomic, strong, readonly) RACSignal *deleteRowsAtIndexPathsSignal;  // 请勿订阅此信号
@property (nullable, nonatomic, strong, readonly) RACSignal *replaceRowsAtIndexPathsSignal; // 请勿订阅此信号
@property (nullable, nonatomic, strong, readonly) RACSignal *reloadRowsAtIndexPathsSignal;  // 请勿订阅此信号

@end

NS_ASSUME_NONNULL_END
