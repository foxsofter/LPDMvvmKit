//
//  LPDScrollViewController.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "LPDScrollViewController.h"
#import "LPDScrollViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPDScrollViewController ()

@property (nullable, nonatomic, weak) MJRefreshHeader *loadingProgress;

@property (nullable, nonatomic, weak) MJRefreshFooter *loadingMoreProgress;

@end

@implementation LPDScrollViewController

@synthesize needLoading = _needLoading;
@synthesize needLoadingMore = _needLoadingMore;
@synthesize scrollView = _scrollView;

#pragma mark - react state block

static void (^reactStateNormalBlock)(UIScrollView *scrollView);
+ (void)reactStateNormalBlock:(void (^)(UIScrollView *scrollView))block {
  reactStateNormalBlock = block;
}

static void (^reactStateNoDataBlock)(UIScrollView *scrollView, NSString *);
+ (void)reactStateNoDataBlock:(void (^)(UIScrollView *scrollView, NSString *_Nullable))block {
  reactStateNoDataBlock = block;
}

static void (^reactStateNetworkLatencyBlock)(UIScrollView *scrollView, NSString *);
+ (void)reactStateNetworkLatencyBlock:(void (^)(UIScrollView *scrollView, NSString *_Nullable))block {
  reactStateNetworkLatencyBlock = block;
}

static void (^beginLodingBlock)(UIView *view);
+ (void)beginLodingBlock:(void (^)(UIView *view))block {
  beginLodingBlock = block;
}

static void (^endLodingBlock)(UIView *view);
+ (void)endLodingBlock:(void (^)(UIView *view))block {
  endLodingBlock = block;
}

static MJRefreshHeader * (^initHeaderBlock)(MJRefreshComponentRefreshingBlock refreshingBlock);
+ (void)initHeaderBlock:(MJRefreshHeader * (^)(MJRefreshComponentRefreshingBlock refreshingBlock))block {
  initHeaderBlock = block;
}

static MJRefreshFooter * (^initFooterBlock)(MJRefreshComponentRefreshingBlock refreshingBlock);
+ (void)initFooterBlock:(MJRefreshFooter * (^)(MJRefreshComponentRefreshingBlock refreshingBlock))block {
  initFooterBlock = block;
}

#pragma mark - life cycle

- (instancetype)initWithViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    NSParameterAssert([viewModel conformsToProtocol:@protocol(LPDScrollViewModelProtocol)]);

    [self subscribeLoadingSignal];
    [self subscribeLoadingMoreSignal];
    [self subscribeReactStateSignal];
  }
  return self;
}

#pragma mark - private methods

- (void)subscribeLoadingSignal {
  @weakify(self);
  [[RACObserve(self, needLoading) filter:^BOOL(id value) {
    @strongify(self);
    return self.scrollView != nil;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if ([x boolValue]) {
      if (nil == self.loadingProgress) {
        MJRefreshComponentRefreshingBlock refreshingBlock = ^{
          @strongify(self);
          if (!self.scrollView.mj_footer && self.loadingMoreProgress) {
            self.scrollView.mj_footer = self.loadingMoreProgress;
          }
          ((LPDScrollViewModel *)self.viewModel).loading = YES;
        };
        if (initHeaderBlock) {
          self.loadingProgress = initHeaderBlock(refreshingBlock);
        } else {
          self.loadingProgress = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
        }
        self.scrollView.mj_header = self.loadingProgress;
      }
    } else {
      self.scrollView.mj_header = nil;
      self.loadingProgress = nil;
    }
  }];
  [[[RACObserve(((id<LPDScrollViewModelProtocol>)self.viewModel), loading) skip:1] filter:^BOOL(id value) {
    @strongify(self);
    return nil != self.scrollView;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if (self.needLoading) {
      if ([x boolValue]) {
        if (!self.loadingProgress.isRefreshing) {
          if (beginLodingBlock) {
            beginLodingBlock(self.view);
          }
        }
        self.viewModel.reactState = LPDViewReactStateNormal;
      } else {
        if (self.loadingProgress.isRefreshing) {
          [self.loadingProgress endRefreshing];
        } else {
          if (endLodingBlock) {
            endLodingBlock(self.view);
          }
        }
      }
    } else {
      if ([x boolValue]) {
        if (beginLodingBlock) {
          beginLodingBlock(self.view);
        }
      } else {
        if (endLodingBlock) {
          endLodingBlock(self.view);
        }
      }
    }
  }];
}

- (void)subscribeLoadingMoreSignal {
  @weakify(self);
  [[RACObserve(self, needLoadingMore) filter:^BOOL(id value) {
    @strongify(self);
    return self.scrollView != nil;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if ([x boolValue]) {
      if (nil == self.loadingMoreProgress) {
        MJRefreshComponentRefreshingBlock refreshingBlock = ^{
          @strongify(self);
          ((LPDScrollViewModel *)self.viewModel).loadingMore = YES;
        };
        if (initFooterBlock) {
          self.loadingMoreProgress = initFooterBlock(refreshingBlock);
        } else {
          self.loadingMoreProgress = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
        }
        self.scrollView.mj_footer = self.loadingMoreProgress;
      }
    } else {
      self.scrollView.mj_footer = nil;
      self.loadingMoreProgress = nil;
    }
  }];
  [[RACObserve(((id<LPDScrollViewModelProtocol>)self.viewModel), loadingMore) filter:^BOOL(id value) {
    @strongify(self);
    return value && self.scrollView && self.needLoadingMore;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if ([x boolValue]) {
      [self.loadingMoreProgress beginRefreshing];
    } else {
      [self.loadingMoreProgress endRefreshing];
    }
  }];

  [[RACObserve(((id<LPDScrollViewModelProtocol>)self.viewModel), loadingMoreSignal) skip:1] subscribeNext:^(id x) {
    @strongify(self);
    if (!x) {
      self.scrollView.mj_footer = nil;
    } else {
      [self.loadingMoreProgress resetNoMoreData];
    }
  }];
}

- (void)subscribeReactStateSignal {
  @weakify(self);
  [[RACObserve(self.viewModel, reactState) deliverOnMainThread] subscribeNext:^(NSNumber *value) {
    @strongify(self);
    LPDViewReactState reactState = [value integerValue];
    [self showReactState:reactState withMessage:nil];
  }];
  [[[(NSObject *)self.viewModel rac_signalForSelector:@selector(setReactState:withMessage:)
                                         fromProtocol:@protocol(LPDViewModelReactProtocol)] deliverOnMainThread]
    subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      LPDViewReactState reactState = [tuple.first integerValue];
      NSString *message = tuple.second;
      [self showReactState:reactState withMessage:message];
    }];
}

- (void)showReactState:(LPDViewReactState)reactState withMessage:(nullable NSString *)message {
  switch (reactState) {
    case LPDViewReactStateNormal: {
      if (reactStateNormalBlock) {
        reactStateNormalBlock(self.scrollView);
      }
    } break;
    case LPDViewReactStateNoData: {
      if (reactStateNoDataBlock) {
        reactStateNoDataBlock(self.scrollView, message);
      }
    } break;
    case LPDViewReactStateNetworkLatency: {
      if (reactStateNetworkLatencyBlock) {
        reactStateNetworkLatencyBlock(self.scrollView, message);
      }
    } break;
  }
}

@end

NS_ASSUME_NONNULL_END
