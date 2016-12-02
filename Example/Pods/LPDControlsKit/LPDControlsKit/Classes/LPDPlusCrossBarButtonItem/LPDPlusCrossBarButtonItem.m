//
//  LPDPlusCrossBarButtonItem.m
//  FoxKit
//
//  Created by fox softer on 15/10/25.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDPlusCrossBarButtonItem.h"

@interface LPDPlusCrossBarButtonItem ()

@property (nonatomic, strong) UIImageView *openImageView;
@property (nonatomic, strong) UIImageView *closeImageView;
@property (nonatomic, strong) UIView *itemView;
@property (nonatomic, assign) BOOL animating;
@property (nonatomic, assign, readwrite) BOOL opening;

@end

@implementation LPDPlusCrossBarButtonItem

- (instancetype)initWithOpenImage:(UIImage *)openImage closeImage:(UIImage *)closeImage {
  self.duration = 0.2;

  _itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
  _openImage = openImage;
  _openImageView = [[UIImageView alloc] initWithImage:openImage];
  [_itemView addSubview:_openImageView];
  _openImageView.frame = _itemView.bounds;

  _closedImage = closeImage;
  _closeImageView = [[UIImageView alloc] initWithImage:closeImage];
  _closeImageView.alpha = 0.f;
  [_itemView addSubview:_closeImageView];
  _closeImageView.frame = _itemView.bounds;

  UITapGestureRecognizer *recongnizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemViewTap)];
  [_itemView addGestureRecognizer:recongnizer];
  return [super initWithCustomView:_itemView];
}

- (void)itemViewTap {
  if (self.opening) {
    [self close];
  } else {
    [self open];
  }
}

- (void)open {
  if (_animating) {
    return;
  }
  _animating = YES;
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:self.duration
    animations:^{
      _openImageView.transform = CGAffineTransformMakeRotation(-M_PI_4);
      _openImageView.alpha = 0.0;
      _closeImageView.transform = CGAffineTransformIdentity;
      _closeImageView.alpha = 1;
    }
    completion:^(BOOL finished) {
      __strong typeof(self) strongSelf= weakSelf;
      if (strongSelf) {
        self.opening = YES;
        self.animating = NO;
      }
    }];
  if (self.openBlock) {
    self.openBlock();
  }
}

- (void)close {
  if (_animating) {
    return;
  }
  _animating = YES;
  __weak typeof(self) weakSelf = self;
  [UIView animateWithDuration:self.duration
    animations:^{
      _closeImageView.transform = CGAffineTransformMakeRotation(M_PI_4);
      _closeImageView.alpha = 0.0;
      _openImageView.transform = CGAffineTransformIdentity;
      _openImageView.alpha = 1;
    }
    completion:^(BOOL finished) {
      __strong typeof(self) strongSelf= weakSelf;
      if (strongSelf) {
        self.opening = NO;
        self.animating = NO;
      }
    }];
  if (self.closeBlock) {
    self.closeBlock();
  }
}

@end
