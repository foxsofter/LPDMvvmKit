//
//  LPDViewController.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDViewController.h"
#import "LPDViewControllerFactory.h"
#import "LPDViewModel.h"
#import "LPDViewModelProtocol.h"
#import "NSString+LPDAddition.h"
#import "UIScreen+LPDAccessor.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDViewController ()

@property (nonatomic, strong, readwrite) __kindof id<LPDViewModelProtocol> viewModel;

@property (nonatomic, strong) UIView *submittingOverlay;
@property (nonatomic, strong) UIActivityIndicatorView *submittingIndicator;

@end

@implementation LPDViewController

static void (^networkStateNormalBlock)();
+ (void)networkStateNormalBlock:(void (^)())block {
  networkStateNormalBlock = block;
}

static void (^networkStateDisableBlock)();
+ (void)networkStateDisableBlock:(void (^)())block {
  networkStateDisableBlock = block;
}

static void (^showSubmittingBlock)(NSString *_Nullable status);
+ (void)showSubmittingBlock:(void (^)(NSString *_Nullable status))block {
  showSubmittingBlock = block;
}

static void (^hideSubmittingBlock)();
+ (void)hideSubmittingBlock:(void (^)())block {
  hideSubmittingBlock = block;
}

static void (^showSuccessBlock)(NSString *_Nullable status);
+ (void)showSuccessBlock:(void (^)(NSString *_Nullable status))block {
  showSuccessBlock = block;
}

static void (^showErrorBlock)(NSString *_Nullable status);
+ (void)showErrorBlock:(void (^)(NSString *_Nullable status))block {
  showErrorBlock = block;
}

static UIView * (^initSubmittingBlock)();
+ (void)initSubmittingBlock:(UIView * (^)())block {
  initSubmittingBlock = block;
}

@synthesize navigation = _navigation;

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

    @weakify(self);
    [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
      @strongify(self);
      [(NSObject *)self.viewModel setValue:@YES forKey:@"viewDidLoad"];
    }];
    [[self rac_signalForSelector:@selector(viewDidLayoutSubviews)] subscribeNext:^(id x) {
      @strongify(self);
      [(NSObject *)self.viewModel setValue:@YES forKey:@"viewDidLayout"];
    }];

    RACChannelTo(self, title) = RACChannelTo(self.viewModel, title);
  }
  return self;
}

- (void)showSubmitting {
  if (!_submittingOverlay) {
    _submittingOverlay = [[UIView alloc] initWithFrame:UIScreen.bounds];
    _submittingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    UIView *contentView = nil;
    if (initSubmittingBlock) {
      contentView = initSubmittingBlock();
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


- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.automaticallyAdjustsScrollViewInsets = NO;

  [self subscribeActiveSignal];
  [self subscribeSubmittingSignal];
  [self subscribeSuccessSubject];
  [self subscribeErrorSubject];
  [self subscribeNetworkStateSignal];

  [self subscribeAddChildViewModelSignal];
  [self loadChildViewControllers];
  [self subscribeRemoveFromParentViewModelSignal];
}

#pragma mark - public methods

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (void)lpd_addChildViewController:(id<LPDViewControllerProtocol>)childViewController {
  childViewController.viewModel.navigation = self.viewModel.navigation;
  [self.viewModel performSelector:@selector(_addChildViewModel:) withObject:childViewController.viewModel];
  [super addChildViewController:(UIViewController *)childViewController];
}

- (void)lpd_removeFromParentViewController {
  self.viewModel.navigation = nil;
  [self.viewModel performSelector:@selector(_removeFromParentViewModel)];
  [super removeFromParentViewController];
}

#pragma clang diagnostic pop

#pragma mark - properties

- (nullable __kindof id<LPDNavigationControllerProtocol>)navigation {
  if (_navigation) {
    return _navigation;
  }
  if ([self.navigationController conformsToProtocol:@protocol(LPDNavigationControllerProtocol)]) {
    return (id<LPDNavigationControllerProtocol>)self.navigationController;
  }
  return nil;
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

- (void)subscribeSubmittingSignal {
  @weakify(self);
  [[RACObserve(self.viewModel, submitting) deliverOnMainThread] subscribeNext:^(NSNumber *submitting) {
    @strongify(self);
    if ([submitting boolValue]) {
      if (showSubmittingBlock) {
        showSubmittingBlock(nil);
      } else {
        [self showSubmitting];
      }
    } else {
      if (hideSubmittingBlock) {
        hideSubmittingBlock();
      } else {
        [self hideSubmitting];
      }
    }
  }];
}

- (void)subscribeSuccessSubject {
  [[[[self.viewModel.successSubject takeUntil:[self rac_willDeallocSignal]] deliverOnMainThread]
    map:^id(NSString *message) {
      return [message stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"。. "]];
    }] subscribeNext:^(NSString *status) {
    if (showSuccessBlock) {
      showSuccessBlock(status);
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
      if (showErrorBlock) {
        showErrorBlock(message);
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
      [self lpd_addChildViewController:childViewController];
    }];
}

- (void)subscribeRemoveFromParentViewModelSignal {
  @weakify(self);
  [[(NSObject *)self.viewModel rac_signalForSelector:@selector(removeFromParentViewModel)] subscribeNext:^(id x) {
    @strongify(self);
    [self lpd_removeFromParentViewController];
  }];
}

- (void)loadChildViewControllers {
  NSArray<id<LPDViewModelProtocol>> *childViewModels = self.viewModel.childViewModels;
  if (childViewModels && childViewModels.count > 0) {
    for (id<LPDViewModelProtocol> childViewModel in childViewModels) {
      id<LPDViewControllerProtocol> childViewController =
        (id<LPDViewControllerProtocol>)[LPDViewControllerFactory viewControllerForViewModel:childViewModel];
      [self lpd_addChildViewController:childViewController];
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

- (void)checkNetworkState {
  if (self.viewModel.networkState == LPDViewNetworkStateNormal) {
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
