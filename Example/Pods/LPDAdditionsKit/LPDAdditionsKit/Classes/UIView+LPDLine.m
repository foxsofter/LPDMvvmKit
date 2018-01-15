//
//  UIView+LPDLine.m
//  LPDCrowdsource
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 elm. All rights reserved.
//

#import "UIView+LPDLine.h"
#import <CoreGraphics/CGColor.h>

@implementation UIView (LPDLine)


- (CAShapeLayer *)addBezierLine:(UIBezierPath *)bezierLine color:(UIColor *)lineColor {
  CAShapeLayer *lineLayer = [CAShapeLayer layer];
  lineLayer.path = bezierLine.CGPath;
  lineLayer.strokeColor = lineColor.CGColor;
  lineLayer.lineWidth = 1.0/[UIScreen mainScreen].scale;
  [self.layer addSublayer:lineLayer];
  return lineLayer;
}

- (CAShapeLayer *)addDottedLine:(CGPoint)startLine endPoint:(CGPoint)endPoint color:(UIColor *)lineColor {
  UIBezierPath *bezierLine = [UIBezierPath bezierPath];
  [bezierLine moveToPoint:startLine];
  [bezierLine addLineToPoint:endPoint];
  bezierLine.lineWidth = 1.0/[UIScreen mainScreen].scale;
  CAShapeLayer *lineLayer = [CAShapeLayer layer];
  lineLayer.path = bezierLine.CGPath;
  lineLayer.strokeColor = lineColor.CGColor;
  lineLayer.lineWidth = 1.0/[UIScreen mainScreen].scale;
  lineLayer.lineDashPattern = @[@(8),@(2)];
  [self.layer addSublayer:lineLayer];
  return lineLayer;
}

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius {
  
  UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
  CAShapeLayer *maskLayer = [CAShapeLayer layer];
  maskLayer.frame = self.bounds;
  maskLayer.path = maskPath.CGPath;
  self.layer.mask = maskLayer;
  return maskLayer;
}


- (CAShapeLayer *)addLine:(CGPoint)startPoint endPoint:(CGPoint)endPoint color:(UIColor *)lineColor {
  return [self addLine:startPoint endPoint:endPoint lineWidth: 1.0/[UIScreen mainScreen].scale color:lineColor];
}

- (CAShapeLayer *)addLine:(CGPoint)startLine endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth color:(UIColor *)lineColor {
  UIBezierPath *bezierLine = [UIBezierPath bezierPath];
  [bezierLine moveToPoint:startLine];
  [bezierLine addLineToPoint:endPoint];
  bezierLine.lineWidth = lineWidth;
  CAShapeLayer *lineLayer = [CAShapeLayer layer];
  lineLayer.path = bezierLine.CGPath;
  lineLayer.strokeColor = lineColor.CGColor;
  lineLayer.lineWidth = lineWidth;
  [self.layer addSublayer:lineLayer];
  return lineLayer;
}

static CGFloat FBRoundPixelValue(CGFloat value)
{
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^(){
        scale = [UIScreen mainScreen].scale;
    });
    
    return round(value * scale) / scale;
}

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius color:(UIColor *)borderColor {
  
  return [self addCornerRadius:cornerRadius lineWidth:1.0/[UIScreen mainScreen].scale color:borderColor] ;
}

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth color:(UIColor *)borderColor {
  return [self addCornerRadius:cornerRadius lineWidth:lineWidth color:borderColor backgroundColor:[UIColor clearColor] ];
}

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth color:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor{
    CGRect rect = CGRectMake(FBRoundPixelValue(self.bounds.origin.x), FBRoundPixelValue(self.bounds.origin.y), FBRoundPixelValue(self.bounds.size.width), FBRoundPixelValue(self.bounds.size.height));
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    maskLayer.strokeColor = borderColor.CGColor;
    maskLayer.fillColor = backgroundColor.CGColor;
    maskLayer.lineWidth = lineWidth;
    [self.layer insertSublayer:maskLayer above:self.layer];
    return maskLayer;
}



@end
