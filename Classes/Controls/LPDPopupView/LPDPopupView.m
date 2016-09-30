//
//  LPDPopupView.m
//  FoxKit
//
//  Created by foxsofter on 15/10/8.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDPopupView.h"
#import <ReactiveCocoa/RACEXTScope.h>
#import "UIColor+LPDAddition.h"
#import "UIView+LPDAccessor.h"

@implementation UIColor (LPDPopupView)

colorFromStringImpl(labelFont, @"#777");
colorFromStringImpl(popupViewBackground, @"FEFEFEFE");
colorFromStringImpl(primaryFont, @"#333");
colorFromStringImpl(primaryBackground, @"#333");
colorFromStringImpl(primaryTint, @"#FFDD00");

@end

@interface LPDPopupView ()

@property (nonatomic, strong, readwrite) UIView *contentView;

@end

@implementation LPDPopupView

static LPDPopupView *_popupView;

#pragma mark - public methods

+ (void)show:(UIView *)contentView {
  if (_popupView) { // 如果已显示一个view，先清理
    [_popupView clear];
  }
  [[LPDPopupView popupView] show:contentView];
}

+ (void)hide {
  [[LPDPopupView popupView] hide];
}

#pragma mark - life cycle

- (void)show:(UIView *)contentView {
  _showing = YES;
  _contentView = contentView;
  [_contentView.layer setShadowColor:[UIColor blackColor].CGColor];
  [_contentView.layer setShadowOpacity:0.8];
  [_contentView.layer setShadowRadius:3.0];
  [_contentView.layer setShadowOffset:CGSizeMake(1.0, 2.0)];
  [self addSubview:_contentView];
  _contentView.frame = CGRectMake(0, self.height - _contentView.height, self.width, _contentView.height);
  [self.superview setAlpha:1.0];

  [_contentView setTransform:CGAffineTransformMakeTranslation(0, _contentView.height)];
  @weakify(self)[UIView animateWithDuration:0.3
                                 animations:^{
                                   @strongify(self)[self.superview setAlpha:0.8];
                                   [self.contentView setAlpha:1.0];
                                   [self.contentView setTransform:CGAffineTransformIdentity];
                                 }
                                 completion:nil];
}

- (void)hide {
  @weakify(self)[UIView animateWithDuration:0.3
    animations:^{
      @strongify(self);
      [self.superview setAlpha:1.0];
      [_contentView setTransform:CGAffineTransformTranslate(CGAffineTransformIdentity, 0, _contentView.height)];
    }
    completion:^(BOOL finished) {
      @strongify(self)[_contentView removeFromSuperview];
      _contentView = nil;
      [self removeFromSuperview];
      _popupView = nil;
      _showing = NO;
    }];
}

/**
 *  @brief  如果背景视图被触碰，则隐藏
 *
 *  @param touches
 *  @param event
 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  NSSet<UITouch *> *touchs = [event touchesForView:self];
  if (touchs.count > 0) {
    [self hide];
  }
}

#pragma mark - private methods

- (void)clear {
  [self.superview setAlpha:1.0];
  [_contentView removeFromSuperview];
  _contentView = nil;
  [self removeFromSuperview];
  _popupView = nil;
}

#pragma mark - getters & setters

+ (LPDPopupView *)popupView {
  if (nil == _popupView) {
    _popupView = [[LPDPopupView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _popupView.backgroundColor = [UIColor clearColor];

    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];

    for (UIWindow *window in frontToBackWindows) {
      if (window.windowLevel == UIWindowLevelNormal && !window.hidden) {
        [window addSubview:LPDPopupView.popupView];
        break;
      }
    }
  }

  return _popupView;
}

@end
