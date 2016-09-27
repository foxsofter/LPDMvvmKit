//
//  LPDPopupPickerView.h
//  FoxKit
//
//  Created by foxsofter on 15/10/9.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author foxsofter, 15-10-09 10:10:25
 *
 *  @brief  Show pupup picker view.
 */
@interface LPDPopupPickerView : NSObject

/**
 *  @brief  单选的pickerView，默认选择第一项
 *
 *  @param caption         标题，可为空
 *  @param arrayOfTitles 选项标题数组
 *  @param action        确定选择action block
 */
+ (void)show:(NSString *)caption
  arrayOfTitles:(NSArray<NSString *> *)arrayOfTitles
       okAction:(void (^)(NSUInteger selectedIndex))action;

/**
 *  @brief  单选的pickerView
 *
 *  @param caption         标题，可为空
 *  @param arrayOfTitles 选项标题数组
 *  @param selectedIndex 默认选中项索引
 *  @param action        确定选择action block
 */
+ (void)show:(NSString *)caption
  arrayOfTitles:(NSArray<NSString *> *)arrayOfTitles
  selectedIndex:(NSUInteger)selectedIndex
       okAction:(void (^)(NSUInteger selectedIndex))action;

/**
 *  @brief  两个组件的pickerView，默认都选择第一项
 *
 *  @param caption          标题，可为空
 *  @param arrayOfTitles1 第一组件选项标题数组
 *  @param arrayOfTitles2 第二组件选项标题数组
 *  @param action         确定选择action block
 */
+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
        okAction:(void (^)(NSUInteger selectedIndex1, NSUInteger selectedIndex2))action;

/**
 *  @brief  两个组件的pickerView
 *
 *  @param caption          标题，可为空
 *  @param arrayOfTitles1 第一组件选项标题数组
 *  @param selectedIndex1 第一组件默认选择索引
 *  @param arrayOfTitles2 第二组件选项标题数组
 *  @param selectedIndex2 第二组件默认选择索引
 *  @param action         确定选择action block
 */
+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  selectedIndex1:(NSUInteger)selectedIndex1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
  selectedIndex2:(NSUInteger)selectedIndex2
        okAction:(void (^)(NSUInteger selectedIndex1, NSUInteger selectedIndex2))action;

/**
 *  @brief  三个组件的pickerView，默认都选择第一项
 *
 *  @param caption          标题，可为空
 *  @param arrayOfTitles1 第一组件选项标题数组
 *  @param arrayOfTitles2 第二组件选项标题数组
 *  @param arrayOfTitles3 第三组件选项标题数组
 *  @param action         确定选择action block
 */
+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
  arrayOfTitles3:(NSArray<NSString *> *)arrayOfTitles3
        okAction:(void (^)(NSUInteger selectedIndex1, NSUInteger selectedIndex2, NSUInteger selectedIndex3))action;

/**
 *  @brief  三个组件的pickerView
 *
 *  @param caption          标题，可为空
 *  @param arrayOfTitles1 第一组件选项标题数组
 *  @param selectedIndex1 第一组件默认选择索引
 *  @param arrayOfTitles2 第二组件选项标题数组
 *  @param selectedIndex2 第二组件默认选择索引
 *  @param arrayOfTitles3 第三组件选项标题数组
 *  @param selectedIndex3 第三组件默认选择索引
 *  @param action         确定选择action block
 */
+ (void)show:(NSString *)caption
  arrayOfTitles1:(NSArray<NSString *> *)arrayOfTitles1
  selectedIndex1:(NSUInteger)selectedIndex1
  arrayOfTitles2:(NSArray<NSString *> *)arrayOfTitles2
  selectedIndex2:(NSUInteger)selectedIndex2
  arrayOfTitles3:(NSArray<NSString *> *)arrayOfTitles3
  selectedIndex3:(NSUInteger)selectedIndex3
        okAction:(void (^)(NSUInteger selectedIndex1, NSUInteger selectedIndex2, NSUInteger selectedIndex3))action;

+ (void)hide;

@end
