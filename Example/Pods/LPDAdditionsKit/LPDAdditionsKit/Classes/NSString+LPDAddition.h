//
//  NSString+LPDAddition.h
//  LPDAdditions
//
//  Created by foxsofter on 15/11/26.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LPDAddition)

- (NSString *)reverse;

- (NSString *)stringByRemovingWithPattern:(NSString *)patternString;

- (NSMutableAttributedString *)adjustTextColor:(UIColor *)color range:(NSRange)range;

- (BOOL)isEmpty;

- (BOOL)containsString:(NSString *)str;

- (NSString *)encryptedPhone;

@end

NS_ASSUME_NONNULL_END
