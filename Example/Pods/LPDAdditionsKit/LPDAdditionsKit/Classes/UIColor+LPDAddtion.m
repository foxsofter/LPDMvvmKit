//
//  UIColor+LPDAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/1/19.
//  Copyright (c) 2015年 foxsofter. All rights reserved.
//

#import "UIColor+LPDAddition.h"

@implementation UIColor (LPDAddition)

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
  NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
  NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
  unsigned hexComponent;
  [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
  return hexComponent / 255.0;
}

+ (UIColor *)colorWithHexString:(NSString *)hexString {
  NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
  CGFloat alpha, red, blue, green;
  switch ([colorString length]) {
    case 3: // #RGB
      alpha = 1.0f;
      red = [self colorComponentFrom:colorString start:0 length:1];
      green = [self colorComponentFrom:colorString start:1 length:1];
      blue = [self colorComponentFrom:colorString start:2 length:1];
      break;
    case 4: // #ARGB
      alpha = [self colorComponentFrom:colorString start:0 length:1];
      red = [self colorComponentFrom:colorString start:1 length:1];
      green = [self colorComponentFrom:colorString start:2 length:1];
      blue = [self colorComponentFrom:colorString start:3 length:1];
      break;
    case 6: // #RRGGBB
      alpha = 1.0f;
      red = [self colorComponentFrom:colorString start:0 length:2];
      green = [self colorComponentFrom:colorString start:2 length:2];
      blue = [self colorComponentFrom:colorString start:4 length:2];
      break;
    case 8: // #AARRGGBB
      alpha = [self colorComponentFrom:colorString start:0 length:2];
      red = [self colorComponentFrom:colorString start:2 length:2];
      green = [self colorComponentFrom:colorString start:4 length:2];
      blue = [self colorComponentFrom:colorString start:6 length:2];
      break;
    default:
      return nil;
  }
  return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (UIColor *)antiColor {
  CGFloat red, green, blue, alpha;
  BOOL isCoverted;

  red = green = blue = alpha = 0.0f;
  isCoverted = [self getRed:&red green:&green blue:&blue alpha:&alpha];
  // 能正确获取当前颜色值
  if (isCoverted) {
    return [UIColor colorWithRed:(1.0f - red) green:(1.0f - green) blue:(1.0f - blue) alpha:alpha];
  } else {
    return [UIColor whiteColor];
  }
}

+ (UIColor *)colorWithRGB:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:1];
}

+ (UIColor *)colorWithRGBA:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha {
    return [UIColor colorWithRed:red / 255.0 green:green / 255.0 blue:blue / 255.0 alpha:alpha];
}

/**
 Return a randomColor (just for test UI)
 
 @return randomColor
 */
+ (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}


@end
