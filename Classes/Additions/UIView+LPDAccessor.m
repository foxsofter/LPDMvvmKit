//
//  UIView+LPDAccessor.m
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "UIView+LPDAccessor.h"

@implementation UIView (LPDAccessor)

#pragma mark - frame origin

- (CGPoint)origin {
  return self.frame.origin;
}

- (void)setOrigin:(CGPoint)newOrigin {
  CGRect newFrame = self.frame;
  newFrame.origin = newOrigin;
  self.frame = newFrame;
}

- (CGFloat)x {
  return self.frame.origin.x;
}

- (void)setX:(CGFloat)newX {
  CGRect newFrame = self.frame;
  newFrame.origin.x = newX;
  self.frame = newFrame;
}

- (CGFloat)y {
  return self.frame.origin.y;
}

- (void)setY:(CGFloat)newY {
  CGRect newFrame = self.frame;
  newFrame.origin.y = newY;
  self.frame = newFrame;
}

#pragma mark - frame size

- (CGSize)size {
  return self.frame.size;
}

- (void)setSize:(CGSize)newSize {
  CGRect newFrame = self.frame;
  newFrame.size = newSize;
  self.frame = newFrame;
}

- (CGFloat)height {
  return self.frame.size.height;
}

- (void)setHeight:(CGFloat)newHeight {
  CGRect newFrame = self.frame;
  newFrame.size.height = newHeight;
  self.frame = newFrame;
}

- (CGFloat)width {
  return self.frame.size.width;
}

- (void)setWidth:(CGFloat)newWidth {
  CGRect newFrame = self.frame;
  newFrame.size.width = newWidth;
  self.frame = newFrame;
}

#pragma mark - bounds origin

- (CGPoint)boundsOrigin {
  return self.bounds.origin;
}

- (void)setBoundsOrigin:(CGPoint)boundsOrigin {
  CGRect newBounds = self.bounds;
  newBounds.origin = boundsOrigin;
  self.bounds = newBounds;
}

- (CGFloat)boundsX {
  return self.bounds.origin.x;
}

- (void)setBoundsX:(CGFloat)newX {
  CGRect newBounds = self.bounds;
  newBounds.origin.x = newX;
  self.bounds = newBounds;
}

- (CGFloat)boundsY {
  return self.bounds.origin.y;
}

- (void)setBoundsY:(CGFloat)newY {
  CGRect newBounds = self.bounds;
  newBounds.origin.y = newY;
  self.bounds = newBounds;
}

#pragma mark - bounds size

- (CGSize)boundsSize {
  return self.bounds.size;
}

- (void)setBoundsSize:(CGSize)newSize {
  CGRect newBounds = self.bounds;
  newBounds.size = newSize;
  self.bounds = newBounds;
}

- (CGFloat)boundsHeight {
  return self.bounds.size.height;
}

- (void)setBoundsHeight:(CGFloat)newHeight {
  CGRect newBounds = self.bounds;
  newBounds.size.height = newHeight;
  self.bounds = newBounds;
}

- (CGFloat)boundsWidth {
  return self.bounds.size.width;
}

- (void)setBoundsWidth:(CGFloat)newWidth {
  CGRect newBounds = self.bounds;
  newBounds.size.width = newWidth;
  self.bounds = newBounds;
}

#pragma mark - paddings

- (CGFloat)top {
  return self.bounds.origin.y - self.frame.origin.y;
}

- (void)setTop:(CGFloat)top {
  CGRect newBounds = self.bounds;
  newBounds.origin.y = self.frame.origin.y + top;
  self.bounds = newBounds;
}

- (CGFloat)left {
  return self.bounds.origin.x - self.frame.origin.x;
}

- (void)setLeft:(CGFloat)left {
  CGRect newBounds = self.bounds;
  newBounds.origin.x = self.frame.origin.x + left;
  self.bounds = newBounds;
}

- (CGFloat)right {
  return (self.frame.origin.x + self.frame.size.width) - (self.bounds.origin.x + self.bounds.size.width);
}

- (void)setRight:(CGFloat)right {
  CGRect newBounds = self.bounds;
  newBounds.size.width = self.frame.size.width - right;
  self.bounds = newBounds;
}

- (CGFloat)bottom {
  return (self.frame.origin.y + self.frame.size.height) - (self.bounds.origin.y + self.bounds.size.height);
}

- (void)setBottom:(CGFloat)bottom {
  CGRect newBounds = self.bounds;
  newBounds.size.height = self.frame.size.width - bottom;
  self.bounds = newBounds;
}

#pragma mark - center

- (CGFloat)centerX {
  return self.center.x;
}

- (void)setCenterX:(CGFloat)newCenterX {
  self.center = CGPointMake(newCenterX, self.center.y);
}

- (CGFloat)centerY {
  return self.center.y;
}

- (void)setCenterY:(CGFloat)newCenterY {
  self.center = CGPointMake(self.center.x, newCenterY);
}

@end
