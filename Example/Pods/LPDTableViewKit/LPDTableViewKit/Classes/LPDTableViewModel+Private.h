//
//  LPDTableViewModel+Private.h
//  Pods
//
//  Created by foxsofter on 16/12/3.
//
//

#import "LPDTableViewModel.h"

@interface LPDTableViewModel ()

@property (nonatomic, strong, readonly) id<UITableViewDelegate> delegate;
@property (nonatomic, strong, readonly) id<UITableViewDataSource> dataSource;

#pragma mark - data signal

@property (nonatomic, strong, readonly) RACSignal *reloadDataSignal;      // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *insertSectionsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *deleteSectionsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *replaceSectionsSignal; // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *reloadSectionsSignal;  // 请勿订阅此信号

@property (nonatomic, strong, readonly) RACSignal *insertRowsAtIndexPathsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *deleteRowsAtIndexPathsSignal;  // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *replaceRowsAtIndexPathsSignal; // 请勿订阅此信号
@property (nonatomic, strong, readonly) RACSignal *reloadRowsAtIndexPathsSignal;  // 请勿订阅此信号

@end
