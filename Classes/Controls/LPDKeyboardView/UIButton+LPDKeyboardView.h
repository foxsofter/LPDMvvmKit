//
//  UIButton+LPDKeyboardView.h
//  LPDKeyboardView
//
//  Created by fox softer on 15/11/24.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (LPDKeyboardView)

+ (UIButton *)buttonWithCharStyle;

+ (UIButton *)buttonWithSpaceStyle;

+ (UIButton *)buttonWithCharControlStyle;

+ (UIButton *)buttonWithNumberStyle;

+ (UIButton *)buttonWithNumberControlStyle;

@end
