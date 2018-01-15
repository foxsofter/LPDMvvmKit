//
//  UIView+CornerRadii.m
//  LPDCrowdsource
//
//  Created by eMr.Wang on 16/1/29.
//  Copyright © 2016年 elm. All rights reserved.
//

#import "UIView+CornerRadii.h"

@implementation UIView (CornerRadii)

// 指定倒角
- (void)setCornerRadii:(CGFloat)cornerRadii roundingCorners:(UIRectCorner)roundingCorners {
  if (self.layer.mask) {
    self.layer.mask = nil;
  }
  self.layer.masksToBounds = YES;
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                 byRoundingCorners:roundingCorners
                                                       cornerRadii:CGSizeMake(cornerRadii, cornerRadii)];
  CAShapeLayer *maskLayer = [CAShapeLayer layer];
  maskLayer.frame = self.bounds;
  maskLayer.path = maskPath.CGPath;
  self.layer.mask = maskLayer;
}

@end