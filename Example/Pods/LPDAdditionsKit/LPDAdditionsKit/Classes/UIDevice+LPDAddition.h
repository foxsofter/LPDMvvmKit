//
//  UIDevice+LPDAddition.h
//  LPDAdditions
//
//  Created by foxsofter on 15/10/31.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (LPDAddition)

+ (NSString *)platform;

+ (BOOL)isSimulator;

+ (NSString *)platformString;

+ (BOOL)p35InchDisplay;

+ (BOOL)p4InchDisplay;

+ (BOOL)p47InchDisplay;

+ (BOOL)p55InchDiplay;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
