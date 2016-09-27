//
//  LPDKeyButtonPopupView.m
//  FoxKit
//
//  Created by ZhongDanWei on 15/11/30.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDKeyButtonPopupView.h"
#import "TurtleBezierPath.h"

@interface LPDKeyButtonPopupView ()

@property (nonatomic, weak) UIButton *keyButton;

@end

@implementation LPDKeyButtonPopupView

#pragma mark - life cycle

- (instancetype)initWithKeyboardButton:(UIButton *)keyButton {
  self = [super initWithFrame:[UIScreen mainScreen].bounds];
  if (self) {
    _keyButton = keyButton;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
  }
  return self;
}

- (void)didMoveToWindow {
  [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
  // Generate the overlay
  UIBezierPath *bezierPath = [self popupViewPath];
  NSString *inputString = self.keyButton.accessibilityIdentifier;

  // Position the overlay
  CGRect keyRect = [self convertRect:self.keyButton.frame fromView:self.keyButton.superview];

  CGContextRef context = UIGraphicsGetCurrentContext();
  UIColor *backgroundColor = [UIColor colorWithCGColor:self.keyButton.layer.backgroundColor];
  // Overlay path & shadow
  {
    //// Shadow Declarations
    UIColor *shadow = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    CGSize shadowOffset = CGSizeMake(0, 0.5);
    CGFloat shadowBlurRadius = 2;

    //// Rounded Rectangle Drawing
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    [backgroundColor setFill];
    [bezierPath fill];
    CGContextRestoreGState(context);
  }

  // Draw the key shadow sliver
  {
    UIColor *shadowColor = [UIColor colorWithCGColor:self.keyButton.layer.shadowColor];
    CGSize shadowOffset = CGSizeMake(0.1, 1.1);
    CGFloat shadowBlurRadius = 0;

    //// Rounded Rectangle Drawing
    UIBezierPath *roundedRectanglePath =
      [UIBezierPath bezierPathWithRoundedRect:CGRectMake(keyRect.origin.x, keyRect.origin.y, keyRect.size.width,
                                                         keyRect.size.height - 1)
                                 cornerRadius:4];
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadowColor.CGColor);
    [backgroundColor setFill];
    [roundedRectanglePath fill];

    CGContextRestoreGState(context);
  }

  // Text drawing
  {
    UIColor *textColor = self.keyButton.titleLabel.textColor;

    CGRect textRect = bezierPath.bounds;

    NSMutableParagraphStyle *p = [NSMutableParagraphStyle new];
    p.alignment = NSTextAlignmentCenter;

    NSAttributedString *attributedString =
      [[NSAttributedString alloc] initWithString:inputString
                                      attributes:@{
                                        NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:44],
                                        NSForegroundColorAttributeName: textColor,
                                        NSParagraphStyleAttributeName: p
                                      }];
    [attributedString drawInRect:textRect];
  }
}

#pragma mark - Internal

- (UIBezierPath *)popupViewPath {
  CGRect keyRect = [self convertRect:self.keyButton.frame fromView:self.keyButton.superview];

  UIEdgeInsets insets = UIEdgeInsetsMake(7, 13, 7, 13);
  CGFloat upperWidth = CGRectGetWidth(self.keyButton.frame) + insets.left + insets.right;
  CGFloat lowerWidth = CGRectGetWidth(self.keyButton.frame);
  CGFloat majorRadius = 10.f;
  CGFloat minorRadius = 4.f;

  TurtleBezierPath *path = [TurtleBezierPath new];
  [path home];
  path.lineWidth = 0;
  path.lineCapStyle = kCGLineCapRound;

  [path rightArc:majorRadius turn:90];
  [path forward:upperWidth - 2 * majorRadius];
  [path rightArc:majorRadius turn:90];
  [path forward:CGRectGetHeight(keyRect) - 2 * majorRadius + insets.top + insets.bottom];
  [path rightArc:majorRadius turn:48];
  [path forward:8.5f];
  [path leftArc:majorRadius turn:48];
  [path forward:CGRectGetHeight(keyRect) - 8.5f + 1];
  [path rightArc:minorRadius turn:90];
  [path forward:lowerWidth - 2 * minorRadius];
  [path rightArc:minorRadius turn:90];
  [path forward:CGRectGetHeight(keyRect) - 2 * minorRadius];
  [path leftArc:majorRadius turn:48];
  [path forward:8.5f];
  [path rightArc:majorRadius turn:48];

  CGFloat offsetX = 0, offsetY = 0;
  CGRect pathBoundingBox = path.bounds;

  offsetX = CGRectGetMidX(keyRect) - CGRectGetMidX(path.bounds);
  offsetY = CGRectGetMaxY(keyRect) - CGRectGetHeight(pathBoundingBox) + 10;

  [path applyTransform:CGAffineTransformMakeTranslation(offsetX, offsetY)];

  return path;
}

@end
