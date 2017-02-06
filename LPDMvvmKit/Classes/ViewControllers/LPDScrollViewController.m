//
//  LPDScrollViewController.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/13.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>
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

#pragma mark - life cycle

- (instancetype)initWithViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    NSParameterAssert([viewModel conformsToProtocol:@protocol(LPDScrollViewModelProtocol)]);

    [self subscribeNeedLoadingSignal];
    [self subscribeLoadingSignal];
    [self subscribeNeedLoadingMoreSignal];
    [self subscribeLoadingMoreSignal];
  }
  return self;
}

#pragma mark - private methods

- (void)subscribeNeedLoadingSignal {
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
          [self.viewModel setLoading:YES];
        };
        if (class_respondsToSelector(self.class, @selector(initLoadingHeader:))) {
          self.loadingProgress = [self.class initLoadingHeader:refreshingBlock];
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
}

- (void)subscribeLoadingSignal {
  @weakify(self);
  [[[RACObserve(((id<LPDScrollViewModelProtocol>)self.viewModel), loading) skip:1] filter:^BOOL(id value) {
    @strongify(self);
    return nil != self.scrollView;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if (self.needLoading) {
      if ([x boolValue]) {
        if (!self.loadingProgress.isRefreshing) { // 非下拉刷新触发
          [self showLoading];
        }
        [self.viewModel setViewDisplayingState:LPDViewDisplayingStateNormal];
      } else {
        if (self.loadingProgress.isRefreshing) {
          [self.loadingProgress endRefreshing];
        } else {
          [self hide];
        }
      }
    } else {
      if ([x boolValue]) {
        [self showLoading];
      } else {
        [self hideSubmitting];
      }
    }
  }];
}

- (void)subscribeNeedLoadingMoreSignal {
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
          [self.viewModel setLoadingMoreState:LPDLoadingMoreStateBegin];
        };
        if (class_respondsToSelector(self.class, @selector(initLoadingFooter:))) {
          self.loadingMoreProgress = [self.class initLoadingFooter:refreshingBlock];
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
}

- (void)subscribeLoadingMoreSignal {
  @weakify(self);
  [[RACObserve(((id<LPDScrollViewModelProtocol>)self.viewModel), loadingMoreState) filter:^BOOL(id value) {
    @strongify(self);
    return value && self.scrollView && self.needLoadingMore;
  }] subscribeNext:^(NSNumber *value) {
    @strongify(self);
    LPDLoadingMoreState loadingMoreState = [value integerValue];
    if (loadingMoreState == LPDLoadingMoreStateBegin) {
      [self.loadingMoreProgress beginRefreshing];
    } else if (loadingMoreState == LPDLoadingMoreStateEnd){
      [self.loadingMoreProgress endRefreshing];
    } else {
      [self.loadingMoreProgress  noticeNoMoreData];
    }
  }];
}


@end

NS_ASSUME_NONNULL_END
