//
//  UIView+GradientBackgroundColor.m
//  LPDCrowdsource
//
//  Created by Assuner on 2017/8/26.
//  Copyright © 2017年 elm. All rights reserved.
//

#import "UIView+GradientBackgroundColor.h"

@implementation UIView (GradientBackgroundColor)

- (void)setGradientBackgroundColorFrom:(UIColor *)fromColor toColor:(UIColor *)toColor {
  if (fromColor && toColor) {
    [self setGradientBackgroundColors:@[fromColor, toColor]];
  }
}

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)colorArray {
  [self setGradientBackgroundColors:colorArray direction:LPDGradientDirectionTopLeft];
}

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)colorArray direction:(LPDGradientDirection)direction {
  if (!colorArray.count) {
    return;
  }
  NSMutableArray *CALayerArray = [[NSMutableArray alloc] initWithArray:self.layer.sublayers];
  for (CALayer *layer in CALayerArray) {
    if ([layer isKindOfClass:CAGradientLayer.class]) {
      [layer removeFromSuperlayer];
    }
  }
  CAGradientLayer *gradientLayer = [CAGradientLayer layer];
  gradientLayer.frame = self.bounds;
  switch (direction) {
    case LPDGradientDirectionTop: {
      gradientLayer.startPoint = CGPointMake(0.5, 0);
      gradientLayer.endPoint = CGPointMake(0.5, 1);
    } break;
      
    case LPDGradientDirectionLeft: {
      gradientLayer.startPoint = CGPointMake(0, 0.5);
      gradientLayer.endPoint = CGPointMake(1, 0.5);
    } break;
      
    case LPDGradientDirectionTopLeft:
    default:{
      gradientLayer.startPoint = CGPointMake(0, 0);
      gradientLayer.endPoint = CGPointMake(1, 1);
    } break;
  }
  gradientLayer.cornerRadius = self.layer.cornerRadius;
  NSMutableArray *CGColorArray = [[NSMutableArray alloc] init];
  for (UIColor *color in colorArray) {
    [CGColorArray addObject:(__bridge id)color.CGColor];
  }
  gradientLayer.colors = CGColorArray;
  [self.layer insertSublayer:gradientLayer atIndex:0];
}

@end

