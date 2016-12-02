//
//  UIView+LPDBadge.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/15.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "NSObject+LPDAssociatedObject.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIColor+LPDAddition.h"
#import "UIView+LPDBadge.h"

@interface UIView ()

@property (nonatomic, strong) UIView *badgeView;

@end

@implementation UIView (LPDBadge)

#pragma mark - properties

- (BOOL)shouldShowBadge {
  return [[self object:@selector(setShouldShowBadge:)] boolValue];
}

- (void)setShouldShowBadge:(BOOL)shouldShowBadge {
  [self setRetainNonatomicObject:@(shouldShowBadge) withKey:@selector(setShouldShowBadge:)];

  if (self) {
    if (shouldShowBadge && !self.badgeView) {
      self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
      self.badgeView.layer.cornerRadius = 3;
      self.badgeView.backgroundColor = [UIColor colorWithHexString:@"#FF5E1C"];
      [self addSubview:self.badgeView];
      if (self.badgeConfigBlock) {
        self.badgeConfigBlock(self.badgeView);
      }
    }
    if (!shouldShowBadge && self.badgeView) {
      [self.badgeView removeFromSuperview];
      self.badgeView = nil;
    }
  }
}

- (void (^)(UIView *))badgeConfigBlock {
  return [self object:@selector(setBadgeConfigBlock:)];
}

- (void)setBadgeConfigBlock:(void (^)(UIView *))badgeConfigBlock {
  [self setCopyNonatomicObject:badgeConfigBlock withKey:@selector(setBadgeConfigBlock:)];
}

- (UIView *)badgeView {
  return [self object:@selector(setBadgeView:)];
}

- (void)setBadgeView:(UIView *)badgeView {
  [self setRetainNonatomicObject:badgeView withKey:@selector(setBadgeView:)];
}

@end
