//
//  LPDKeyButtonHolderView.m
//  FoxKit
//
//  Created by ZhongDanWei on 15/12/1.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDKeyButtonHolderView.h"
#import "LPDKeyButtonPopupView.h"
#import "LPDKeyButton.h"

@implementation LPDKeyButtonHolderView

#pragma mark - life cycle

- (instancetype)init {
  self = [super init];
  if (self) {
    [self initialize];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
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

- (void)awakeFromNib {
  [super awakeFromNib];
  
  [self initialize];
}

- (void)initialize {
  self.multipleTouchEnabled = YES;
}

#pragma mark - events

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self touchesOn:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self touchesOn:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [self touchesOff:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches
               withEvent:(UIEvent *)event {
  [self touchesOff:touches withEvent:event];
}

#pragma mark - private methods

- (void)touchesOn:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  __weak typeof(self) weakSelf = self;
  [self.subviews
      enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj,
                                   NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:LPDKeyButton.class]) {
          LPDKeyButton *keyButton = (LPDKeyButton *)obj;
          CGPoint position = [touch locationInView:keyButton];
          if ([keyButton pointInside:position withEvent:event]) {
            if (!keyButton.popupView.superview) {
              [weakSelf.window addSubview:keyButton.popupView];
            }
          } else {
            if (keyButton.popupView.superview) {
              [keyButton.popupView removeFromSuperview];
            }
          }
        }
      }];
}

- (void)touchesOff:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  [self.subviews
      enumerateObjectsUsingBlock:^(__kindof UIView *_Nonnull obj,
                                   NSUInteger idx, BOOL *_Nonnull stop) {
        if ([obj isKindOfClass:LPDKeyButton.class]) {
          LPDKeyButton *keyButton = (LPDKeyButton *)obj;
          CGPoint position = [touch locationInView:keyButton];
          if ([keyButton pointInside:position withEvent:event]) {
            [keyButton sendActionsForControlEvents:UIControlEventTouchUpInside];
          }
          if (keyButton.popupView.superview) {
            [keyButton.popupView removeFromSuperview];
          }
        }
      }];
}

@end
