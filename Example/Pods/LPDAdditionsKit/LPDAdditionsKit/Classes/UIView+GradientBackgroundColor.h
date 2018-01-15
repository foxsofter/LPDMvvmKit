//
//  UIView+GradientBackgroundColor.h
//  LPDCrowdsource
//
//  Created by Assuner on 2017/8/26.
//  Copyright © 2017年 elm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GradientBackgroundColor)

typedef NS_ENUM(NSInteger, LPDGradientDirection) {
  LPDGradientDirectionTopLeft = 0,
  LPDGradientDirectionTop = 1,
  LPDGradientDirectionLeft = 2,
};

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)colorArray direction:(LPDGradientDirection)direction;

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)colorArray;

- (void)setGradientBackgroundColorFrom:(UIColor *)fromColor toColor:(UIColor *)toColor;

@end

