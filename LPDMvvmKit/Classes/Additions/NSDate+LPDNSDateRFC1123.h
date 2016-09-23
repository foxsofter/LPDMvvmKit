//
//  NSDate+LPDNSDateRFC1123.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LPDNSDateRFC1123)

/**
 Convert a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1)
 into NSDate.
 */
+ (NSDate *)dateFromRFC1123:(NSString *)value_;

/**
 Convert NSDate into a RFC1123 'Full-Date' string
 (http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1).
 */
- (NSString *)rfc1123String;

/**
 Convert NSDate into a 'yyyyMMdd' string
 */
- (NSString *)yyyyMMddString;

/**
 *  @brief Convert to local time zone.
 */
- (NSDate *)toLocalDate;

- (NSDate *)toBeijingDate;

/**
 *  @brief Convert to gmt time zone.
 */
- (NSDate *)toGlobalDate;

/**
 *  @brief 00:00:00
 */
- (NSDate *)beginningOfDay;

/**
 *  @brief 23:59:59
 */
- (NSDate *)endingOfDay;

/**
 *  @brief MM月01日
 */
- (NSString *)beginningOfMonth;

@end
