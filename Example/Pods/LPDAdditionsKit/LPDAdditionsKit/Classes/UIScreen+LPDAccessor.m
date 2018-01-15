//
//  UIScreen+LPDAccessor.m
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "UIScreen+LPDAccessor.h"

static const CGFloat DefaultScreenWidth = 750.0/2;

static const CGFloat DefaultScreenHeight = 1134.0/2;

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

+ (CGFloat)scale {
  return [UIScreen mainScreen].scale;
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

+ (CGFloat)ceilPixelValue:(CGFloat)pixelValue {
  CGFloat scale = [UIScreen scale];
  return ceil(pixelValue * scale) / scale;
}

+ (CGFloat)roundPixelValu:(CGFloat)pixelValue  {
  CGFloat scale = [UIScreen scale];
  return round(pixelValue * scale) / scale;
}

+ (CGFloat)floorPixelValue:(CGFloat)pixelValue {
  CGFloat scale = [UIScreen scale];
  return floor(pixelValue * scale) / scale;
}

+ (CGFloat) pixelResize:(CGFloat) value {
  
  return [UIScreen ceilPixelValue:value * [UIScreen screenResizeScale]];
  
}

+ (CGRect) pixelFrameResize:(CGRect)value {
  
  CGRect new = CGRectMake(value.origin.x * [UIScreen screenResizeScale],
                          value.origin.y *[UIScreen screenResizeScale],
                          value.size.width * [UIScreen screenResizeScale],
                          value.size.height * [UIScreen screenResizeScale]);
  return new;
  
}

+ (CGPoint) pixelPointResize:(CGPoint) value {
  
  CGPoint new = CGPointMake(value.x * [UIScreen screenResizeScale],
                            value.y * [UIScreen screenResizeScale]);
  return new;
  
}

+ (CGFloat)screenResizeScale {
  
  static CGFloat resizeScale;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    CGSize size = [UIScreen size];
    CGFloat deviceWidth;
    if (size.width > size.height) {
      deviceWidth = size.height;
    } else {
      deviceWidth = size.width;
    }
    
    resizeScale = deviceWidth / DefaultScreenWidth;
  });
  
  return resizeScale;
  
}


+ (CGFloat)screenHeightResizeScale {
  
  static CGFloat resizeScale;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    CGSize size = [UIScreen size];
    CGFloat deviceHeight;
    if (size.width > size.height) {
      deviceHeight = size.width;
    } else {
      deviceHeight = size.height;
    }
    
    resizeScale = deviceHeight / DefaultScreenHeight;
  });
  
  return resizeScale;
  
}


@end
