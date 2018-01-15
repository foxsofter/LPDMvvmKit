//
//  UIView+LPDLine.h
//  LPDCrowdsource
//
//  Created by 沈强 on 16/3/30.
//  Copyright © 2016年 elm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LPDLine)

/**
 *  划各种线 和分割线
 *
 *  
 */
- (CAShapeLayer *)addBezierLine:(UIBezierPath *)bezierLine color:(UIColor *)lineColor;

- (CAShapeLayer *)addDottedLine:(CGPoint)startLine endPoint:(CGPoint)endPoint color:(UIColor *)lineColor;

- (CAShapeLayer *)addLine:(CGPoint)startLine endPoint:(CGPoint)endPoint color:(UIColor *)lineColor;

- (CAShapeLayer *)addLine:(CGPoint)startLine endPoint:(CGPoint)endPoint lineWidth:(CGFloat)lineWidth color:(UIColor *)lineColor;

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius;

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius color:(UIColor *)borderColor;

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth color:(UIColor *)borderColor;

- (CAShapeLayer *)addCornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth color:(UIColor *)borderColor backgroundColor:(UIColor *)backgroundColor;

@end

NS_ASSUME_NONNULL_END
