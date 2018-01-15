//
//  NSDate+LPDNSDateRFC1123.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (LPDNSDateRFC1123)

/**
 Convert a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1)
 into NSDate.
 */
+ (nullable NSDate *)dateFromRFC1123:(NSString * _Nullable)value_;

/**
 Convert NSDate into a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1).
 */
- (nullable NSString *)rfc1123String;

/**
 Convert NSDate into a 'yyyyMMdd' string
 */
- (nullable NSString *)yyyyMMddString;

/**
 Convert NSDate into a string with FormatString
 */
- (nullable NSString *)stringWithFormatString:(nonnull NSString *)formatString;

/**
 *  @brief Convert to local time zone.
 */
- (nullable NSDate *)toLocalDate;

- (nullable NSDate *)toBeijingDate;

/**
 *  @brief Convert to gmt time zone.
 */
- (nullable NSDate *)toGlobalDate;

/**
 *  @brief 00:00:00
 */
- (nullable NSDate *)beginningOfDay;

/**
 *  @brief 23:59:59
 */
- (nullable NSDate *)endingOfDay;

/**
 *  @brief MM月01日
 */
- (nonnull NSString *)beginningOfMonth;

@end

NS_ASSUME_NONNULL_END
