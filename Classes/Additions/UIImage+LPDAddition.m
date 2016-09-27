//
//  UIImage+LPDAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "UIImage+LPDAddition.h"

@implementation UIImage (LPDAddition)

+ (UIImage *)createImageFromView:(UIView *)sourceView {
  NSParameterAssert(sourceView);

  UIGraphicsBeginImageContextWithOptions(sourceView.bounds.size, NO, [UIScreen mainScreen].scale);
  [sourceView.layer renderInContext:UIGraphicsGetCurrentContext()];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

+ (UIImage *)createImageWithColor:(UIColor *)color {
  return [UIImage createImageWithColor:color size:CGSizeMake(1.f, 1.f)];
}

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size {
  NSParameterAssert(color);

  CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
  UIGraphicsBeginImageContext(rect.size);
  CGContextRef context = UIGraphicsGetCurrentContext();

  CGContextSetFillColorWithColor(context, [color CGColor]);
  CGContextFillRect(context, rect);

  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();

  return image;
}

- (UIImage *)imageWithAlpha:(CGFloat)alpha {
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);

  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);

  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);

  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);

  CGContextSetAlpha(ctx, alpha);

  CGContextDrawImage(ctx, area, self.CGImage);

  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();

  UIGraphicsEndImageContext();

  return newImage;
}

- (UIImage *)resizeTo:(CGSize)size {
  CGRect rect = CGRectMake(0, 0, size.width, size.height);
  UIGraphicsBeginImageContext(rect.size);
  [self drawInRect:rect];
  UIImage *imageContext = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  NSData *imageData = UIImagePNGRepresentation(imageContext);
  return [UIImage imageWithData:imageData];
}

@end
