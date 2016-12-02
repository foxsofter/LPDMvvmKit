//
//  LPDToastView.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/20.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDLabel.h"
#import "LPDToastView.h"
#import "NSObject+LPDThread.h"
#import "UIScreen+LPDAccessor.h"

@interface LPDToastView ()

@property UIColor *defaultTextColor;

@property (nonatomic, strong) LPDLabel *toastLabel;

@property (nonatomic, copy) void (^tappedAction)(LPDToastView *toastView);

- (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     cornerRadius:(CGFloat)cornerRadius;

@end

static float const kAnimationInterval = .1;
static int const kHoverInterval = 2;

@implementation LPDToastView

+ (UIColor *)defaultBackgroundColor {
  return [[UIColor blackColor] colorWithAlphaComponent:0.7];
}

+ (UIColor *)defaultTextColor {
  return [UIColor whiteColor];
}

+ (CGFloat)defaultCornerRadius {
  return 4;
}

#pragma mark - Private Methods

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {

    self.backgroundColor = [self.class defaultBackgroundColor];
    self.layer.cornerRadius = [self.class defaultCornerRadius];

    _toastLabel = [[LPDLabel alloc] initWithFrame:CGRectZero];
    _toastLabel.font = [UIFont systemFontOfSize:16];
    _toastLabel.textColor = [self.class defaultTextColor];
    _toastLabel.textAlignment = NSTextAlignmentCenter;
    _toastLabel.numberOfLines = 0;
    _toastLabel.lineBreakMode = NSLineBreakByWordWrapping;

    [self addSubview:_toastLabel];

    [self addTarget:self action:@selector(hideView:) forControlEvents:UIControlEventTouchUpInside];
  }
  return self;
}

- (void)hideView:(UIView *)toastView {
  if (toastView) {
    [UIView animateWithDuration:0.6
      animations:^{
        self.alpha = 0;
        //        self.transform = CGAffineTransformMakeScale(0.1, 0.1);
      }
      completion:^(BOOL finished) {
        [self removeFromSuperview];
      }];
  }
}

+ (LPDToastView *)toastView {
  LPDToastView *toastView = [LPDToastView buttonWithType:UIButtonTypeCustom];
  return toastView;
}

+ (LPDToastView *)toastViewWithBlock:(void (^)(LPDToastView *))tappedAction {
  LPDToastView *toastView = [LPDToastView buttonWithType:UIButtonTypeCustom];
  toastView.tappedAction = tappedAction;
  return toastView;
}

#pragma mark - show methods

+ (void)show:(NSString *)title {
  [[self toastView] show:title backgroundColor:nil textColor:nil hoverInterval:0 cornerRadius:0];
}

+ (void)show:(NSString *)title cornerRadius:(CGFloat)cornerRadius {
  [[self toastView] show:title backgroundColor:nil textColor:nil hoverInterval:0 cornerRadius:cornerRadius];
}

+ (void)show:(NSString *)title hoverInterval:(NSInteger)hoverInterval {
  [[self toastView] show:title backgroundColor:nil textColor:nil hoverInterval:hoverInterval cornerRadius:0];
}

+ (void)show:(NSString *)title backgroundColor:(UIColor *)backgroundColor textColor:(UIColor *)textColor {
  [[self toastView] show:title backgroundColor:backgroundColor textColor:textColor hoverInterval:0 cornerRadius:0];
}

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
     cornerRadius:(CGFloat)cornerRadius {
  [[self toastView] show:title backgroundColor:backgroundColor textColor:textColor hoverInterval:0 cornerRadius:0];
}

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval {
  [[self toastView] show:title
         backgroundColor:backgroundColor
               textColor:textColor
           hoverInterval:hoverInterval
            cornerRadius:0];
}

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     cornerRadius:(CGFloat)cornerRadius {
  [[self toastView] show:title
         backgroundColor:backgroundColor
               textColor:textColor
           hoverInterval:hoverInterval
            cornerRadius:cornerRadius];
}

#pragma mark - show with block

+ (void)show:(NSString *)title tappedAction:(void (^)(LPDToastView *toastView))action {
  [[self toastViewWithBlock:action] show:title backgroundColor:nil textColor:nil hoverInterval:0 cornerRadius:0];
}

+ (void)show:(NSString *)title
cornerRadius:(CGFloat)cornerRadius
tappedAction:(void (^)(LPDToastView *toastView))action {
  [[self toastViewWithBlock:action] show:title
                         backgroundColor:nil
                               textColor:nil
                           hoverInterval:0
                            cornerRadius:cornerRadius];
}

+ (void)show:(NSString *)title
  hoverInterval:(NSInteger)hoverInterval
   tappedAction:(void (^)(LPDToastView *toastView))action {
  [[self toastViewWithBlock:action] show:title
                         backgroundColor:nil
                               textColor:nil
                           hoverInterval:hoverInterval
                            cornerRadius:0];
}

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
     tappedAction:(void (^)(LPDToastView *toastView))action {
  [[self toastViewWithBlock:action] show:title
                         backgroundColor:backgroundColor
                               textColor:textColor
                           hoverInterval:0
                            cornerRadius:0];
}

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
     cornerRadius:(CGFloat)cornerRadius
     tappedAction:(void (^)(LPDToastView *toastView))action {
  [[self toastViewWithBlock:action] show:title
                         backgroundColor:backgroundColor
                               textColor:textColor
                           hoverInterval:0
                            cornerRadius:cornerRadius];
}

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     tappedAction:(void (^)(LPDToastView *toastView))action {
  [[self toastViewWithBlock:action] show:title
                         backgroundColor:backgroundColor
                               textColor:textColor
                           hoverInterval:hoverInterval
                            cornerRadius:0];
}

+ (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     cornerRadius:(CGFloat)cornerRadius
     tappedAction:(void (^)(LPDToastView *toastView))action {
  [[self toastViewWithBlock:action] show:title
                         backgroundColor:backgroundColor
                               textColor:textColor
                           hoverInterval:hoverInterval
                            cornerRadius:cornerRadius];
}

- (void)show:(NSString *)title
  backgroundColor:(UIColor *)backgroundColor
        textColor:(UIColor *)textColor
    hoverInterval:(NSInteger)hoverInterval
     cornerRadius:(CGFloat)cornerRadius {
  _toastLabel.text =
    [title stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".。。．"]];
  CGSize constrain = CGSizeMake(240, FLT_MAX);
  CGSize titleSize =
    [title sizeWithFont:_toastLabel.font constrainedToSize:constrain lineBreakMode:NSLineBreakByWordWrapping];
  _toastLabel.frame = CGRectMake(0, 0, titleSize.width, titleSize.height);
  self.frame = CGRectMake(0, 0, titleSize.width + 20, titleSize.height + 16);
  [_toastLabel setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
  self.center = CGPointMake(UIScreen.width / 2, UIScreen.height / 2);
  self.layer.contentsScale = 0.1;
  if (backgroundColor) {
    self.backgroundColor = backgroundColor;
  }

  if (textColor) {
    _toastLabel.textColor = textColor;
  }

  NSInteger interval = hoverInterval > 0 ? hoverInterval : kHoverInterval;

  if (cornerRadius > 0) {
    self.layer.cornerRadius = cornerRadius;
  }

  if (!self.superview) {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];

    for (UIWindow *window in frontToBackWindows)
      if (window.windowLevel == UIWindowLevelNormal && !window.hidden) {
        [window addSubview:self];
        break;
      }
  }
  self.transform = CGAffineTransformMakeScale(0.1, 0.1);
  self.alpha = 0;
  [UIView animateWithDuration:kAnimationInterval
                   animations:^{
                     self.alpha = 1;
                     self.transform = CGAffineTransformMakeScale(1, 1);
                   }];
  //  NSLog(@"start time:%@", [NSDate date]);
  [self performSelector:@selector(hideView:) withObject:self afterDelay:interval + kAnimationInterval];
  //  NSLog(@"end time:%@", [NSDate date]);
  if (self.tappedAction) {
    __weak typeof(self) weakSelf = self;
    [self performBlock:^{
      weakSelf.tappedAction(weakSelf);
    }
            afterDelay:interval + kAnimationInterval];
  }
}

@end
