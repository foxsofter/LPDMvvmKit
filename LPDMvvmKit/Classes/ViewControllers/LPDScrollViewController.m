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

@property (nullable, nonatomic, weak) MJRefreshHeader *loadingHeader;
@property (nullable, nonatomic, weak) MJRefreshFooter *loadingFooter;

@end

@implementation LPDScrollViewController

@synthesize needLoadingHeader = _needLoadingHeader;
@synthesize needLoadingFooter = _needLoadingFooter;
@synthesize scrollView = _scrollView;

#pragma mark - life cycle

- (instancetype)initWithViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    NSParameterAssert([viewModel conformsToProtocol:@protocol(LPDScrollViewModelProtocol)]);

    [self subscribeNeedLoadingHeaderSignal];
    [self subscribeLoadingSignal];
    [self subscribeNeedLoadingFooterSignal];
    [self subscribeLoadingMoreSignal];
  }
  return self;
}

#pragma mark - private methods

- (void)subscribeNeedLoadingHeaderSignal {
  @weakify(self);
  [[RACObserve(self, needLoadingHeader) filter:^BOOL(id value) {
    @strongify(self);
    return self.scrollView != nil;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if ([x boolValue]) {
      if (nil == self.loadingHeader) {
        MJRefreshComponentRefreshingBlock refreshingBlock = ^{
          @strongify(self);
          self.viewModel.loading = YES;
        };
        if ([self respondsToSelector:@selector(customLoadingHeader:)]) {
          self.loadingHeader = [self customLoadingHeader:refreshingBlock];
        } else {
          self.loadingHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:refreshingBlock];
        }
        self.scrollView.mj_header = self.loadingHeader;
      }
    } else {
      self.scrollView.mj_header = nil;
      self.loadingHeader = nil;
    }
  }];
}

- (void)subscribeLoadingSignal {
  @weakify(self);
  [[[RACObserve(self.viewModel, loading) skip:1] filter:^BOOL(id value) {
    @strongify(self);
    return nil != self.scrollView;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if (self.needLoadingHeader) {
      if ([x boolValue]) {
        [self.viewModel setEmpty:NO];
        if (!self.loadingHeader.isRefreshing) { // 非下拉刷新触发
          [self performSelector:@selector(showLoading)];
        }
      } else {
        if (self.loadingHeader.isRefreshing) {
          [self.loadingHeader endRefreshing];
        } else {
          [self performSelector:@selector(hideLoading)];
        }
      }
    } else {
      if ([x boolValue]) {
        [self.viewModel setEmpty:NO];
        [self performSelector:@selector(showLoading)];
      } else {
        [self performSelector:@selector(hideLoading)];
      }
    }
  }];
}

- (void)subscribeNeedLoadingFooterSignal {
  @weakify(self);
  [[RACObserve(self, needLoadingFooter) filter:^BOOL(id value) {
    @strongify(self);
    return self.scrollView != nil;
  }] subscribeNext:^(id x) {
    @strongify(self);
    if ([x boolValue]) {
      if (nil == self.loadingFooter) {
        MJRefreshComponentRefreshingBlock refreshingBlock = ^{
          @strongify(self);
          [self.viewModel setLoadingMoreState:LPDLoadingMoreStateBegin];
        };
        if ([self respondsToSelector:@selector(customLoadingFooter:)]) {
          self.loadingFooter = [self customLoadingFooter:refreshingBlock];
        } else {
          self.loadingFooter = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:refreshingBlock];
        }
        self.scrollView.mj_footer = self.loadingFooter;
      }
    } else {
      self.scrollView.mj_footer = nil;
      self.loadingFooter = nil;
    }
  }];
}

- (void)subscribeLoadingMoreSignal {
  @weakify(self);
  [[RACObserve(((id<LPDViewModelLoadingMoreProtocol>)self.viewModel), loadingMoreState) filter:^BOOL(id value) {
    @strongify(self);
    return nil != self.scrollView;
  }] subscribeNext:^(NSNumber *value) {
    @strongify(self);
    LPDLoadingMoreState loadingMoreState = [value integerValue];
    if (loadingMoreState == LPDLoadingMoreStateBegin) {
      [self.loadingFooter beginRefreshing];
    } else if (loadingMoreState == LPDLoadingMoreStateEnd){
      [self.loadingFooter endRefreshing];
    } else {
      [self.loadingFooter  noticeNoMoreData];
    }
  }];
}


@end

NS_ASSUME_NONNULL_END
