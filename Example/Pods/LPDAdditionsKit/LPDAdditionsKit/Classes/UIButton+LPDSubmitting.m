//
//  UIButton+LPDSubmitting.m
//  LPDAdditions
//
//  Created by foxsofter on 15/4/2.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "NSObject+LPDAssociatedObject.h"
#import "UIButton+LPDSubmitting.h"
#import "UIScreen+LPDAccessor.h"
#import "UIView+LPDAccessor.h"


@interface UIButton ()

@property (nonatomic, strong, nullable) UIView *modalView;
@property (nonatomic, strong, nullable) UIActivityIndicatorView *spinnerView;
@property (nonatomic, strong, nullable) UILabel *spinnerTitleLabel;

@end

@implementation UIButton (LPDSubmitting)

- (void)beginSubmitting:(NSString *)title {
  [self endSubmitting];

  self.submitting = YES;
  self.hidden = YES;

  self.modalView = [[UIView alloc] initWithFrame:self.frame];
  self.modalView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.6];
  self.modalView.layer.cornerRadius = self.layer.cornerRadius;
  self.modalView.layer.borderWidth = self.layer.borderWidth;
  self.modalView.layer.borderColor = self.layer.borderColor;

  CGRect viewBounds = self.modalView.bounds;
  self.spinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
  self.spinnerView.tintColor = self.titleLabel.textColor;
  self.spinnerView.frame = CGRectMake(10, 5, self.height - 10, self.height - 10);
  [self.modalView addSubview:self.spinnerView];

  if (title && title.length > 0) {
    self.spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.spinnerTitleLabel.text = title;
    self.spinnerTitleLabel.font = self.titleLabel.font;
    self.spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.modalView addSubview:self.spinnerTitleLabel];

    self.spinnerTitleLabel.x += self.height;
  } else {
    self.spinnerView.x = self.centerX;
  }
  [self.superview addSubview:self.modalView];
  [self.spinnerView startAnimating];
}

- (void)beginSubmitting {
  [self beginSubmitting:nil];
}

- (void)endSubmitting {
  if (!self.isSubmitting) {
    return;
  }

  self.submitting = NO;
  self.hidden = NO;

  [self.modalView removeFromSuperview];
  self.modalView = nil;
  self.spinnerView = nil;
  self.spinnerTitleLabel = nil;
}

- (BOOL)isSubmitting {
  return ((NSNumber *)[self object:@selector(setSubmitting:)]).boolValue;
}

- (void)setSubmitting:(BOOL)submitting {
  [self setRetainNonatomicObject:@(submitting) withKey:@selector(setSubmitting:)];
}

- (UIActivityIndicatorView *)spinnerView {
  return [self object:@selector(setSpinnerView:)];
}

- (void)setSpinnerView:(UIActivityIndicatorView *)spinnerView {
  [self setRetainNonatomicObject:spinnerView withKey:@selector(setSpinnerView:)];
}

- (UIView *)modalView {
  return [self object:@selector(setModalView:)];
}

- (void)setModalView:(UIView *)modalView {
  [self setRetainNonatomicObject:modalView withKey:@selector(setModalView:)];
}

- (UILabel *)spinnerTitleLabel {
  return [self object:@selector(setSpinnerTitleLabel:)];
}

- (void)setSpinnerTitleLabel:(UILabel *)spinnerTitleLabel {
  [self setRetainNonatomicObject:spinnerTitleLabel withKey:@selector(setSpinnerTitleLabel:)];
}

@end
