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

- (void)showEmptyViewWithImage:(UIImage *_Nullable)image title:(NSString *_Nullable)title subTitle:(NSString *_Nullable)subTitle {
  if (self.view.width < 1 || self.view.height < 1) {
    return;
  }
  UIView *prevView = [self.view viewWithTag:888888];
  if (prevView) {
    return;
  }
  
  UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 250)];
  emptyView.tag = 888888;
  emptyView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:emptyView];
  emptyView.center = CGPointMake(self.view.width / 2, self.view.height /2);
  
  UIImageView *emptyImageView = [[UIImageView alloc] init];
  emptyImageView.frame = CGRectMake((200 - 150)/2, 20, 150, 150);
  emptyImageView.image = image;
  [emptyView addSubview:emptyImageView];
  
  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.numberOfLines = 1;
  titleLabel.text = title;
  titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
  titleLabel.font = [UIFont systemFontOfSize:15];
  titleLabel.frame = CGRectMake(0, 178, 200, 18);
  titleLabel.textAlignment = NSTextAlignmentCenter;
  [emptyView addSubview:titleLabel];
  
  UILabel *subTitleLabel = [[UILabel alloc] init];
  subTitleLabel.numberOfLines = 1;
  subTitleLabel.text = subTitle;
  subTitleLabel.textColor = [UIColor colorWithHexString:@"#A4A4A4"];
  subTitleLabel.font = [UIFont systemFontOfSize:12];
  subTitleLabel.frame = CGRectMake(0, 202, 200, 15);
  subTitleLabel.textAlignment = NSTextAlignmentCenter;
  [emptyView addSubview:subTitleLabel];
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
  
  UIView *retryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 300)];
  retryView.tag = 999999;
  retryView.backgroundColor = [UIColor clearColor];
  [self.view addSubview:retryView];
  retryView.center = CGPointMake(self.view.width / 2, self.view.height /2);
  
  UIImageView *retryImageView = [[UIImageView alloc] init];
  retryImageView.frame = CGRectMake((200 - 150)/2, 20, 150, 150);
  retryImageView.image = [UIImage imageNamed:@"image_default_network"];
  [retryView addSubview:retryImageView];
  
  UILabel *titleLabel = [[UILabel alloc] init];
  titleLabel.numberOfLines = 1;
  titleLabel.text = @"网络较差";
  titleLabel.textColor = [UIColor colorWithHexString:@"#666666"];
  titleLabel.font = [UIFont systemFontOfSize:15];
  titleLabel.frame = CGRectMake(0, 178, 200, 18);
  titleLabel.textAlignment = NSTextAlignmentCenter;
  [retryView addSubview:titleLabel];
  
  UILabel *subTitleLabel = [[UILabel alloc] init];
  subTitleLabel.numberOfLines = 1;
  subTitleLabel.text = @"哔！与总部失去联络";
  subTitleLabel.textColor = [UIColor colorWithHexString:@"#A4A4A4"];
  subTitleLabel.font = [UIFont systemFontOfSize:12];
  subTitleLabel.frame = CGRectMake(0, 202, 200, 15);
  subTitleLabel.textAlignment = NSTextAlignmentCenter;
  [retryView addSubview:subTitleLabel];
  
  UIButton *retryButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [retryButton setTitle:@"重新加载" forState:UIControlStateNormal];
  [retryButton setTitleColor:[UIColor colorWithHexString:@"#008AF1"] forState:UIControlStateNormal];
  retryButton.layer.borderWidth = 0.5f;
  retryButton.layer.borderColor = [UIColor colorWithHexString:@"#008AF1"].CGColor;
  retryButton.layer.cornerRadius = 4;
  retryButton.layer.masksToBounds = YES;
  retryButton.frame = CGRectMake((200 - 140) / 2, 247, 140, 40);
  [retryView addSubview:retryButton];
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
