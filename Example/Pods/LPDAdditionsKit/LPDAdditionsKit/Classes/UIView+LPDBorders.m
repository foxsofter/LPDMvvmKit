//
//  UIView+LPDBorders.m
//  LPDAdditions
//
//  Created by foxsofter on 15/10/21.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

@import CoreGraphics;

#import "NSObject+LPDAssociatedObject.h"
#import "NSObject+LPDSwizzling.h"
#import "UIView+LPDAccessor.h"
#import "UIView+LPDBorders.h"

@interface UIView ()

@property (nonatomic, strong) UIColor *borderColor;
@property (assign) CGFloat borderWidth;
@property (assign) LPDUIViewBorderPosition borderPosition;
@property (assign) LPDUIViewBorderType borderType;

@property (nonatomic, strong) CAShapeLayer *borderLayer;

@end

@implementation UIView (LPDBorders)

#pragma mark - life cycle

+ (void)load {
  //  [self instanceSwizzle:@selector(drawRect:) newSelector:@selector(_drawRect:)];
}

#pragma mark - public methods

- (void)setBorder:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
  [self setBorder:borderWidth borderColor:borderColor borderType:LPDUIViewBorderTypeSolid];
}

- (void)setBorder:(CGFloat)borderWidth borderColor:(UIColor *)borderColor borderType:(LPDUIViewBorderType)borderType {
  [self setBorder:borderWidth
       borderColor:borderColor
    borderPosition:LPDUIViewBorderPositionTop | LPDUIViewBorderPositionRight | LPDUIViewBorderPositionBottom |
                   LPDUIViewBorderPositionLeft
        borderType:borderType];
}

- (void)setBorder:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor
   borderPosition:(LPDUIViewBorderPosition)borderPosition {
  [self setBorder:borderWidth
       borderColor:borderColor
    borderPosition:borderPosition
        borderType:LPDUIViewBorderTypeSolid];
}

- (void)setBorder:(CGFloat)borderWidth
      borderColor:(UIColor *)borderColor
   borderPosition:(LPDUIViewBorderPosition)borderPosition
       borderType:(LPDUIViewBorderType)borderType {
  self.borderWidth = borderWidth;
  self.borderColor = borderColor;
  self.borderPosition = borderPosition;
  self.borderType = borderType;
  self.clipsToBounds = YES;
  [self drawBorders];
}

#pragma mark - private methods

- (void)_drawRect:(CGRect)rect {
  [self _drawRect:rect];
  [self drawBorders];
}

//  由于受限于CG的优化几只，在drawRect中实现并不会被调用，只能想其他办法了
//- (void)_drawRect:(CGRect)rect {
//  [self _drawRect:rect];
//  if (self.borderWidth == 0 ||
//      CGColorEqualToColor(self.borderColor.CGColor,
//                          [UIColor clearColor].CGColor) ||
//      self.borderPosition == LPDUIViewBorderPositionNone) {
//    return;
//  }
//  NSLog(@"11111");
//  CGContextRef context = UIGraphicsGetCurrentContext();
//
//  CGContextSetLineWidth(context, self.borderWidth);
//  CGContextSetStrokeColorWithColor(context, self.borderColor.CGColor);
//  if (self.borderType == LPDUIViewBorderTypeDashed) {
//    CGFloat dashedLinesLength[] = {4 * self.borderWidth, 4 *
//    self.borderWidth};
//    CGContextSetLineDash(context, 0.0f, dashedLinesLength, 2);
//    CGContextSetLineCap(context, kCGLineCapSquare);
//  } else if (self.borderType == LPDUIViewBorderTypeDoted) {
//    CGFloat dashedLinesLength[] = {self.borderWidth / 5, 2 *
//    self.borderWidth};
//
//    CGContextSetLineDash(context, 0.0f, dashedLinesLength, 2);
//    CGContextSetLineCap(context, kCGLineCapRound);
//  }
//
//  CGFloat minX = CGRectGetMinX(rect);
//  CGFloat maxX = CGRectGetMaxX(rect);
//
//  CGFloat minY = CGRectGetMinY(rect);
//  CGFloat maxY = CGRectGetMaxY(rect);
//
//  if (self.borderPosition & LPDUIViewBorderPositionTop) {
////    CGContextAddRect(context,
////                     CGRectMake(minX, minY, self.width, self.borderWidth));
//    CGContextMoveToPoint(context, minX, minY + self.borderWidth / 2);
//    CGContextAddLineToPoint(context, maxX, minY + self.borderWidth / 2);
//  }
//  if (self.borderPosition & LPDUIViewBorderPositionRight) {
////    CGContextAddRect(context, CGRectMake(maxX - self.borderWidth, minY,
////                                         self.borderWidth, self.height));
//
//    CGContextMoveToPoint(context, maxX - self.borderWidth / 2, minY);
//    CGContextAddLineToPoint(context, maxX - self.borderWidth / 2, maxY);
//  }
//  if (self.borderPosition & LPDUIViewBorderPositionBottom) {
////    CGContextAddRect(context, CGRectMake(minY, maxY - self.borderWidth,
////                                         self.width, self.borderWidth));
//    CGContextMoveToPoint(context, minX, maxY - self.borderWidth / 2);
//    CGContextAddLineToPoint(context, maxX, maxY - self.borderWidth / 2);
//  }
//  if (self.borderPosition & LPDUIViewBorderPositionLeft) {
////    CGContextAddRect(context,
////                     CGRectMake(minX, minY, self.borderWidth, self.height));
//    CGContextMoveToPoint(context, minX + self.borderWidth / 2, minY);
//    CGContextAddLineToPoint(context, minX + self.borderWidth / 2, maxY);
//  }
//  CGContextStrokePath(context);
//  CGContextClosePath(context);
//  NSLog(@"2222");
//}

- (void)drawBorders {
  if (self.borderWidth == 0 || CGColorEqualToColor(self.borderColor.CGColor, [UIColor clearColor].CGColor) ||
      self.borderPosition == LPDUIViewBorderPositionNone) {
    return;
  }
  if (self.borderLayer) {
    [self.borderLayer removeFromSuperlayer];
  }

  self.borderLayer = [CAShapeLayer layer];
  self.borderLayer.lineWidth = self.borderWidth;
  self.borderLayer.strokeColor = self.borderColor.CGColor;
  if (self.borderType == LPDUIViewBorderTypeDashed) {
    [self.borderLayer setLineCap:kCALineCapSquare];
    [self.borderLayer setLineDashPattern:@[@(2 * self.borderWidth), @(4 * self.borderWidth)]];
    [self.borderLayer setLineDashPhase:0.0f];
  } else if (self.borderType == LPDUIViewBorderTypeDoted) {
    [self.borderLayer setLineCap:kCALineCapRound];
    [self.borderLayer setLineDashPattern:@[@(self.borderWidth / 4), @(2 * self.borderWidth)]];
    [self.borderLayer setLineDashPhase:0.0f];
  }

  CGMutablePathRef path = CGPathCreateMutable();

  CGFloat minX = CGRectGetMinX(self.bounds);
  CGFloat maxX = CGRectGetMaxX(self.bounds);

  CGFloat minY = CGRectGetMinY(self.bounds);
  CGFloat maxY = CGRectGetMaxY(self.bounds);

  if (self.borderPosition & LPDUIViewBorderPositionTop) {
    CGPathMoveToPoint(path, NULL, minX, minY + self.borderWidth / 2);
    CGPathAddLineToPoint(path, NULL, maxX, minY + self.borderWidth / 2);
  }
  if (self.borderPosition & LPDUIViewBorderPositionRight) {
    CGPathMoveToPoint(path, NULL, maxX - self.borderWidth / 2, minY);
    CGPathAddLineToPoint(path, NULL, maxX - self.borderWidth / 2, maxY);
  }
  if (self.borderPosition & LPDUIViewBorderPositionBottom) {
    CGPathMoveToPoint(path, NULL, minX, maxY - self.borderWidth / 2);
    CGPathAddLineToPoint(path, NULL, maxX, maxY - self.borderWidth / 2);
  }
  if (self.borderPosition & LPDUIViewBorderPositionLeft) {
    CGPathMoveToPoint(path, NULL, minX + self.borderWidth / 2, minY);
    CGPathAddLineToPoint(path, NULL, minX + self.borderWidth / 2, maxY);
  }
  [self.borderLayer setPath:path];
  CGPathRelease(path);
  [self.layer addSublayer:self.borderLayer];
}

#pragma mark - properties

- (CGFloat)borderWidth {
  return [[self object:@selector(setBorderWidth:)] floatValue];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
  [self setRetainNonatomicObject:@(borderWidth) withKey:@selector(setBorderWidth:)];
}

- (UIColor *)borderColor {
  return [self object:@selector(setBorderColor:)];
}

- (void)setBorderColor:(UIColor *)borderColor {
  [self setRetainNonatomicObject:borderColor withKey:@selector(setBorderColor:)];
}

- (LPDUIViewBorderPosition)borderPosition {
  return [[self object:@selector(setBorderPosition:)] integerValue];
}

- (void)setBorderPosition:(LPDUIViewBorderPosition)borderPosition {
  [self setRetainNonatomicObject:@(borderPosition) withKey:@selector(setBorderPosition:)];
}

- (LPDUIViewBorderType)borderType {
  return [[self object:@selector(setBorderType:)] integerValue];
}

- (void)setBorderType:(LPDUIViewBorderType)borderType {
  [self setRetainNonatomicObject:@(borderType) withKey:@selector(setBorderType:)];
}

- (CAShapeLayer *)borderLayer {
  return [self object:@selector(setBorderLayer:)];
}

- (void)setBorderLayer:(CAShapeLayer *)borderLayer {
  [self setRetainNonatomicObject:borderLayer withKey:@selector(setBorderLayer:)];
}

@end
