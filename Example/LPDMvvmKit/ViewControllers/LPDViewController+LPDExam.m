//
//  LPDViewController+LPDExam.m
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/6.
//  Copyright © 2017年 foxsofter. All rights reserved.
//

#import "LPDViewController+LPDExam.h"
#import <LPDAdditionsKit/LPDAdditionsKit.h>
#import <LPDControlsKit/LPDAlertView.h>
#import <LPDControlsKit/LPDToastView.h>

@implementation LPDViewController (LPDExam)

#pragma mark - LPDViewEmptyProtocol

- (void)hideEmptyView {
  UIView *prevView = [self.view viewWithTag:888888];
  if (prevView) {
    [prevView removeFromSuperview];
  }
}

- (void)showEmptyViewWithDescriptionWithDescription:(NSString *_Nullable)description {
  if (self.view.width < 1 || self.view.height < 1) {
    return;
  }
  UIView *prevView = [self.view viewWithTag:888888];
  if (prevView) {
    return;
  }
  UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 170)];
  emptyView.tag = 888888;
  emptyView.backgroundColor = [UIColor clearColor];
  UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"缺省页－空状态"]];
  [emptyView addSubview:iconView];
  iconView.frame = CGRectMake(0, 0, 150, 150);
  if (description && description.length > 0) {
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = description;
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [emptyView addSubview:messageLabel];
    messageLabel.frame = CGRectMake(0, 150, 150, 20);
  }
  [self.view insertSubview:emptyView atIndex:0];
  emptyView.center = CGPointMake(self.view.width / 2, self.view.height /2);
}

#pragma mark - LPDViewLoadingProtocol

- (UIView *)customLoadingView {
  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  contentView.layer.cornerRadius = 10;
  contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
  
  UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 42)];
  indicatorImageView.animationImages = @[
                                         [UIImage imageNamed:@"01"],
                                         [UIImage imageNamed:@"02"],
                                         [UIImage imageNamed:@"03"],
                                         [UIImage imageNamed:@"04"],
                                         [UIImage imageNamed:@"05"],
                                         [UIImage imageNamed:@"06"]
                                         ];
  indicatorImageView.animationDuration = 0.5;
  indicatorImageView.animationRepeatCount = INFINITY;
  [contentView addSubview:indicatorImageView];
  indicatorImageView.center = CGPointMake(50, 50);
  // 添加自启动的动画
  @weakify(indicatorImageView);
  [[RACSignal merge:@[
                      [contentView rac_signalForSelector:@selector(didMoveToWindow)],
                      [contentView rac_signalForSelector:@selector(didMoveToSuperview)]
                      ]] subscribeNext:^(id x) {
    @strongify(indicatorImageView);
    [indicatorImageView startAnimating];
  }];
  return contentView;
}

- (void)hideRetryView {
  UIView *prevView = [self.view viewWithTag:999999];
  if (prevView) {
    [prevView removeFromSuperview];
  }
}

- (void)showRetryView {
  if (self.view.width < 1 || self.view.height < 1) {
    return;
  }
  [self hideEmptyView];
  UIView *prevView = [self.view viewWithTag:999999];
  if (prevView) {
    return;
  }
  
  UIView *retryView = [[UIView alloc] initWithFrame:CGRectMake(UIScreen.width - 15, 0, UIScreen.width - 30, 220)];
  retryView.tag = 999999;
  retryView.backgroundColor = [UIColor clearColor];
  UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"缺省页－网络异常"]];
  [retryView addSubview:iconView];
  iconView.frame = CGRectMake((UIScreen.width - 180) / 2, 0, 150, 150);
  UILabel *messageLabel = [[UILabel alloc] init];
  messageLabel.text = @"当前网络环境较差";
  messageLabel.textColor = [UIColor lightGrayColor];
  messageLabel.font = [UIFont systemFontOfSize:16];
  messageLabel.textAlignment = NSTextAlignmentCenter;
  [retryView addSubview:messageLabel];
  messageLabel.frame = CGRectMake(0, 150, UIScreen.width - 30, 20);
  UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [retryButton setTitle:@"重试一下" forState:UIControlStateNormal];
  [retryButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
  retryButton.layer.cornerRadius = 4;
  retryButton.layer.borderWidth = 1;
  retryButton.layer.borderColor = [UIColor blueColor].CGColor;
  retryButton.frame = CGRectMake((UIScreen.width - 200) / 2, 176, 170, 44);
  [retryView addSubview:retryButton];
  [self.view insertSubview:retryView atIndex:0];
  retryView.center = CGPointMake(self.view.width / 2, self.view.height /2);
  @weakify(self);
  [retryButton touchUpInside:^{
    @strongify(self);
    [self hideRetryView];
    [self.viewModel setLoading:YES];
  }];
}

#pragma mark - LPDViewNetworkStatusProtocol

- (void)showNetworkNormal {
  [LPDAlertView hideWith:@"网络异常"];
}

- (void)showNetworkDisable {
  LPDAlertAction *cancelAction = [[LPDAlertAction alloc] init];
  cancelAction.title = @"取消";
  cancelAction.actionType = LPDAlertActionTypeCancel;
  LPDAlertAction *okAction = [[LPDAlertAction alloc] init];
  okAction.title = @"设置网络";
  okAction.action = ^{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
  };
  [LPDAlertView show:@"网络异常"
             message:@"当前网络无法正常连接，请检查网络设置。"
             action1:cancelAction
             action2:okAction];
}

#pragma mark - LPDViewSubmittingProtocol

- (UIView *)customSubmittingView {
  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
  contentView.layer.cornerRadius = 10;
  contentView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
  
  UIImageView *indicatorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 42)];
  indicatorImageView.animationImages = @[
                                          [UIImage imageNamed:@"01"],
                                          [UIImage imageNamed:@"02"],
                                          [UIImage imageNamed:@"03"],
                                          [UIImage imageNamed:@"04"],
                                          [UIImage imageNamed:@"05"],
                                          [UIImage imageNamed:@"06"]
                                          ];
  indicatorImageView.animationDuration = 0.5;
  indicatorImageView.animationRepeatCount = INFINITY;
  [contentView addSubview:indicatorImageView];
  indicatorImageView.center = CGPointMake(50, 50);
  // 添加自启动的动画
  @weakify(indicatorImageView);
  [[RACSignal merge:@[
                      [contentView rac_signalForSelector:@selector(didMoveToWindow)],
                      [contentView rac_signalForSelector:@selector(didMoveToSuperview)]
                      ]] subscribeNext:^(id x) {
    @strongify(indicatorImageView);
    [indicatorImageView startAnimating];
  }];
  return contentView;
}

#pragma mark - LPDViewToastProtocol

- (void)showSuccess:(NSString *_Nullable)status {
  [LPDToastView show:status];
}

- (void)showError:(NSString *_Nullable)status {
  [LPDToastView show:status];
}

@end
