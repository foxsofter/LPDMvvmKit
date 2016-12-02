//
//  LPDPopupActionSheet.m
//  FoxKit
//
//  Created by foxsofter on 15/10/9.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDPopupActionSheet.h"
#import "LPDPopupView.h"
#import "SDVersion.h"
#import "UIControl+Block.h"
#import "UIScreen+LPDAccessor.h"

@interface UILabel (LPDPopupPickerView)

// PrimaryLabel {
//  font-name: @primaryFontName;
//  font-color: @primaryFontColor;
//}
+ (instancetype)labelWithPrimaryStyle;

// SecondaryLabel {
//  font-name: @secondaryFontName;
//  font-color: @secondaryFontColor;
//}
+ (instancetype)labelWithSecondaryStyle;

// PrimaryTipLabel {
//  font-name: @primaryTipFontName;
//  font-color: @primaryTipFontColor;
//}
+ (instancetype)labelWithPrimaryTipStyle;

// SecondaryTipLabel {
//  font-name: @secondaryTipFontName;
//  font-color: @secondaryTipFontColor;
//}
+ (instancetype)labelWithSecondaryTipStyle;

@end

@implementation UILabel (LPDPopupPickerView)

+ (instancetype)labelWithPrimaryStyle {
  UILabel *label = [[UILabel alloc] init];
  //  label.nuiClass = @"PrimaryLabel";
  //  [label applyNUI];
  return label;
}
+ (instancetype)labelWithSecondaryStyle {
  UILabel *label = [[UILabel alloc] init];
  //  label.nuiClass = @"SecondaryLabel";
  //  [label applyNUI];
  return label;
}

+ (instancetype)labelWithPrimaryTipStyle {
  UILabel *label = [[UILabel alloc] init];
  //  label.nuiClass = @"PrimaryTipLabel";
  //  [label applyNUI];
  return label;
}

+ (instancetype)labelWithSecondaryTipStyle {
  UILabel *label = [[UILabel alloc] init];
  //  label.nuiClass = @"SecondaryTipLabel";
  //  [label applyNUI];
  return label;
}

@end

@interface UIButton (LPDPopupPickerView)

/**
 *  @brief  get button of normal style
 *
 *  @return return normal style button
 */
+ (instancetype)buttonWithNormalStyle;

/**
 *  @brief  get button of submit style
 *
 *  @return return submit style button
 */
+ (instancetype)buttonWithSubmitStyle;

/**
 *  @brief  get button of cancel style
 *
 *  @return cancel style button
 */
+ (instancetype)buttonWithCancelStyle;

@end

@implementation UIButton (LPDPopupPickerView)

+ (instancetype)buttonWithNormalStyle {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  //  [button applyNUI];
  return button;
}

+ (instancetype)buttonWithSubmitStyle {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  //  button.nuiClass = @"Button:SubmitButton";
  //  [button applyNUI];
  return button;
}

+ (instancetype)buttonWithCancelStyle {
  UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
  //  button.nuiClass = @"Button:CancelButton";
  //  [button applyNUI];
  return button;
}

@end

@interface LPDPopupActionSheet ()

@property (nonatomic, strong) NSDictionary *actionOptions;

@end

@implementation LPDPopupActionSheet

+ (void)show:(NSString *)caption actionOptions:(NSDictionary *)actionOptions {
  CGFloat buttonHeight = 0;
  CGFloat cancelButtonHeight = 0;
  if ([SDiOSVersion deviceSize] <= Screen4inch) {
    buttonHeight = 44;
    cancelButtonHeight = 54;
  } else if ([SDiOSVersion deviceSize] == Screen4Dot7inch) {
    buttonHeight = 54;
    cancelButtonHeight = 64;
  } else if ([SDiOSVersion deviceSize] == Screen5Dot5inch) {
    buttonHeight = 64;
    cancelButtonHeight = 74;
  }
  CGFloat width = UIScreen.width;
  CGFloat height = 0.f;
  if (caption) {
    height = (buttonHeight + 1) * (actionOptions.count + 1) + cancelButtonHeight + 1;
  } else {
    height = (buttonHeight + 1) * actionOptions.count + cancelButtonHeight + 1;
  }
  UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
  contentView.backgroundColor = [UIColor popupViewBackgroundColor];

  UIButton *cancelButton = [UIButton buttonWithCancelStyle];
  [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
  [cancelButton addTarget:self action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside];
  [contentView addSubview:cancelButton];
  cancelButton.frame = CGRectMake(0, height - cancelButtonHeight, width, cancelButtonHeight);

  if (caption) {
    UILabel *captionLabel = [UILabel labelWithPrimaryTipStyle];
    captionLabel.frame = CGRectMake(0, 2, width, buttonHeight - 1);
    captionLabel.text = caption;
    captionLabel.textAlignment = NSTextAlignmentCenter;
    captionLabel.textColor = [UIColor labelFontColor];
    captionLabel.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [contentView addSubview:captionLabel];
  }
  for (int i = 0; i < actionOptions.count; i++) {
    UIButton *button = [UIButton buttonWithNormalStyle];
    [contentView addSubview:button];
    if (caption) {
      button.frame = CGRectMake(0, (i + 1) * (buttonHeight + 1), width, buttonHeight);
    } else {
      button.frame = CGRectMake(0, i * (buttonHeight + 1), width, buttonHeight);
    }
    NSString *key = (actionOptions.allKeys)[i];
    [button setTitle:key forState:UIControlStateNormal];

    [button touchUpInside:actionOptions[key]];

    [button addTarget:self action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside];
  };

  [LPDPopupView show:contentView];
}

+ (void)hideView:(UIButton *)sender {
  [LPDPopupView hide];
}

+ (void)show:(NSString *)title action:(void (^)(void))action {
  [self show:nil actionOptions:@{title: action}];
}

+ (void)show:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2 {
  [self show:nil actionOptions:@{title1: action1, title2: action2}];
}

+ (void)show:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3 {
  [self show:nil actionOptions:@{title1: action1, title2: action2, title3: action3}];
}

+ (void)show:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3
      title4:(NSString *)title4
     action4:(void (^)(void))action4 {
  [self show:nil actionOptions:@{title1: action1, title2: action2, title3: action3, title4: action4}];
}

+ (void)show:(NSString *)caption title:(NSString *)title action:(void (^)(void))action {
  [self show:caption actionOptions:@{title: action}];
}

+ (void)show:(NSString *)caption
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2 {
  [self show:caption actionOptions:@{title1: action1, title2: action2}];
}

+ (void)show:(NSString *)caption
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3 {
  [self show:caption actionOptions:@{title1: action1, title2: action2, title3: action3}];
}

+ (void)show:(NSString *)caption
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3
      title4:(NSString *)title4
     action4:(void (^)(void))action4 {
  [self show:caption actionOptions:@{title1: action1, title2: action2, title3: action3, title4: action4}];
}

@end
