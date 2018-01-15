//
//  UIImage+LPDAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/9/23.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "UIImage+LPDAddition.h"
#import <Accelerate/Accelerate.h>

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

-(UIImage *)imageWithBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = self.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}

+ (nullable UIImage *)imageCacheWithName:(NSString *)imageName {
    return [UIImage imageNamed:imageName];
}

+ (nullable UIImage *)imageNoCacheWithName:(NSString *)imageName {
    NSString *fullName = nil;
    if ([UIScreen mainScreen].scale > 2.0) {
        fullName = [imageName stringByAppendingString:@"@3x"];
    } else {
        fullName = [imageName stringByAppendingString:@"@2x"];
    }
    NSString *path = [[NSBundle mainBundle] pathForResource:fullName ofType:@"png"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];
    if (!image) {
        if ([UIScreen mainScreen].scale > 2.0) {
            fullName = [imageName stringByAppendingString:@"@2x"];
            NSString *path = [[NSBundle mainBundle] pathForResource:fullName ofType:@"png"];
            image = [[UIImage alloc] initWithContentsOfFile:path];
        }
    }
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+ (nullable UIImage *)imageJPGName:(NSString *)imageName {
    NSString *path = [[NSBundle mainBundle] pathForResource:imageName ofType:@"jpg"];
    return [[UIImage alloc] initWithContentsOfFile:path];
}

+ (nullable UIImage *)opacityImage:(UIImage *)image opacity:(float)opacity {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, [UIScreen mainScreen].scale);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, opacity);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (nullable UIImage *)maskImage:(UIImage *)image withColor:(UIColor *)maskColor {
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, maskColor.CGColor);
    CGContextFillRect(context, rect);
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return smallImage;
}

+ (nullable UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (fabs((size.width) - (0.0)) < 0.001 || fabs((size.height) - (0.0)) < 0.001) {
        return nil;
    }
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (nullable UIImage *)roundImageWithOriginImage:(UIImage *)image withDiameter:(CGFloat)diameter {
    CGSize imageSize = CGSizeMake(diameter, diameter);
    CGRect imageRect = CGRectMake(0, 0, diameter, diameter);

    UIGraphicsBeginImageContextWithOptions(imageSize, NO, [UIScreen mainScreen].scale);

    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddEllipseInRect(context, imageRect);
    CGContextClip(context);

    [image drawInRect:imageRect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

+ (nullable UIImage *)roundedRectImageWithColor:(UIColor *)color cornerRadius:(CGFloat)radius size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [color set];
    UIBezierPath *path =
    [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
    [path fill];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (nullable UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
@end
