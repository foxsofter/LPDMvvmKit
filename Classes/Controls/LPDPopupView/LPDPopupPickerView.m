//
//  LPDPopupPickerView.m
//  FoxKit
//
//  Created by fox softer on 15/10/9.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDPopupPickerView.h"
#import "LPDPopupView.h"
#import <Masonry/Masonry.h>
#import "UIScreen+LPDAccessor.h"
#import "UIView+LPDAccessor.h"

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

@interface LPDPopupPickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *okButton;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSString *caption;

@property (nonatomic, strong) NSArray<NSString *> *arrayOfTitles1;
@property (nonatomic, strong) NSArray<NSString *> *arrayOfTitles2;
@property (nonatomic, strong) NSArray<NSString *> *arrayOfTitles3;

@property (nonatomic, assign) NSUInteger selectedIndex1;
@property (nonatomic, assign) NSUInteger selectedIndex2;
@property (nonatomic, assign) NSUInteger selectedIndex3;

@property (nonatomic, copy) void (^okAction1)(NSUInteger);
@property (nonatomic, copy) void (^okAction2)(NSUInteger, NSUInteger);
@property (nonatomic, copy) void (^okAction3)(NSUInteger, NSUInteger, NSUInteger);

@property (nonatomic, assign) NSInteger pickerViewComponentCount;

@end

@implementation LPDPopupPickerView

#pragma mark - public methods

static LPDPopupPickerView *_popupView;

+ (void)show:(NSString *)caption
  arrayOfTitles:(NSArray<NSString *> *)arrayOfTitles
       okAction:(void (^)(NSUInteger))action {
  [LPDPopupPickerView show:caption arrayOfTitles:arrayOfTitles selectedIndex:0 okAction:action];
}

+ (void)show:(NSString *)caption
  arrayOfTitles:(NSArray<NSString *> *)arrayOfTitles
  selectedIndex:(NSUInteger)selectedIndex
       okAction:(void (^)(NSUInteger))action {
  if (_popupView) {
    [_popupView clear];
  }
  _popupView = [[LPDPopupPickerView alloc] init];
  _popupView.caption = caption;
  _popupView.arrayOfTitles1 = arrayOfTitles;
  _popupView.selectedIndex1 = selectedIndex;
  _popupView.okAction1 = action;
  _popupView.pickerViewComponentCount = 1;
  [_popupView show];
}

+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
        okAction:(void (^)(NSUInteger, NSUInteger))action {
  [LPDPopupPickerView show:caption
            arrayOfTitles1:arrayOfTitles1
            selectedIndex1:0
            arrayOfTitles2:arrayOfTitles2
            selectedIndex2:0
                  okAction:action];
}

+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  selectedIndex1:(NSUInteger)selectedIndex1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
  selectedIndex2:(NSUInteger)selectedIndex2
        okAction:(void (^)(NSUInteger, NSUInteger))action {
  if (_popupView) {
    [_popupView clear];
  }
  _popupView = [[LPDPopupPickerView alloc] init];
  _popupView.caption = caption;
  _popupView.arrayOfTitles1 = arrayOfTitles1;
  _popupView.selectedIndex1 = selectedIndex1;
  _popupView.arrayOfTitles2 = arrayOfTitles2;
  _popupView.selectedIndex2 = selectedIndex2;
  _popupView.okAction2 = action;
  _popupView.pickerViewComponentCount = 2;
  [_popupView show];
}

+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
  arrayOfTitles3:(NSArray<NSString *> *)arrayOfTitles3
        okAction:(void (^)(NSUInteger, NSUInteger, NSUInteger))action {
  [LPDPopupPickerView show:caption
            arrayOfTitles1:arrayOfTitles1
            selectedIndex1:0
            arrayOfTitles2:arrayOfTitles2
            selectedIndex2:0
            arrayOfTitles3:arrayOfTitles3
            selectedIndex3:0
                  okAction:action];
}

+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  selectedIndex1:(NSUInteger)selectedIndex1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
  selectedIndex2:(NSUInteger)selectedIndex2
  arrayOfTitles3:(NSArray<NSString *> *)arrayOfTitles3
  selectedIndex3:(NSUInteger)selectedIndex3
        okAction:(void (^)(NSUInteger, NSUInteger, NSUInteger))action {
  if (_popupView) {
    [_popupView clear];
  }
  _popupView = [[LPDPopupPickerView alloc] init];
  _popupView.caption = caption;
  _popupView.arrayOfTitles1 = arrayOfTitles1;
  _popupView.selectedIndex1 = selectedIndex1;
  _popupView.arrayOfTitles2 = arrayOfTitles2;
  _popupView.selectedIndex2 = selectedIndex2;
  _popupView.arrayOfTitles3 = arrayOfTitles3;
  _popupView.selectedIndex3 = selectedIndex3;
  _popupView.okAction3 = action;
  _popupView.pickerViewComponentCount = 3;
  [_popupView show];
}

+ (void)hide {
  if (_popupView) {
    [_popupView hide];
  }
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
  switch (component) {
    case 0:
      return _arrayOfTitles1[row];
    case 1:
      return _arrayOfTitles2[row];
    case 2:
      return _arrayOfTitles3[row];
  }
  return nil;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
  switch (component) {
    case 0:
      _selectedIndex1 = row;
      break;
    case 1:
      _selectedIndex2 = row;
      break;
    case 2:
      _selectedIndex3 = row;
      break;
  }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
  return pickerView.height / 5;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
  return pickerView.width / _pickerViewComponentCount;
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
  return _pickerViewComponentCount;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
  switch (component) {
    case 0:
      return _arrayOfTitles1.count;
      break;
    case 1:
      return _arrayOfTitles2.count;
      break;
    case 2:
      return _arrayOfTitles3.count;
      break;
  }
  return 0;
}

#pragma mark - private methods

- (void)show {
  _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.width, 0.9 * UIScreen.width)];
  _contentView.backgroundColor = [UIColor whiteColor];

  _okButton = [UIButton buttonWithSubmitStyle];
  [_okButton setTitle:@"确定" forState:UIControlStateNormal];
  [_okButton addTarget:self action:@selector(okButtonClick:) forControlEvents:UIControlEventTouchUpInside];
  [_contentView addSubview:_okButton];
  [_okButton mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(@10);
    make.right.equalTo(@(-10));
    make.bottom.equalTo(@(-10));
    make.height.equalTo(@40);
  }];

  UILabel *captionLabel = nil;
  if (_caption) {
    captionLabel = [UILabel labelWithPrimaryTipStyle];
    captionLabel.text = _caption;
    captionLabel.textAlignment = NSTextAlignmentCenter;
    captionLabel.textColor = [UIColor labelFontColor];
    [_contentView addSubview:captionLabel];
    [captionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.top.equalTo(@8);
      make.left.equalTo(@10);
      make.right.equalTo(@(-10));
      make.height.greaterThanOrEqualTo(@30);
    }];
  }

  _pickerView = [[UIPickerView alloc] init];
  _pickerView.backgroundColor = [UIColor whiteColor];
  _pickerView.delegate = self;
  _pickerView.dataSource = self;
  [_contentView addSubview:_pickerView];
  [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.equalTo(@10);
    make.right.equalTo(@(-10));
    make.bottom.equalTo(_okButton.mas_top).offset(4);
    if (self.caption) {
      make.top.equalTo(captionLabel.mas_bottom).offset(-4);
    } else {
      make.top.equalTo(@(-4));
    }
  }];
  _okButton.layer.zPosition = 100;
  if (captionLabel) {
    captionLabel.layer.zPosition = 100;
  }

  [LPDPopupView show:_contentView];
}

- (void)hide {
  [LPDPopupView hide];
}

- (void)clear {
  [_contentView removeFromSuperview];
  _contentView = nil;
  _popupView = nil;
}

- (void)okButtonClick:(UIButton *)sender {
  switch (_pickerViewComponentCount) {
    case 1:
      if (_okAction1) {
        _okAction1(_selectedIndex1);
      }
      break;
    case 2:
      if (_okAction2) {
        _okAction2(_selectedIndex1, _selectedIndex2);
      }
      break;
    case 3:
      if (_okAction3) {
        _okAction3(_selectedIndex1, _selectedIndex2, _selectedIndex3);
      }
      break;
  }
  [self hide];
  _popupView = nil;
}

@end
