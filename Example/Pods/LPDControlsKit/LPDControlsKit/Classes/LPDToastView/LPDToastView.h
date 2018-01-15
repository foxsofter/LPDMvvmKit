//
//  LPDToastView.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/20.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPDToastView : UIButton

// parameters: title, hoverInterval, background color, text color

// without delegate
+ (void)show:(NSString *)title;

+ (void)show:(NSString *)title cornerRadius:(CGFloat)cornerRadius;

+ (void)show:(NSString *)title hoverInterval:(NSInteger)hoverInterval;

+ (void)show:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor;

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
     cornerRadius:(CGFloat)cornerRadius;

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval;

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     cornerRadius:(CGFloat)cornerRadius;

// with blcok
+ (void)show:(NSString *)title tappedAction:(void (^)(LPDToastView *toastView))action;

+ (void)show:(NSString *)title
cornerRadius:(CGFloat)cornerRadius
tappedAction:(void (^)(LPDToastView *toastView))action;

+ (void)show:(NSString *)title
  hoverInterval:(NSInteger)hoverInterval
   tappedAction:(void (^)(LPDToastView *toastView))action;

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
     tappedAction:(void (^)(LPDToastView *toastView))action;

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
     cornerRadius:(CGFloat)cornerRadius
     tappedAction:(void (^)(LPDToastView *toastView))action;

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     tappedAction:(void (^)(LPDToastView *toastView))action;

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     cornerRadius:(CGFloat)cornerRadius
     tappedAction:(void (^)(LPDToastView *toastView))action;

+ (void)show:(NSString *)title
backgroundColor:(UIColor *)backgroundColor
	textColor:(UIColor *)textColor
hoverInterval:(NSInteger)hoverInterval
cornerRadius:(CGFloat)cornerRadius
tappedAction:(void (^)(LPDToastView *toastView))action isTopWindow:(BOOL)isTop;

@end
