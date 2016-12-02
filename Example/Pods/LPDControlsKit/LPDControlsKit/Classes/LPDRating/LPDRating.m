//
//  LPDRating.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/9/28.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDRating.h"

@implementation LPDRating {
  CGFloat _minValue;
  NSUInteger _maxValue;
  CGFloat _value;
}

@dynamic minValue;
@dynamic maxValue;
@dynamic value;

#pragma mark - initialize

- (instancetype)init {
  self = [super init];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self initialize];
  }
  return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self initialize];
  }
  return self;
}

- (void)initialize {
  self.exclusiveTouch = YES;
  _minValue = 0.f;
  _maxValue = 5;
  _value = 0.f;
  _spacing = 5.f;
  _starStyle = LPDRatingStarStyleDefault;
}

#pragma mark - Properties

- (UIColor *)backgroundColor {
  if ([super backgroundColor]) {
    return [super backgroundColor];
  } else {
    return self.isOpaque ? [UIColor whiteColor] : [UIColor clearColor];
  };
}

- (CGFloat)minValue {
  return MAX(_minValue, 0);
}

- (void)setMinValue:(CGFloat)minValue {
  if (_minValue != minValue) {
    _minValue = minValue;
    [self setNeedsDisplay];
  }
}

- (NSUInteger)maxValue {
  return MAX(_minValue, _maxValue);
}

- (void)setMaxValue:(NSUInteger)maxValue {
  if (_maxValue != maxValue) {
    _maxValue = maxValue;
    [self setNeedsDisplay];
    [self invalidateIntrinsicContentSize];
  }
}

- (CGFloat)value {
  return MIN(MAX(_value, _minValue), _maxValue);
}

- (void)setValue:(CGFloat)value {
  [self setValue:value sendValueChangedAction:NO];
}

- (void)setValue:(CGFloat)value sendValueChangedAction:(BOOL)sendAction {
  if (_value != value && value >= _minValue && value <= _maxValue) {
    _value = value;
    if (sendAction)
      [self sendActionsForControlEvents:UIControlEventValueChanged];
    [self setNeedsDisplay];
  }
}

- (void)setSpacing:(CGFloat)spacing {
  _spacing = MAX(spacing, 0);
  [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawPrecisionStarShapeWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor highlighted:(BOOL)highlighted {
  [self drawPrecisionStarShapeWithFrame:frame tintColor:tintColor progress:highlighted ? 1.f : 0.f];
}

- (void)drawHalfStarShapeWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor {
  [self drawPrecisionStarShapeWithFrame:frame tintColor:tintColor progress:.5f];
}

- (void)drawPrecisionStarShapeWithFrame:(CGRect)frame tintColor:(UIColor *)tintColor progress:(CGFloat)progress {
  UIBezierPath *starShapePath = UIBezierPath.bezierPath;
  [starShapePath moveToPoint:CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame),
                                         CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.02500 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.37292 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.02500 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.30504 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.20642 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.50000 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.78265 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.79358 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.97500 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.69501 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.62908 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.97500 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.39112 * CGRectGetHeight(frame))];
  [starShapePath addLineToPoint:CGPointMake(CGRectGetMinX(frame) + 0.62723 * CGRectGetWidth(frame),
                                            CGRectGetMinY(frame) + 0.37309 * CGRectGetHeight(frame))];
  [starShapePath closePath];
  starShapePath.miterLimit = 4;

  CGFloat frameWidth = frame.size.width;
  CGRect rightRectOfStar = CGRectMake(frame.origin.x + progress * frameWidth, frame.origin.y,
                                      frameWidth - progress * frameWidth, frame.size.height);
  UIBezierPath *clipPath = [UIBezierPath bezierPathWithRect:CGRectInfinite];
  [clipPath appendPath:[UIBezierPath bezierPathWithRect:rightRectOfStar]];
  clipPath.usesEvenOddFillRule = YES;

  CGContextSaveGState(UIGraphicsGetCurrentContext());
  {
    [clipPath addClip];
    [tintColor setFill];
    [starShapePath fill];
  }
  CGContextRestoreGState(UIGraphicsGetCurrentContext());

  [tintColor setStroke];
  starShapePath.lineWidth = 1;
  [starShapePath stroke];
}

- (void)drawRect:(CGRect)rect {
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
  CGContextFillRect(context, rect);

  CGFloat availableWidth = rect.size.width - (_spacing * (_maxValue - 1));
  CGFloat cellWidth = (availableWidth / _maxValue);
  CGFloat starSide = (cellWidth <= rect.size.height) ? cellWidth : rect.size.height;
  for (int idx = 0; idx < _maxValue; idx++) {
    CGPoint center = CGPointMake(cellWidth * idx + cellWidth / 2 + _spacing * idx, rect.size.height / 2);
    CGRect frame = CGRectMake(center.x - starSide / 2, center.y - starSide / 2, starSide, starSide);
    BOOL highlighted = (idx + 1 <= ceilf(_value));
    if (highlighted && (idx + 1 > _value)) {
      if (_starStyle == LPDRatingStarStylePrecision) {
        [self drawPrecisionStarShapeWithFrame:frame tintColor:self.tintColor progress:_value - idx];
      } else {
        [self drawHalfStarShapeWithFrame:frame tintColor:self.tintColor];
      }
    } else {
      [self drawPrecisionStarShapeWithFrame:frame tintColor:self.tintColor highlighted:highlighted];
    }
  }
}

#pragma mark - Touches

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
  [super beginTrackingWithTouch:touch withEvent:event];
  if (![self isFirstResponder]) {
    [self becomeFirstResponder];
  }
  [self handleTouch:touch];
  return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
  [super continueTrackingWithTouch:touch withEvent:event];
  [self handleTouch:touch];
  return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
  [super endTrackingWithTouch:touch withEvent:event];
  if ([self isFirstResponder]) {
    [self resignFirstResponder];
  }
  [self handleTouch:touch];
  [self sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event {
  [super cancelTrackingWithEvent:event];
  if ([self isFirstResponder]) {
    [self resignFirstResponder];
  }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
  if ([gestureRecognizer.view isEqual:self]) {
    return !self.isUserInteractionEnabled;
  }
  return YES;
}

- (void)handleTouch:(UITouch *)touch {
  CGFloat cellWidth = self.bounds.size.width / _maxValue;
  CGPoint location = [touch locationInView:self];
  CGFloat value = location.x / cellWidth;
  switch (_starStyle) {
    case LPDRatingStarStyleDefault:
      value = ceilf(value);
      break;
    case LPDRatingStarStyleHalf:
      if (value + .5f < ceilf(value)) {
        value = floor(value) + .5f;
      } else {
        value = ceilf(value);
      }
      break;
    case LPDRatingStarStylePrecision:
      value = value;
      break;
  }

  [self setValue:value sendValueChangedAction:YES];
}

#pragma mark - First responder

- (BOOL)canBecomeFirstResponder {
  return YES;
}

#pragma mark - Intrinsic Content Size

- (CGSize)intrinsicContentSize {
  CGFloat height = 44.f;
  return CGSizeMake(_maxValue * height + (_maxValue - 1) * _spacing, height);
}

#pragma mark - Accessibility

- (BOOL)isAccessibilityElement {
  return YES;
}

- (NSString *)accessibilityLabel {
  return [super accessibilityLabel] ?: NSLocalizedString(@"Rating", @"Accessibility label for star rating control.");
}

- (UIAccessibilityTraits)accessibilityTraits {
  return ([super accessibilityTraits] | UIAccessibilityTraitAdjustable);
}

- (NSString *)accessibilityValue {
  return [@(self.value) description];
}

- (BOOL)accessibilityActivate {
  return YES;
}

- (void)accessibilityIncrement {
  self.value += _starStyle == LPDRatingStarStyleHalf ? .5f : 1.f;
}

- (void)accessibilityDecrement {
  self.value -= _starStyle == LPDRatingStarStyleHalf ? .5f : 1.f;
}

@end
