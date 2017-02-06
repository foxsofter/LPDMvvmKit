//
//  LPDViewController+LPDExam.m
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/6.
//  Copyright © 2017年 foxsofter. All rights reserved.
//

#import "LPDViewController+LPDExam.h"
#import <LPDAdditionsKit/LPDAdditionsKit.h>

@implementation LPDViewController (LPDExam)

#pragma mark - LPDViewDisplayingProtocol

+ (void)displayNormalView:(UIView *)view {
  UIView *prevView = [view viewWithTag:999999];
  if (prevView) {
    [prevView removeFromSuperview];
  }
  prevView = [view viewWithTag:888888];
  if (prevView) {
    [prevView removeFromSuperview];
  }
}

+ (void)displayNoDataView:(UIView *)view withDescription:(NSString *_Nullable)description {
  if (view.width < 1 || view.height < 1) {
    return;
  }
  UIView *prevView = [view viewWithTag:999999];
  if (prevView) {
    [prevView removeFromSuperview];
  }
  prevView = [view viewWithTag:888888];
  if (prevView) {
    return;
  }
  
  UIView *noDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 170)];
  noDataView.tag = 888888;
  noDataView.backgroundColor = [UIColor clearColor];
  UIImageView *iconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"缺省页－空状态"]];
  [noDataView addSubview:iconView];
  iconView.frame = CGRectMake(0, 0, 150, 150);
  if (description && description.length > 0) {
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.text = description;
    messageLabel.textColor = [UIColor lightGrayColor];
    messageLabel.font = [UIFont systemFontOfSize:16];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [noDataView addSubview:messageLabel];
    messageLabel.frame = CGRectMake(0, 150, 150, 20);
  }
  [view insertSubview:noDataView atIndex:0];
  CGPoint center = noDataView.center = CGPointMake(UIScreen.width / 2, center.y);
}

+ (void)displayRetryView:(UIView *)view withDescription:(NSString *_Nullable)description {
  if (view.width < 1 || view.height < 1) {
    return;
  }
  UIView *prevView = [view viewWithTag:888888];
  if (prevView) {
    [prevView removeFromSuperview];
  }
  prevView = [view viewWithTag:999999];
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
  messageLabel.text = description ? description : @"当前网络环境较差";
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
  [view insertSubview:retryView atIndex:0];
  retryView.center = CGPointMake(UIScreen.width / 2, center.y); // 避免横向分页的时候引起问题

  @weakify(view);
  [retryButton touchUpInside:^{
    @strongify(view);
    [view.mj_header beginRefreshing];
  }];
}

#pragma mark - LPDViewNetworkStatusProtocol

+ (void)showNetworkNormal {
  
}

+ (void)showNetworkDisable {
  
}

#pragma mark - LPDViewSubmittingProtocol

+ (UIView *)initSubmittingView {
  
}

#pragma mark - LPDViewToastProtocol

+ (void)showSuccess:(NSString *_Nullable)status {
  
}

+ (void)showError:(NSString *_Nullable)status {
  
}

@end
