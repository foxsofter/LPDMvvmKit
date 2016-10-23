//
//  LPDAlertView.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDAlertView.h"
#import <Masonry/Masonry.h>
#import "NSMutableArray+LPDStack.h"
#import "UIButton+LPDAddition.h"
#import "UIColor+LPDAddition.h"
#import "UIControl+Block.h"
#import "UIScreen+LPDAccessor.h"
#import "UIView+LPDAccessor.h"
#import "UIView+LPDBorders.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation LPDAlertAction

@end

@interface LPDAlertView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSArray *actions;
@property (nonatomic, copy) NSString *caption;

@end

@implementation LPDAlertView

+ (void)show:(NSString *)message title:(NSString *)title action:(void (^)(void))action {
  LPDAlertAction *alertAction = [[LPDAlertAction alloc] init];
  alertAction.title = title;
  alertAction.action = action;
  [self show:nil message:message actions:@[alertAction]];
}

+ (void)show:(NSString *)message
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2 {
  LPDAlertAction *alertAction1 = [[LPDAlertAction alloc] init];
  alertAction1.title = title1;
  alertAction1.action = action1;
  LPDAlertAction *alertAction2 = [[LPDAlertAction alloc] init];
  alertAction2.title = title2;
  alertAction2.action = action2;
  [self show:nil message:message actions:@[alertAction1, alertAction2]];
}

+ (void)show:(NSString *)message action:(LPDAlertAction *)action {
  [self show:nil message:message actions:@[action]];
}

+ (void)show:(NSString *)message action1:(LPDAlertAction *)action1 action2:(LPDAlertAction *)action2 {
  [self show:nil message:message actions:@[action1, action2]];
}

+ (void)show:(NSString *)caption message:(NSString *)message title:(NSString *)title action:(void (^)(void))action {
  LPDAlertAction *alertAction = [[LPDAlertAction alloc] init];
  alertAction.title = title;
  alertAction.action = action;
  [self show:caption message:message actions:@[alertAction]];
}

+ (void)show:(NSString *)caption
     message:(NSString *)message
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2 {
  LPDAlertAction *alertAction1 = [[LPDAlertAction alloc] init];
  alertAction1.title = title1;
  alertAction1.action = action1;
  LPDAlertAction *alertAction2 = [[LPDAlertAction alloc] init];
  alertAction2.title = title2;
  alertAction2.action = action2;
  [self show:caption message:message actions:@[alertAction1, alertAction2]];
}

+ (void)show:(NSString *)caption message:(NSString *)message action:(LPDAlertAction *)action {
  [self show:caption message:message actions:@[action]];
}

+ (void)show:(NSString *)caption
     message:(NSString *)message
     action1:(LPDAlertAction *)action1
     action2:(LPDAlertAction *)action2 {
  [self show:caption message:message actions:@[action1, action2]];
}

#pragma mark - private methods

+ (NSMutableArray *)alertViews {
  static NSMutableArray *alerts;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    alerts = [NSMutableArray array];
  });
  return alerts;
}

+ (void)show:(NSString *)caption message:(NSString *)message actions:(NSArray *)actions {
  @synchronized(self) {
    LPDAlertView *alertView = [[self alertViews] peekObject];
    if (alertView) {
      [alertView hide];
    }
    alertView = [[LPDAlertView alloc] init];
    [alertView show:caption message:message actions:actions];
    [[self alertViews] pushObject:alertView];
  }
}

- (void)show:(NSString *)caption message:(NSString *)message actions:(NSArray *)actions {
  self.actions = actions;
  self.caption = caption;
  _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.width, UIScreen.height)];

  _contentView = [[UIView alloc] init];
  _contentView.backgroundColor = [UIColor whiteColor];
  _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
  [_backgroundView addSubview:_contentView];
  _contentView.layer.cornerRadius = 3;

  [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(@(UIScreen.width * 0.14));
    make.right.equalTo(@(-UIScreen.width * 0.14));
    make.center.equalTo(self.backgroundView);
    make.height.greaterThanOrEqualTo(@80);
  }];

  UILabel *captionLabel = nil;
  if (caption && caption.length > 0) {
    captionLabel = [[UILabel alloc] init];
    captionLabel.text = caption;
    captionLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    captionLabel.font = [UIFont systemFontOfSize:17];
    [_contentView addSubview:captionLabel];
    [captionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(@20);
      make.left.equalTo(@27);
      make.right.equalTo(@(-27));
    }];
  }

  UILabel *messageLabel = nil;
  if (message && message.length > 0) {
    messageLabel = [[UILabel alloc] init];
    messageLabel.text = message;
    messageLabel.textColor = [UIColor colorWithHexString:@"#797979"];
    messageLabel.font = [UIFont systemFontOfSize:13];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentLeft;
    [_contentView addSubview:messageLabel];
    [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(@27);
      make.right.equalTo(@(-27));
      if (captionLabel) {
        make.top.equalTo(captionLabel.mas_bottom).with.offset(7);
      } else {
        make.top.equalTo(@20);
      }
    }];
  }
  UIButton *button = nil;
  CGFloat buttonWidth = UIScreen.width * 0.73 / actions.count;
  CGFloat left = 0;
  for (NSInteger i = 0; i < actions.count; i++) {
    LPDAlertAction *action = [actions objectAtIndex:i];
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, buttonWidth, 44);
    [button setTitle:action.title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.contentMode = UIViewContentModeCenter;

    [_contentView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.equalTo(@(left));
      make.bottom.equalTo(@0);
      make.width.equalTo(@(buttonWidth));
      make.height.equalTo(@44);
    }];
    left += buttonWidth;
    if (action.actionType == LPDAlertActionTypeDefault) {
      [button setTitleColor:[UIColor colorWithHexString:@"#008AF1"] forState:UIControlStateNormal];
      button.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    } else if (action.actionType == LPDAlertActionTypeDestructive) {
      [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    } else {
      [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    }
    if (i == 0) {
      [button setBorder:0.5
            borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.25]
         borderPosition:LPDUIViewBorderPositionTop];
    } else {
      [button setBorder:0.5
            borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.25]
         borderPosition:LPDUIViewBorderPositionTop | LPDUIViewBorderPositionLeft];
    }

    @weakify(self, action);
    [button touchUpInside:^{
      @strongify(self, action);
      [self hide:action.action];
    }];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
      if (messageLabel) {
        make.top.equalTo(messageLabel.mas_bottom).with.offset(20).priority(MASLayoutPriorityFittingSizeLevel);
      } else if (captionLabel) {
        make.top.equalTo(captionLabel.mas_bottom).with.offset(20).priority(MASLayoutPriorityFittingSizeLevel);
      } else {
        make.top.equalTo(@20).priority(MASLayoutPriorityFittingSizeLevel);
      }
    }];
  }
  [self show];
}

+ (void)hideAll {
  for (NSInteger i = self.alertViews.count - 1; i >= 0; i--) {
    LPDAlertView *alertView = self.alertViews[i];
    [self.alertViews removeObjectAtIndex:i];
    [alertView hide];
  }
}

+ (void)hideWith:(NSString *)caption animated:(BOOL)animated {
  for (NSInteger i = self.alertViews.count - 1; i >= 0; i--) {
    LPDAlertView *alertView = self.alertViews[i];
    if ([alertView.caption isEqualToString:caption]) {
      [self.alertViews removeObjectAtIndex:i];
      if (animated) {
        [alertView hide:nil];
      } else {
        [alertView remove:nil];
      }
    }
  }
}

+ (BOOL)existWith:(NSString *)caption {
  for (NSInteger i = self.alertViews.count - 1; i >= 0; i--) {
    LPDAlertView *alertView = self.alertViews[i];
    if ([alertView.caption isEqualToString:caption]) {
      return YES;
    }
  }
  return NO;
}

- (void)show {
  NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];

  for (UIWindow *window in frontToBackWindows) {
    if (window.windowLevel == UIWindowLevelNormal && !window.hidden) {
      [window addSubview:_backgroundView];
      break;
    }
  }
  self.contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
  self.backgroundView.backgroundColor = [UIColor clearColor];
  [UIView animateWithDuration:0.2
    animations:^{
      self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
      self.contentView.transform = CGAffineTransformMakeScale(1, 1);
    }
    completion:^(BOOL finished) {
      if (finished) {
        [UIView animateWithDuration:0.2
                         animations:^{
                           self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                         }];
      }
    }];
}

- (void)hide:(void (^)(void))completion {
  [UIView animateWithDuration:0.2
    animations:^{
      self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
      self.backgroundView.backgroundColor = [UIColor clearColor];
    }
    completion:^(BOOL finished) {
      [self remove:completion];
    }];
}

- (void)remove:(void (^)(void))completion {
  [self.backgroundView removeFromSuperview];
  self.backgroundView = nil;
  [[self.class alertViews] removeObject:self];
  LPDAlertView *alertView = [[self.class alertViews] peekObject];
  if (alertView) {
    [alertView show];
  }
  if (completion) {
    completion();
  }
}

- (void)hide {
  [UIView animateWithDuration:0.2
    animations:^{
      self.contentView.transform = CGAffineTransformMakeScale(0.01, 0.01);
      self.backgroundView.backgroundColor = [UIColor clearColor];
    }
    completion:^(BOOL finished) {
      [self.backgroundView removeFromSuperview];
    }];
}

@end
