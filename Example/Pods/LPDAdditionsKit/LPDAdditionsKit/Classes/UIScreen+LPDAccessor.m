//
//  UIScreen+LPDAccessor.m
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "UIScreen+LPDAccessor.h"

@implementation UIScreen (LPDAccessor)

#pragma mark - Size

+ (CGRect)bounds {
  return UIScreen.mainScreen.bounds;
}

+ (CGSize)size {
  return UIScreen.mainScreen.size;
}

+ (CGFloat)width {
  return UIScreen.size.width;
}

+ (CGFloat)height {
  return UIScreen.size.height;
}

- (CGSize)size {
  return self.bounds.size;
}

- (CGFloat)height {
  return self.size.height;
}

- (CGFloat)width {
  return self.size.width;
}

#pragma mark - iphone ui design value

+ (CGFloat)statusBarHeight {
  return 20.f;
}

+ (CGFloat)navigationBarHeight {
  return 64.f;
}

+ (CGFloat)toolBarHeight {
  return 44;
}

+ (CGFloat)tabBarHeight {
  return 49;
}

@end
