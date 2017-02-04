//
//  LPDViewController.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <objc/runtime.h>
#import <LPDAdditionsKit/LPDAdditionsKit.h>
#import "LPDViewController.h"
#import "LPDViewControllerFactory.h"
#import "LPDViewModel.h"
#import "LPDViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController ()

@property (nullable, nonatomic, strong, readwrite) __kindof id<LPDViewModelProtocol> viewModel;

@end

@implementation UIViewController (LPDMvvm)

- (nullable __kindof id<LPDViewModelProtocol>)viewModel {
  return [self object:@selector(setViewModel:)];
}

- (void)setViewModel:(nullable __kindof id<LPDViewModelProtocol>)viewModel {
  [self setRetainNonatomicObject:viewModel withKey:@selector(setViewModel:)];
}

@end

@interface LPDViewController ()

@property (nonatomic, strong) UIView *submittingOverlay;
@property (nonatomic, strong) UIActivityIndicatorView *submittingIndicator;

@end

@implementation LPDViewController

#pragma mark - life cycle

- (void)loadView {
  NSString *xibPath = [[NSBundle mainBundle] pathForResource:NSStringFromClass(self.class) ofType:@"nib"];
  if (xibPath && xibPath.length > 0) {
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];
    if (views && views.count > 0) {
      self.view = views.lastObject;
      self.view.frame = UIScreen.bounds;
    } else {
      xibPath = nil;
    }
  }
  if (!xibPath) {
    [super loadView];
    self.view.backgroundColor = [UIColor whiteColor];
  }
}

- (instancetype)initWithViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    self.viewModel = viewModel;

    [self subscribeActiveSignal];
    [self subscribeDidLoadViewSignal];
    [self subscribeDidLayoutSubviewsSignal];
    [self subscribeSubmittingSignal];
    [self subscribeSuccessSubject];
    [self subscribeErrorSubject];
    [self subscribeNetworkStateSignal];
    [self subscribeDisplayingSignal];

    RACChannelTo(self, title) = RACChannelTo(self.viewModel, title);
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.automaticallyAdjustsScrollViewInsets = NO;

  [self loadChildViewControllers];
  [self subscribeAddChildViewModelSignal];
  [self subscribeRemoveFromParentViewModelSignal];
}

#pragma mark - private methods

- (void)subscribeActiveSignal {
  @weakify(self);
  [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
    @strongify(self);
    self.viewModel.active = YES;
  }];

  [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(id x) {
    @strongify(self);
    self.viewModel.active = NO;
  }];
}

- (void)subscribeDidLoadViewSignal {
  @weakify(self);
  [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
    @strongify(self);
    self.viewModel.didLoadView = YES;
  }];
}

- (void)subscribeDidLayoutSubviewsSignal {
  @weakify(self);
  [[self rac_signalForSelector:@selector(viewDidLayoutSubviews)] subscribeNext:^(id x) {
    @strongify(self);
    self.viewModel.didLayoutSubviews = YES;
  }];
}

- (void)subscribeSubmittingSignal {
  @weakify(self);
  [[RACObserve(self.viewModel, submitting) deliverOnMainThread] subscribeNext:^(NSNumber *submitting) {
    @strongify(self);
    if ([submitting boolValue]) {
      [self showSubmitting];
    } else {
      [self hideSubmitting];
    }
  }];
}

- (void)subscribeSuccessSubject {
  [[[[self.viewModel.successSubject takeUntil:[self rac_willDeallocSignal]] deliverOnMainThread]
    map:^id(NSString *message) {
      return [message stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"。. "]];
    }] subscribeNext:^(NSString *status) {
    if (class_respondsToSelector(self.class, @selector(showSuccess:))) {
      [self.class showSuccess:status];
    }
  }];
}

- (void)subscribeErrorSubject {
  [[[[[self.viewModel.errorSubject takeUntil:[self rac_willDeallocSignal]]
    deliverOnMainThread] map:^id(NSString *message) {
    NSLog(@"subscribeErrorSubject pre:%@", message);
    
    if ([message containsString:@"未能读取数据"]) {
      message = @"程序员GG正在抢修...";
    }

    return [[[message stringByReplacingOccurrencesOfString:@"Request failed: internal server error"
                                                withString:@"系统异常"] stringByRemovingWithPattern:@"\\([^)]*\\)"]
      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"。. "]];
  }] map:^id(NSString *message) {
    if ([message containsString:@"has no available provider"]) {
      return @"系统异常";
    }
    return message;
  }] subscribeNext:^(NSString *message) {
    if (message && message.length > 0) {
      NSLog(@"subscribeErrorSubject post:%@", message);
      if (class_respondsToSelector(self.class, @selector(showError:))) {
        [self.class showError:message];
      }
    }
  }];
}

- (void)subscribeAddChildViewModelSignal {
  @weakify(self);
  [[(NSObject *)self.viewModel rac_signalForSelector:@selector(addChildViewModel:)]
    subscribeNext:^(id<LPDViewModelProtocol> childViewModel) {
      @strongify(self);
      id<LPDViewControllerProtocol> childViewController =
        (id<LPDViewControllerProtocol>)[LPDViewControllerFactory viewControllerForViewModel:childViewModel];
      [self addChildViewController:childViewController];
    }];
}

- (void)subscribeRemoveFromParentViewModelSignal {
  @weakify(self);
  [[(NSObject *)self.viewModel rac_signalForSelector:@selector(removeFromParentViewModel)] subscribeNext:^(id x) {
    @strongify(self);
    [self removeFromParentViewController];
  }];
}

- (void)loadChildViewControllers {
  NSArray<id<LPDViewModelProtocol>> *childViewModels = self.viewModel.childViewModels;
  if (childViewModels && childViewModels.count > 0) {
    for (id<LPDViewModelProtocol> childViewModel in childViewModels) {
      id<LPDViewControllerProtocol> childViewController =
        (id<LPDViewControllerProtocol>)[LPDViewControllerFactory viewControllerForViewModel:childViewModel];
      [self addChildViewController:childViewController];
    }
  }
}

- (void)subscribeNetworkStateSignal {
  @weakify(self);
  [[RACObserve(self.viewModel, networkState) deliverOnMainThread] subscribeNext:^(NSNumber *value) {
    @strongify(self);
    [self checkNetworkState];
  }];

  [self.viewModel.didBecomeActiveSignal subscribeNext:^(id x) {
    @strongify(self);
    [self checkNetworkState];
  }];

  [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIApplicationDidBecomeActiveNotification object:nil]
    subscribeNext:^(id x) {
      @strongify(self);
      if (self.viewModel.isActive) {
        [self checkNetworkState];
      }
    }];
}

- (void)subscribeDisplayingSignal {
  @weakify(self);
  [[RACObserve(((id<LPDViewModelDisplayingProtocol>)self.viewModel), viewDisplayingState) deliverOnMainThread] subscribeNext:^(NSNumber *value) {
    @strongify(self);
    LPDViewDisplayingState viewDisplayingState = [value integerValue];
    [self displayDisplayingState:viewDisplayingState withMessage:nil];
  }];
  [[[(NSObject *)self.viewModel rac_signalForSelector:@selector(setViewDisplayingState:withMessage:)
                                         fromProtocol:@protocol(LPDViewModelReactProtocol)] deliverOnMainThread]
   subscribeNext:^(RACTuple *tuple) {
     @strongify(self);
     LPDViewDisplayingState viewDisplayingState = [tuple.first integerValue];
     NSString *message = tuple.second;
     [self displayDisplayingState:viewDisplayingState withMessage:message];
   }];
}

#pragma mark - private methods

- (void)showSubmitting {
  if (!_submittingOverlay) {
    _submittingOverlay = [[UIView alloc] initWithFrame:UIScreen.bounds];
    _submittingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    UIView *contentView = nil;
    if (class_respondsToSelector(self.class, @selector(initSubmittingView))) {
      contentView = [self.class initSubmittingView];
    } else {
      contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
      contentView.layer.cornerRadius = 10;
      contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
      
      UIActivityIndicatorView *submittingView =
      [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
      submittingView.tintColor = [UIColor whiteColor];
      [contentView addSubview:submittingView];
      submittingView.center = CGPointMake(50, 50);
      // 添加自启动的动画
      @weakify(submittingView);
      [[RACSignal merge:@[
                          [submittingView rac_signalForSelector:@selector(didMoveToWindow)],
                          [submittingView rac_signalForSelector:@selector(didMoveToSuperview)]
                          ]] subscribeNext:^(id x) {
        @strongify(submittingView);
        [submittingView startAnimating];
      }];
    }
    [_submittingOverlay addSubview:contentView];
    contentView.center = _submittingOverlay.center;
  }
  if (!_submittingOverlay.superview) {
    [[UIApplication sharedApplication].keyWindow addSubview:_submittingOverlay];
  }
}

- (void)hideSubmitting {
  if (!_submittingOverlay || !_submittingOverlay.superview) {
    return;
  }
  [_submittingOverlay removeFromSuperview];
}

- (void)displayDisplayingState:(LPDViewDisplayingState)viewDisplayingState withMessage:(nullable NSString *)message {
  switch (viewDisplayingState) {
    case LPDViewDisplayingStateNormal: {
      if (class_respondsToSelector(self.class, @selector(displayNormalView:))) {
        [self.class displayNormalView:self.scrollView];
      }
    } break;
    case LPDViewDisplayingStateNoData: {
      if (class_respondsToSelector(self.class, @selector(displayNoDataView:withDescription:))) {
        [self.class displayNoDataView:self.scrollView withDescription:message];
      }
    } break;
    case LPDViewDisplayingStateRetry: {
      if (class_respondsToSelector(self.class, @selector(displayRetryView:withDescription:))) {
        [self.class displayRetryView:self.scrollView withDescription:message];
      }
    } break;
  }
}

- (void)checkNetworkState {
  if (self.viewModel.networkState == LPDNetworkStateNormal) {
    if (networkStateNormalBlock) {
      networkStateNormalBlock();
    }
  } else {
    if (networkStateDisableBlock) {
      networkStateDisableBlock();
    }
  }
}

@end

NS_ASSUME_NONNULL_END
