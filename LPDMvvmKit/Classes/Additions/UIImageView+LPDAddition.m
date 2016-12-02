//
//  UIImageView+LPDAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/10/21.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

@import QuartzCore;
@import GLKit;
@import UIKit;

#import "AFImageDownloader.h"
#import "NSObject+LPDAssociatedObject.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIColor+LPDAddition.h"
#import "UIImageView+AFNetworking.h"
#import "UIImageView+LPDAddition.h"
#import "UIView+LPDAccessor.h"

@interface UIImageView ()

@property (nonatomic, strong) CAShapeLayer *circleProgressLineLayer;
@property (nonatomic, strong) CAShapeLayer *circleBackgroundLineLayer;

@end

@implementation UIImageView (LPDAddition)

#pragma mark - public methods

+ (UIImage *)cacheImageFromUrl:(NSString *)url {
  return [[UIImageView sharedImageDownloader]
            .imageCache imageforRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
               withAdditionalIdentifier:nil];
}

- (void)setImageUrl:(NSString *)url {
  if (!url || url.length == 0) {
    return;
  }
  @weakify(self);
  [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
              placeholderImage:nil
                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                         @strongify(self);
                         if (self) {
                           self.image = image;
                         }
                       }
                       failure:nil];
}

- (void)setImageUrl:(NSString *)url withDuration:(NSTimeInterval)duration {
  if (!url || url.length == 0) {
    return;
  }
  @weakify(self);
  [self setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
              placeholderImage:nil
                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                         @strongify(self);
                         if (self) {
                           [UIView transitionWithView:self
                                             duration:0.3
                                              options:UIViewAnimationOptionTransitionCrossDissolve
                                           animations:^{
                                             @strongify(self);
                                             if (self) {
                                               self.image = image;
                                             }
                                           }
                                           completion:nil];
                         }
                       }
                       failure:nil];
}

- (void)setCircleImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
  [self setCircleImageWithURL:url placeholderImage:placeholderImage borderWidth:1 borderColor:[UIColor whiteColor]];
}

- (void)setCircleImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholderImage
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor {
  [self setCircleImageWithURL:url
             placeholderImage:placeholderImage
                  borderWidth:borderWidth
                  borderColor:borderColor
                 showProgress:NO];
}

- (void)setCircleImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholderImage
                 showProgress:(BOOL)showProgress {
  [self setCircleImageWithURL:url
             placeholderImage:placeholderImage
                  borderWidth:1
                  borderColor:[UIColor whiteColor]
                 showProgress:showProgress];
}

- (void)setCircleImageWithURL:(NSURL *)url
             placeholderImage:(UIImage *)placeholderImage
                  borderWidth:(CGFloat)borderWidth
                  borderColor:(UIColor *)borderColor
                 showProgress:(BOOL)showProgress {
  self.layer.masksToBounds = YES;
  self.clipsToBounds = YES;
  self.layer.borderWidth = 0;
  self.layer.cornerRadius = fminf(self.height, self.width) / 2.0f;

  if (showProgress) {
    [self setupProgressCircle:borderWidth borderColor:borderColor];
    [self setupBackgroundCircle:borderWidth borderColor:borderColor.antiColor];
  } else {
    [self setupBackgroundCircle:borderWidth borderColor:borderColor];
  }

  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];

  @weakify(self);
  [self setImageWithURLRequest:request
    placeholderImage:placeholderImage
    success:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, UIImage *_Nonnull image) {
      @strongify(self)[UIView transitionWithView:self
        duration:0.3
        options:UIViewAnimationOptionTransitionCrossDissolve
        animations:^{
          @strongify(self);
          self.image = image;
        }
        completion:^(BOOL finished) {
          @strongify(self);
          [self clearCircleProgressLineLayer];
        }];
    }
    failure:^(NSURLRequest *_Nonnull request, NSHTTPURLResponse *_Nullable response, NSError *_Nonnull error) {
      @strongify(self);
      [self clearCircleProgressLineLayer];
    }];
}

#pragma mark - private methods

- (void)setupBackgroundCircle:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
  CGFloat radius = fminf(self.height, self.width) / 2.0f;
  CGPoint center = CGPointMake(radius, radius);
  self.circleBackgroundLineLayer = [CAShapeLayer layer];
  self.circleBackgroundLineLayer.bounds = self.bounds;
  self.circleBackgroundLineLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
  UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:(radius)
                                                        startAngle:GLKMathDegreesToRadians(0.0f)
                                                          endAngle:GLKMathDegreesToRadians(360.0f)
                                                         clockwise:YES];

  self.circleBackgroundLineLayer.path = circlePath.CGPath;
  circlePath = nil;
  self.circleBackgroundLineLayer.strokeColor = borderColor.CGColor;
  self.circleBackgroundLineLayer.lineWidth = borderWidth;
  self.circleBackgroundLineLayer.fillColor = [UIColor clearColor].CGColor;

  [[self layer] insertSublayer:self.circleBackgroundLineLayer below:self.circleProgressLineLayer];
}

- (void)setupProgressCircle:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
  CGFloat radius = fminf(self.height, self.width) / 2.0f;
  CGPoint center = CGPointMake(radius, radius);

  UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:(radius)
                                                        startAngle:GLKMathDegreesToRadians(-45.0f)
                                                          endAngle:GLKMathDegreesToRadians(275.0f)
                                                         clockwise:YES];

  self.circleProgressLineLayer = [CAShapeLayer layer];
  self.circleProgressLineLayer.bounds = self.bounds;
  self.circleProgressLineLayer.position = self.center;
  self.circleProgressLineLayer.path = circlePath.CGPath;
  self.circleProgressLineLayer.strokeColor = borderColor.CGColor;
  self.circleProgressLineLayer.fillColor = [UIColor clearColor].CGColor;
  self.circleProgressLineLayer.lineWidth = borderWidth;
  self.circleProgressLineLayer.lineCap = kCALineCapRound;
  self.circleProgressLineLayer.lineJoin = kCALineJoinBevel;

  [self.layer addSublayer:self.circleProgressLineLayer];

  [self.circleProgressLineLayer removeAllAnimations];
  [self animateCircleWithInfiniteLoop];
}

- (void)clearCircleProgressLineLayer {
  [self.circleBackgroundLineLayer removeFromSuperlayer];
  [self setupBackgroundCircle:self.circleProgressLineLayer.lineWidth
                  borderColor:[UIColor colorWithCGColor:self.circleProgressLineLayer.strokeColor]];
  [self.circleProgressLineLayer removeFromSuperlayer];
}

- (void)animateCircleWithInfiniteLoop {
  CABasicAnimation *rotationAnimation;
  rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
  rotationAnimation.toValue = @(M_PI * 2.0f * 1.0);
  rotationAnimation.duration = 1.0;
  rotationAnimation.cumulative = YES;
  rotationAnimation.repeatCount = INFINITY;
  rotationAnimation.fillMode = kCAFillModeForwards;
  rotationAnimation.autoreverses = NO;

  [self.circleProgressLineLayer addAnimation:rotationAnimation forKey:@"rotate"];
}

- (void)setupMotionEffect {
  UIInterpolatingMotionEffect *xAxis =
    [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis keyPath:@"center.x"];
  UIInterpolatingMotionEffect *yAxis =
    [self motionEffectWithType:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis keyPath:@"center.y"];
  UIMotionEffectGroup *group = [[UIMotionEffectGroup alloc] init];
  group.motionEffects = @[xAxis, yAxis];

  [self addMotionEffect:group];
}

- (UIInterpolatingMotionEffect *)motionEffectWithType:(UIInterpolatingMotionEffectType)motionEffectType
                                              keyPath:(NSString *)keypath {
  UIInterpolatingMotionEffect *motionEffect =
    [[UIInterpolatingMotionEffect alloc] initWithKeyPath:keypath type:motionEffectType];
  motionEffect.minimumRelativeValue = @(-10);
  motionEffect.maximumRelativeValue = @(10);

  return motionEffect;
}

#pragma mark - properties

- (CAShapeLayer *)circleProgressLineLayer {
  return [self object:@selector(setCircleProgressLineLayer:)];
}

- (void)setCircleProgressLineLayer:(CAShapeLayer *)circleProgressLineLayer {
  [self setRetainNonatomicObject:circleProgressLineLayer withKey:@selector(setCircleProgressLineLayer:)];
}

- (CAShapeLayer *)circleBackgroundLineLayer {
  return [self object:@selector(setCircleBackgroundLineLayer:)];
}

- (void)setCircleBackgroundLineLayer:(CAShapeLayer *)circleBackgroundLineLayer {
  [self setRetainNonatomicObject:circleBackgroundLineLayer withKey:@selector(setCircleBackgroundLineLayer:)];
}

@end
