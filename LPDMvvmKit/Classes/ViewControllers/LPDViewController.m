//
//  LPDViewController.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
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

@implementation UIViewController (LPDViewController)

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

@property (nonatomic, strong) UIView *loadingOverlay;
@property (nonatomic, strong) UIActivityIndicatorView *loadingIndicator;

@end

@implementation LPDViewController

#pragma mark - life cycle

- (instancetype)initWithViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  
  NSString *classBundlePath = [[NSBundle bundleForClass:self.class] pathForResource:NSStringFromClass(self.class) ofType:@"nib"];
  if (classBundlePath.length) {
	 self = [super initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle bundleForClass:self.class]];
  } else {
	 self = [super init];
  }
  
  if (self) {
	 self.viewModel = viewModel;
	 
	 [self subscribeActiveSignal];
	 [self subscribeDidLoadViewSignal];
	 [self subscribeDidUnloadViewSignal];
	 [self subscribeDidLayoutSubviewsSignal];
	 [self subscribeSubmittingSignal];
	 [self subscribeLoadingSignal];
   [self subscribeRetryLoadingSignal];
	 [self subscribeSuccessSubject];
	 [self subscribeErrorSubject];
	 [self subscribeEmptySignal];
	 [self subscribeNetworkStateSignal];
	 [self subscribeAddChildViewModelSignal];
	 [self subscribeRemoveFromParentViewModelSignal];
	 
	 RACChannelTo(self, title) = RACChannelTo(self.viewModel, title);
  }
  
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.edgesForExtendedLayout = UIRectEdgeNone;
  self.automaticallyAdjustsScrollViewInsets = NO;
  
  [self loadChildViewControllers];
}

- (void)viewDidLayoutSubviews {
    if (self->_emptyOverlay) {
        self->_emptyOverlay.center = CGPointMake(self.view.width / 2, self.view.height /2 - 50);
    }
    if (self->_retryOverlay) {
        self->_retryOverlay.center = CGPointMake(self.view.width / 2, self.view.height /2 - 50);
    }
}

#pragma mark - subscribe active signal

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

#pragma mark - subscribe didLoadView signal

- (void)subscribeDidLoadViewSignal {
  @weakify(self);
  [[self rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
	 @strongify(self);
	 self.viewModel.didLoadView = YES;
  }];
}

- (void)subscribeDidUnloadViewSignal {
  @weakify(self);
  [[self rac_signalForSelector:@selector(viewDidUnload)] subscribeNext:^(id x) {
	 @strongify(self);
	 self.viewModel.didLoadView = NO;
  }];
}
#pragma mark - subscribe didLayoutSubviews signal

- (void)subscribeDidLayoutSubviewsSignal {
  @weakify(self);
  [[self rac_signalForSelector:@selector(viewDidLayoutSubviews)] subscribeNext:^(id x) {
	 @strongify(self);
	 self.viewModel.didLayoutSubviews = YES;
  }];
}

#pragma mark - subscribe submitting signal

- (void)subscribeSubmittingSignal {
  @weakify(self);
  [[[RACObserve(self.viewModel, submitting) skip:1] deliverOnMainThread] subscribeNext:^(NSNumber *submitting) {
	 @strongify(self);
	 if ([submitting boolValue]) {
		[self showSubmitting];
	 } else {
		[self hideSubmitting];
	 }
  }];
}

- (void)showSubmitting {
  if (!_submittingOverlay) {
	 _submittingOverlay = [[UIView alloc] initWithFrame:UIScreen.bounds];
	 _submittingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	 UIView *contentView = nil;
	 if ([self respondsToSelector:@selector(customSubmittingView)]) {
		contentView = [self customSubmittingView];
	 } else {
		contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		contentView.layer.cornerRadius = 10;
		contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
		
		UIActivityIndicatorView *indicatorView =
		[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
		indicatorView.tintColor = [UIColor whiteColor];
		[contentView addSubview:indicatorView];
		indicatorView.center = CGPointMake(50, 50);
		// 添加自启动的动画
		@weakify(indicatorView);
		[[RACSignal merge:@[
								  [indicatorView rac_signalForSelector:@selector(didMoveToWindow)],
								  [indicatorView rac_signalForSelector:@selector(didMoveToSuperview)]
								  ]] subscribeNext:^(id x) {
		  @strongify(indicatorView);
		  [indicatorView startAnimating];
		}];
	 }
	 [_submittingOverlay addSubview:contentView];
	 contentView.center = _submittingOverlay.center;
  }
  if (!_submittingOverlay.superview) {
	 [[UIApplication sharedApplication].delegate.window addSubview:_submittingOverlay];
  }
}

- (void)hideSubmitting {
  if (!_submittingOverlay || !_submittingOverlay.superview) {
	 return;
  }
  [_submittingOverlay removeFromSuperview];
}

#pragma mark - subscribe loading signal

- (void)subscribeLoadingSignal {
  @weakify(self);
  [[RACObserve(self.viewModel, loading) skip:1] subscribeNext:^(id x) {
	 @strongify(self);
	 if ([x boolValue]) {
		[self showLoading];
	 } else {
		[self hideLoading];
	 }
  }];
}

- (void)showLoading {
  if (!_loadingOverlay) {
	 _loadingOverlay = [[UIView alloc] initWithFrame:self.view.bounds];
	 _loadingOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
	 UIView *contentView = nil;
	 if ([self respondsToSelector:@selector(customLoadingView)]) {
		contentView = [self customLoadingView];
	 } else {
		contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
		contentView.layer.cornerRadius = 10;
		contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
		
		UIActivityIndicatorView *loadingView =
		[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
		loadingView.tintColor = [UIColor whiteColor];
		[contentView addSubview:loadingView];
		loadingView.center = CGPointMake(50, 50);
		// 添加自启动的动画
		@weakify(loadingView);//didMoveToWindow和didMoveToWindow这两个方法从哪儿监听
		[[[RACSignal merge:@[[_loadingOverlay rac_signalForSelector:@selector(didMoveToWindow)],
									[_loadingOverlay rac_signalForSelector:@selector(didMoveToWindow)]]]
		  takeUntil:[_loadingOverlay rac_willDeallocSignal]] subscribeNext:^(id x) {
		  @strongify(loadingView);
		  [loadingView startAnimating];
		}];
	 }
	 [_loadingOverlay addSubview:contentView];
	 contentView.center = _loadingOverlay.center;
  }
  if (!_loadingOverlay.superview) {
	 [self.view addSubview:_loadingOverlay];
  }
}

- (void)hideLoading {
  if (!_loadingOverlay || !_loadingOverlay.superview) {
	 return;
  }
  [_loadingOverlay removeFromSuperview];
}

#pragma mark - subscribe retry signal

- (void)subscribeRetryLoadingSignal {
  @weakify(self);
  [[[RACObserve(self.viewModel, needRetryLoading) skip:1] deliverOnMainThread] subscribeNext:^(NSNumber *needRetryLoading) {
    @strongify(self);
    if ([needRetryLoading boolValue]) {
        if ([self respondsToSelector:@selector(showRetryView)]) {
            [self showRetryView];
        }
    } else {
        if ([self respondsToSelector:@selector(hideRetryView)]) {
            [self hideRetryView];
        }
    }
  }];
}

#pragma mark - subscribe toast signal

- (void)subscribeSuccessSubject {
  @weakify(self);
  [[[[self.viewModel.successSubject takeUntil:[self rac_willDeallocSignal]] deliverOnMainThread]
	 map:^id(NSString *message) {
		return [message stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"。. "]];
	 }] subscribeNext:^(NSString *status) {
		@strongify(self);
		if ([self respondsToSelector:@selector(showSuccess:)]) {
		  [self showSuccess:status];
		}
  }];
}

- (void)subscribeErrorSubject {
  @weakify(self);
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
	 @strongify(self);
	 if (message && message.length > 0) {
		NSLog(@"subscribeErrorSubject post:%@", message);
		if ([self respondsToSelector:@selector(showError:)]) {
		  [self showError:message];
		}
	 }
  }];
}


#pragma mark - subscribe network state signal

- (void)subscribeNetworkStateSignal {
  @weakify(self);
  [[[RACObserve(self.viewModel, networkState) skip:1] deliverOnMainThread] subscribeNext:^(NSNumber *value) {
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
  if (self.viewModel.networkState == LPDNetworkStateNormal) {
	 if ([self respondsToSelector:@selector(showNetworkNormal)]) {
		[self showNetworkNormal];
	 }
  } else {
	 if ([self respondsToSelector:@selector(showNetworkDisable)]) {
		[self showNetworkDisable];
	 }
  }
}

#pragma mark - subscribe view empty signal

- (void)subscribeEmptySignal {
  @weakify(self);
  [[[RACObserve(self.viewModel, empty) skip:1] deliverOnMainThread] subscribeNext:^(NSNumber *value) {
	 @strongify(self);
	 BOOL empty = [value integerValue];
    [self showEmpty:empty withImage:nil title:nil subTitle:nil];
  }];
  [[[self.viewModel rac_signalForSelector:@selector(setEmptyImage:title:subTitle:)
									  fromProtocol:@protocol(LPDViewModelEmptyProtocol)] deliverOnMainThread]
	subscribeNext:^(RACTuple *tuple) {
	  @strongify(self);
    [self showEmpty:YES withImage:tuple.first title:tuple.second subTitle:tuple.third];
	}];
}

- (void)showEmpty:(BOOL)empty withImage:(UIImage *_Nullable)image title:(NSString *_Nullable)title subTitle:(NSString *_Nullable)subTitle {
  UIView *rootView = self.view;
  if ([self conformsToProtocol:NSProtocolFromString(@"LPDScrollViewControllerProtocol")]) {
	 rootView = [self valueForKey:@"scrollView"];
  }
  if (empty) {
	 if ([self respondsToSelector:@selector(showEmptyViewWithImage:title:subTitle:)]) {
     [self showEmptyViewWithImage:image title:title subTitle:subTitle];
	 }
  } else {
	 if ([self respondsToSelector:@selector(hideEmptyView)]) {
		[self hideEmptyView];
	 }
  }
}

#pragma mark - subscribe child ViewModel signal


- (void)subscribeAddChildViewModelSignal {
    @weakify(self);
    [[(NSObject *)self.viewModel rac_signalForSelector:@selector(addChildViewModel:)]
     subscribeNext:^(id childViewModel) {
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
		[LPDViewControllerFactory viewControllerForViewModel:childViewModel];
		[self addChildViewController:childViewController];
	 }
  }
}

@end

NS_ASSUME_NONNULL_END
