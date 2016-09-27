//
//  LPDKeyboardView.m
//  LPDKeyboardView
//
//  Created by fox softer on 15/11/24.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDKeyButtonHolderView.h"
#import "LPDKeyButtonPopupView.h"
#import "LPDKeyboardView.h"
#import "NSArray+LPDRandom.h"
#import "NSCharacterSet+LPDAddition.h"
#import "UIButton+LPDKeyboardView.h"
#import "UIScreen+LPDAccessor.h"
#import "UIView+LPDAccessor.h"

const static CGFloat kKeyboardLinePadding = 8;
const static CGFloat kKeyboardButtonPadding = 3;
const static NSString *kCharacterAlphabets = @"q w e r t y u i o p a s d f g h j k l z x c v b n m";
const static NSString *kCharacterNumbers = @"1 2 3 4 5 6 7 8 9 0";

@interface LPDKeyboardView ()

@property (nonatomic, strong) UIView *alphabetView;
@property (nonatomic, strong) UIView *numberView;

@property (nonatomic, copy) NSArray<UIButton *> *orderedAlphabetButtons;
@property (nonatomic, copy) NSArray<UIButton *> *orderedNumberButtons;
@property (nonatomic, copy) NSArray<UIButton *> *alphabetButtons;
@property (nonatomic, copy) NSArray<UIButton *> *numberButtons;

@property (nonatomic, strong) UIButton *shiftButton;

// 退格按钮
@property (nonatomic, strong) UIButton *alphabetBackspaceButton;
@property (nonatomic, strong) UIButton *numberBackspaceButton;

// 键盘切换按钮
@property (nonatomic, strong) UIButton *alphabetSwitchButton;
@property (nonatomic, strong) UIButton *numberSwitchButton;

@property (nonatomic, strong) UIButton *alphabetReturnButton;
@property (nonatomic, strong) UIButton *numberReturnButton;

@property (nonatomic, strong) UIButton *alphabetSpaceButton;
@property (nonatomic, strong) UIButton *numberSpaceButton;

@property (nonatomic, strong) UIButton *numberDotButton;

@property (nonatomic, weak) UIButton *touchingAlphabetButton;

@end

@implementation LPDKeyboardView

#pragma mark - life cycle

- (instancetype)init {
  self = [super init];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)awakeFromNib {
  [self initialize];
}

- (void)initialize {
  self.frame = CGRectMake(0, 0, UIScreen.width, UIScreen.width * 0.65f);
  [self initializeAlphabetKeyboard];
}

- (void)layoutSubviews {
  [super layoutSubviews];

  switch (_keyboardType) {
    case LPDKeyboardTypeAlphabet:
      [self layoutAlphabetKeyboard];
      break;
    case LPDKeyboardTypeNumberPad:
      [self layoutNumberKeyboard];
      break;
  }
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

#pragma mark - private methods

- (void)initializeAlphabetKeyboard {
  if (!_alphabetView) {
    _alphabetView = [[LPDKeyButtonHolderView alloc] init];
    _alphabetView.backgroundColor = [UIColor colorWithRed:0.749 green:0.7647 blue:0.7922 alpha:1.0];
    [self addSubview:_alphabetView];
  }
  [self bringSubviewToFront:_alphabetView];
  if (!_alphabetButtons) {
    NSArray *alphabetStrings =
      [kCharacterAlphabets componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *alphabetButtons = [NSMutableArray arrayWithCapacity:alphabetStrings.count];
    for (NSString *alphabet in alphabetStrings) {
      UIButton *button = [UIButton buttonWithCharStyle];
      button.accessibilityIdentifier = alphabet;
      [button setTitle:alphabet forState:UIControlStateNormal];
      [button addTarget:self action:@selector(key:) forControlEvents:UIControlEventTouchUpInside];
      button.userInteractionEnabled = NO;
      [_alphabetView addSubview:button];
      [alphabetButtons addObject:button];
    }
    _orderedAlphabetButtons = [alphabetButtons copy];
  }
  if (_keyboardOrderType & LPDKeyboardOrderTypeAlphabetDisorderly) {
    _alphabetButtons = [_orderedAlphabetButtons randomCopy]; // 乱序
  } else {
    _alphabetButtons = _orderedAlphabetButtons;
  }
  if (!_shiftButton) {
    _shiftButton = [UIButton buttonWithCharControlStyle];
    [_shiftButton setImage:[UIImage imageNamed:@"ShiftIcon"] forState:UIControlStateNormal];
    [_shiftButton setTintColor:[UIColor whiteColor]];
    [_shiftButton addTarget:self action:@selector(shift:) forControlEvents:UIControlEventTouchUpInside];
    [_alphabetView addSubview:_shiftButton];
  }
  if (!_alphabetBackspaceButton) {
    _alphabetBackspaceButton = [UIButton buttonWithCharControlStyle];
    [_alphabetBackspaceButton setImage:[UIImage imageNamed:@"BackspaceIcon"] forState:UIControlStateNormal];
    [_alphabetBackspaceButton setTintColor:[UIColor whiteColor]];
    [_alphabetBackspaceButton addTarget:self action:@selector(backspace:) forControlEvents:UIControlEventTouchUpInside];
    [_alphabetView addSubview:_alphabetBackspaceButton];
  }
  if (!_alphabetSwitchButton) {
    _alphabetSwitchButton = [UIButton buttonWithCharControlStyle];
    [_alphabetSwitchButton setTintColor:[UIColor whiteColor]];
    [_alphabetSwitchButton setTitle:@"123" forState:UIControlStateNormal];
    [_alphabetSwitchButton addTarget:self
                              action:@selector(showNumberKeyboard)
                    forControlEvents:UIControlEventTouchUpInside];
    [_alphabetView addSubview:_alphabetSwitchButton];
  }
  if (!_alphabetReturnButton) {
    _alphabetReturnButton = [UIButton buttonWithCharControlStyle];
    [_alphabetReturnButton setTintColor:[UIColor whiteColor]];
    if ([self.textInput isKindOfClass:UITextView.class]) {
      [_alphabetReturnButton setTitle:@"换行" forState:UIControlStateNormal];
    } else if ([self.textInput isKindOfClass:UITextField.class]) {
      [_alphabetReturnButton setTitle:@"发送" forState:UIControlStateNormal];
    } else {
      [_alphabetReturnButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    [_alphabetReturnButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [_alphabetView addSubview:_alphabetReturnButton];
  }
  if (!_alphabetSpaceButton) {
    _alphabetSpaceButton = [UIButton buttonWithSpaceStyle];
    [_alphabetSpaceButton setTitle:@"空格" forState:UIControlStateNormal];
    _alphabetSpaceButton.accessibilityIdentifier = @" ";
    [_alphabetSpaceButton addTarget:self action:@selector(key:) forControlEvents:UIControlEventTouchUpInside];
    [_alphabetView addSubview:_alphabetSpaceButton];
  }
}

- (void)layoutAlphabetKeyboard {
  _alphabetView.frame = self.bounds;
  CGFloat lineHeight = (UIScreen.width * 0.65f + 4) / 4.f;
  CGFloat alphabetColumnWidth = UIScreen.width / 10.f;
  CGFloat charButtonWidth = alphabetColumnWidth - 2 * kKeyboardButtonPadding;
  CGFloat charButtonHeight = lineHeight - 2 * kKeyboardLinePadding;
  NSUInteger i = 0;
  for (; i < 10; i++) {
    UIButton *button = _alphabetButtons[i];
    button.frame = CGRectMake(alphabetColumnWidth * i + kKeyboardButtonPadding, kKeyboardLinePadding, charButtonWidth,
                              charButtonHeight);
  }
  for (; i < 19; i++) {
    UIButton *button = _alphabetButtons[i];
    button.frame = CGRectMake(alphabetColumnWidth * (i - 10) + kKeyboardButtonPadding * 2 + charButtonWidth / 2,
                              lineHeight + kKeyboardLinePadding, charButtonWidth, charButtonHeight);
  }
  for (; i < 26; i++) {
    UIButton *button = _alphabetButtons[i];
    button.frame = CGRectMake(alphabetColumnWidth * (i - 19) + kKeyboardButtonPadding * 4 + charButtonWidth * 1.5,
                              lineHeight * 2 + kKeyboardLinePadding, charButtonWidth, charButtonHeight);
  }
  _shiftButton.imageEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
  _shiftButton.frame =
    CGRectMake(kKeyboardButtonPadding, lineHeight * 2 + kKeyboardLinePadding, charButtonHeight, charButtonHeight);
  CGFloat topAndBottomPadding = (charButtonHeight - ((charButtonHeight - 16) * 0.75)) / 2;
  _alphabetBackspaceButton.imageEdgeInsets = UIEdgeInsetsMake(topAndBottomPadding, 8, topAndBottomPadding, 8);
  _alphabetBackspaceButton.frame =
    CGRectMake(CGRectGetWidth(self.bounds) - kKeyboardButtonPadding - charButtonHeight,
               lineHeight * 2 + kKeyboardLinePadding, charButtonHeight, charButtonHeight);
  _alphabetSwitchButton.frame = CGRectMake(kKeyboardButtonPadding, lineHeight * 3 + kKeyboardLinePadding,
                                           charButtonWidth * 2.5 + kKeyboardButtonPadding * 3, charButtonHeight);
  _alphabetSpaceButton.frame =
    CGRectMake(charButtonWidth * 2.5 + kKeyboardButtonPadding * 6, lineHeight * 3 + kKeyboardLinePadding,
               charButtonWidth * 5 + kKeyboardButtonPadding * 8, charButtonHeight);
  _alphabetReturnButton.frame = CGRectMake(
    CGRectGetWidth(self.bounds) - kKeyboardButtonPadding * 4 - charButtonWidth * 2.5,
    lineHeight * 3 + kKeyboardLinePadding, charButtonWidth * 2.5 + kKeyboardButtonPadding * 3, charButtonHeight);
}

- (void)initializeNumberKeyboard {
  if (!_numberView) {
    _numberView = [[UIView alloc] init];
    _numberView.backgroundColor = [UIColor colorWithRed:0.749 green:0.7647 blue:0.7922 alpha:1.0];
    [self addSubview:_numberView];
  }
  [self bringSubviewToFront:_numberView];
  if (!_numberButtons) {
    NSArray *numberStrings =
      [kCharacterNumbers componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSMutableArray *numberButtons = [NSMutableArray arrayWithCapacity:numberStrings.count];
    for (NSString *number in numberStrings) {
      UIButton *button = [UIButton buttonWithNumberStyle];
      button.accessibilityIdentifier = number;
      [button setTitle:number forState:UIControlStateNormal];
      [button addTarget:self action:@selector(key:) forControlEvents:UIControlEventTouchUpInside];
      [_numberView addSubview:button];
      [numberButtons addObject:button];
    }
    _orderedNumberButtons = [numberButtons copy];
  }
  if (_keyboardOrderType & LPDKeyboardOrderTypeNumberDisorderly) {
    _numberButtons = [_orderedNumberButtons randomCopy]; // 乱序
  } else {
    _numberButtons = _orderedNumberButtons;
  }

  if (!_numberBackspaceButton) {
    _numberBackspaceButton = [UIButton buttonWithNumberControlStyle];
    [_numberBackspaceButton setImage:[UIImage imageNamed:@"BackspaceIcon"] forState:UIControlStateNormal];
    [_numberBackspaceButton setTintColor:[UIColor whiteColor]];
    [_numberBackspaceButton addTarget:self action:@selector(backspace:) forControlEvents:UIControlEventTouchUpInside];
    [_numberView addSubview:_numberBackspaceButton];
  }
  if (!_numberSwitchButton) {
    _numberSwitchButton = [UIButton buttonWithNumberControlStyle];
    [_numberSwitchButton setTintColor:[UIColor whiteColor]];
    [_numberSwitchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_numberSwitchButton setTitle:@"ABC" forState:UIControlStateNormal];
    [_numberSwitchButton addTarget:self
                            action:@selector(showAlphabetKeyboard)
                  forControlEvents:UIControlEventTouchUpInside];
    [_numberView addSubview:_numberSwitchButton];
  }
  if (!_numberReturnButton) {
    _numberReturnButton = [UIButton buttonWithNumberControlStyle];
    [_numberReturnButton setTintColor:[UIColor whiteColor]];
    [_numberReturnButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    if ([self.textInput isKindOfClass:UITextView.class]) {
      [_numberReturnButton setTitle:@"换行" forState:UIControlStateNormal];
    } else if ([self.textInput isKindOfClass:UITextField.class]) {
      [_numberReturnButton setTitle:@"发送" forState:UIControlStateNormal];
    } else {
      [_numberReturnButton setTitle:@"确定" forState:UIControlStateNormal];
    }
    [_numberReturnButton addTarget:self action:@selector(send:) forControlEvents:UIControlEventTouchUpInside];
    [_numberView addSubview:_numberReturnButton];
  }
  if (!_numberSpaceButton) {
    _numberSpaceButton = [UIButton buttonWithNumberStyle];
    [_numberSpaceButton setTintColor:[UIColor whiteColor]];
    [_numberSpaceButton setTitle:@"空格" forState:UIControlStateNormal];
    _numberSpaceButton.accessibilityIdentifier = @" ";
    [_numberSpaceButton addTarget:self action:@selector(key:) forControlEvents:UIControlEventTouchUpInside];
    [_numberView addSubview:_numberSpaceButton];
  }
  if (!_numberDotButton) {
    _numberDotButton = [UIButton buttonWithNumberStyle];
    [_numberDotButton setTintColor:[UIColor whiteColor]];
    [_numberDotButton setTitle:@"." forState:UIControlStateNormal];
    _numberDotButton.accessibilityIdentifier = @".";
    [_numberDotButton addTarget:self action:@selector(key:) forControlEvents:UIControlEventTouchUpInside];
    [_numberView addSubview:_numberDotButton];
  }
}

- (void)layoutNumberKeyboard {
  _numberView.frame = self.bounds;
  CGFloat lineHeight = (UIScreen.width * 0.65f + 4) / 4.f;
  CGFloat columnWidth = (UIScreen.width - 1) / 4.f;
  NSUInteger i = 0;
  for (; i < 3; i++) {
    UIButton *button = _numberButtons[i];
    button.frame = CGRectMake(columnWidth * i, 0, columnWidth, lineHeight);
  }
  for (; i < 6; i++) {
    UIButton *button = _numberButtons[i];
    button.frame = CGRectMake(columnWidth * (i - 3), lineHeight, columnWidth, lineHeight);
  }
  for (; i < 9; i++) {
    UIButton *button = _numberButtons[i];
    button.frame = CGRectMake(columnWidth * (i - 6), lineHeight * 2, columnWidth, lineHeight);
  }
  _numberDotButton.frame = CGRectMake(0, lineHeight * 3, columnWidth, lineHeight);
  [_numberButtons lastObject].frame = CGRectMake(columnWidth, lineHeight * 3, columnWidth, lineHeight);
  _numberSpaceButton.frame = CGRectMake(columnWidth * 2, lineHeight * 3, columnWidth, lineHeight);
  CGFloat topAndBottomPadding = (lineHeight - ((columnWidth - 48) * 0.75)) / 2;
  _numberBackspaceButton.imageEdgeInsets = UIEdgeInsetsMake(topAndBottomPadding, 24, topAndBottomPadding, 24);
  _numberBackspaceButton.frame = CGRectMake(columnWidth * 3, 0, columnWidth, lineHeight);
  _numberSwitchButton.frame = CGRectMake(columnWidth * 3, lineHeight, columnWidth, lineHeight);
  _numberReturnButton.frame = CGRectMake(columnWidth * 3, lineHeight * 2, columnWidth, lineHeight * 2);
}

- (void)switchKeyboardCaseType {
  switch (_keyboardCaseType) {
    case LPDKeyboardCaseTypeLower: {
      [_alphabetButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *_Nonnull stop) {
        button.accessibilityIdentifier = button.accessibilityIdentifier.lowercaseString;
        [button setTitle:button.accessibilityIdentifier forState:UIControlStateNormal];
      }];
      [_shiftButton setTintColor:[UIColor whiteColor]];
    } break;
    case LPDKeyboardCaseTypeUpper: {
      [_alphabetButtons enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL *_Nonnull stop) {
        button.accessibilityIdentifier = button.accessibilityIdentifier.uppercaseString;
        [button setTitle:button.accessibilityIdentifier forState:UIControlStateNormal];
      }];
      [_shiftButton setTintColor:[UIColor blackColor]];
    } break;
  }
}

- (void)reloadKeyboard {
  switch (_keyboardType) {
    case LPDKeyboardTypeAlphabet: {
      [self initializeAlphabetKeyboard];
      [self layoutAlphabetKeyboard];
    } break;
    case LPDKeyboardTypeNumberPad: {
      [self initializeNumberKeyboard];
      [self layoutNumberKeyboard];
    } break;
  }
}

#pragma mark - actions

- (void)showAlphabetKeyboard {
  self.keyboardType = LPDKeyboardTypeAlphabet;
}

- (void)showNumberKeyboard {
  self.keyboardType = LPDKeyboardTypeNumberPad;
}

- (void)shift:(UIButton *)sender {
  self.keyboardCaseType = !_keyboardCaseType;
}

- (void)key:(UIButton *)sender {
  if ([self.textInput isKindOfClass:UITextField.class]) {
    UITextField *textField = (UITextField *)self.textInput;
    if ([textField.delegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
      NSInteger startPos = [self.textInput offsetFromPosition:self.textInput.beginningOfDocument
                                                   toPosition:self.textInput.selectedTextRange.start];
      NSInteger length = [self.textInput offsetFromPosition:self.textInput.selectedTextRange.start
                                                 toPosition:self.textInput.selectedTextRange.end];
      NSRange selectedRange = NSMakeRange(startPos, length);
      if ([textField.delegate textField:(UITextField *)self.textInput
            shouldChangeCharactersInRange:selectedRange
                        replacementString:sender.accessibilityIdentifier]) {
        [self.textInput insertText:sender.accessibilityIdentifier];
      }
    } else {
      [self.textInput insertText:sender.accessibilityIdentifier];
    }
  } else if ([self.textInput isKindOfClass:UITextView.class]) {
    UITextView *textView = (UITextView *)self.textInput;
    if ([textView.delegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
      NSInteger startPos = [self.textInput offsetFromPosition:self.textInput.beginningOfDocument
                                                   toPosition:self.textInput.selectedTextRange.start];
      NSInteger length = [self.textInput offsetFromPosition:self.textInput.selectedTextRange.start
                                                 toPosition:self.textInput.selectedTextRange.end];
      NSRange selectedRange = NSMakeRange(startPos, length);
      if ([textView.delegate textView:(UITextView *)self.textInput
              shouldChangeTextInRange:selectedRange
                      replacementText:sender.accessibilityIdentifier]) {
        [self.textInput insertText:sender.accessibilityIdentifier];
      }
    } else {
      [self.textInput insertText:sender.accessibilityIdentifier];
    }
  }
}

- (void)backspace:(UIButton *)sender {
  [self.textInput deleteBackward];
}

- (void)send:(UIButton *)sender {
  if ([self.textInput isKindOfClass:UITextField.class]) {
    UITextField *textField = (UITextField *)self.textInput;
    if ([textField.delegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
      if ([textField.delegate textFieldShouldReturn:(UITextField *)self.textInput]) {
        [self.textInput resignFirstResponder];
      }
    }
  } else if ([self.textInput isKindOfClass:UITextView.class]) {
    [self.textInput insertText:@"\n"];
  }
}

#pragma mark - properties

- (void)setTextInput:(UIResponder<UITextInput> *)textInput {
  if (textInput) {
    _textInput = textInput;
  }
  if ([textInput isKindOfClass:UITextView.class]) {
    [_alphabetReturnButton setTitle:@"换行" forState:UIControlStateNormal];
    [_numberReturnButton setTitle:@"换行" forState:UIControlStateNormal];
  } else if ([textInput isKindOfClass:UITextField.class]) {
    [_alphabetReturnButton setTitle:@"发送" forState:UIControlStateNormal];
    [_numberReturnButton setTitle:@"发送" forState:UIControlStateNormal];
  }
}

- (void)setKeyboardCaseType:(LPDKeyboardCaseType)keyboardCaseType {
  if (_keyboardCaseType != keyboardCaseType) {
    _keyboardCaseType = keyboardCaseType;
    [self switchKeyboardCaseType];
  }
}

- (void)setKeyboardType:(LPDKeyboardType)keyboardType {
  if (_keyboardType != keyboardType) {
    _keyboardType = keyboardType;
    [self reloadKeyboard];
  }
}

- (void)setKeyboardOrderType:(LPDKeyboardOrderType)keyboardOrderType {
  if (_keyboardOrderType != keyboardOrderType) {
    _keyboardOrderType = keyboardOrderType;
    [self reloadKeyboard];
  }
}

@end
