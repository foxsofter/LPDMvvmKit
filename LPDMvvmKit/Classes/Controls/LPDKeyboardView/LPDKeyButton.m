//
//  LPDKeyButton.m
//  FoxKit
//
//  Created by ZhongDanWei on 15/12/1.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDKeyButton.h"
#import "LPDKeyButtonPopupView.h"

@interface LPDKeyButton ()

@end

@implementation LPDKeyButton

#pragma mark - events

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//  if (self.popupView.superview) {
//    [self.popupView removeFromSuperview];
//  }
//  [self.window addSubview:self.popupView];
//
//  [super touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//  UITouch *touch = [touches anyObject];
//  CGPoint position = [touch locationInView:self];
//  if (![self pointInside:position withEvent:event]) {
//    if (self.popupView) {
//      [self.popupView removeFromSuperview];
//    }
//  } else {
//    NSLog(@"MOVE x:%f y:%f", position.x, position.y);
//  }
//
//  [super touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//  if (self.popupView.superview) {
//    [self.popupView removeFromSuperview];
//  }
//  [super touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet<UITouch *> *)touches
//               withEvent:(UIEvent *)event {
//  if (self.popupView.superview) {
//    [self.popupView removeFromSuperview];
//  }
//  [super touchesCancelled:touches withEvent:event];
//}

#pragma mark - properties

- (UIView *)popupView {
  if (!_popupView) {
    _popupView = [[LPDKeyButtonPopupView alloc] initWithKeyboardButton:self];
  }
  return _popupView;
}

@end
