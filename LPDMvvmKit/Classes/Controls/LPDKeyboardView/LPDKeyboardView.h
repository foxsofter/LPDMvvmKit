//
//  LPDKeyboardView.h
//  LPDKeyboardView
//
//  Created by fox softer on 15/11/24.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  字母键盘的大小写类型
 */
typedef NS_ENUM(NSUInteger, LPDKeyboardCaseType) {
  /**
   *  小写，默认值
   */
  LPDKeyboardCaseTypeLower,
  /**
   *  大写
   */
  LPDKeyboardCaseTypeUpper,
};

/**
 *  键盘类型
 */
typedef NS_ENUM(NSUInteger, LPDKeyboardType) {
  /**
   *  字母键盘，默认值
   */
  LPDKeyboardTypeAlphabet,
  /**
   *  数字键盘
   */
  LPDKeyboardTypeNumberPad,
};

/**
 *  键盘字符排序类型
 */
typedef NS_OPTIONS(NSUInteger, LPDKeyboardOrderType) {
  /**
   *  标准键盘排序，默认值
   */
  LPDKeyboardOrderTypeNone = 0,
  /**
   *  字母键盘乱序
   */
  LPDKeyboardOrderTypeAlphabetDisorderly = 1 << 0,
  /**
   *  数字键盘乱序
   */
  LPDKeyboardOrderTypeNumberDisorderly = 1 << 1,
  /**
   *  字母键盘和数字键盘都乱序
   */
  LPDKeyboardOrderTypeBothDisorderly = LPDKeyboardOrderTypeAlphabetDisorderly | LPDKeyboardOrderTypeNumberDisorderly,
};

/**
 *  自定义输入键盘的视图，支持大小写字母和数字两种键盘类型，只支持iPhone竖屏
 */
@interface LPDKeyboardView : UIView

/**
 *  输入目标
 */
@property (nonatomic, weak) UIResponder<UITextInput> *textInput;

/**
 *  设置键盘字符大小写输入，设置后始终以设置的大小写格式进行输入
 */
@property (nonatomic, assign) LPDKeyboardCaseType keyboardCaseType;

/**
 *  键盘类型，大小写字母和数字两种
 */
@property (nonatomic, assign) LPDKeyboardType keyboardType;

/**
 *  键盘字符排序类型
 */
@property (nonatomic, assign) LPDKeyboardOrderType keyboardOrderType;

@end
