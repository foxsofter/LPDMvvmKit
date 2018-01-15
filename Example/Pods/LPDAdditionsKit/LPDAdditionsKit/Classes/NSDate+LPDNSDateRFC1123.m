//
//  NSDate+LPDNSDateRFC1123.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "NSDate+LPDNSDateRFC1123.h"

@implementation NSDate (LPDNSDateRFC1123)

+ (nullable NSDate *)dateFromRFC1123:(NSString *)value {
  if (value == nil)
    return nil;
  static NSDateFormatter *rfc1123 = nil;
  if (rfc1123 == nil) {
    rfc1123 = [[NSDateFormatter alloc] init];
    rfc1123.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    rfc1123.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    rfc1123.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
  }
  NSDate *ret = [rfc1123 dateFromString:value];
  if (ret != nil)
    return ret;

  static NSDateFormatter *rfc850 = nil;
  if (rfc850 == nil) {
    rfc850 = [[NSDateFormatter alloc] init];
    rfc850.locale = rfc1123.locale;
    rfc850.timeZone = rfc1123.timeZone;
    rfc850.dateFormat = @"EEEE',' dd'-'MMM'-'yy HH':'mm':'ss z";
  }
  ret = [rfc850 dateFromString:value];
  if (ret != nil)
    return ret;

  static NSDateFormatter *asctime = nil;
  if (asctime == nil) {
    asctime = [[NSDateFormatter alloc] init];
    asctime.locale = rfc1123.locale;
    asctime.timeZone = rfc1123.timeZone;
    asctime.dateFormat = @"EEE MMM d HH':'mm':'ss yyyy";
  }
  return [asctime dateFromString:value];
}

- (nullable NSString *)rfc1123String {
  static NSDateFormatter *df = nil;
  if (df == nil) {
    df = [[NSDateFormatter alloc] init];
    df.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    df.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
  }
  return [df stringFromDate:self];
}

- (NSString *)yyyyMMddString {
  static NSDateFormatter *df = nil;
  if (df == nil) {
    df = [[NSDateFormatter alloc] init];
    //    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    df.timeZone = [NSTimeZone localTimeZone];
    df.dateFormat = @"yyyy-MM-dd";
  }
  return [df stringFromDate:self];
}

- (nullable NSString *)stringWithFormatString:(NSString *)formatString {
    static NSDateFormatter *df = nil;
    if (df == nil) {
        df = [[NSDateFormatter alloc] init];
        //    df.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
        df.timeZone = [NSTimeZone localTimeZone];
        df.dateFormat = formatString;
    }
    return [df stringFromDate:self];
}

- (nullable NSDate *)toLocalDate {
  NSInteger seconds = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:self];
  return [NSDate dateWithTimeInterval:seconds sinceDate:self];
}

- (NSDate *)toBeijingDate {
  return [NSDate dateWithTimeInterval:8 * 60 * 60 sinceDate:self];
}

- (nullable NSDate *)toGlobalDate {
  NSInteger seconds = [[NSTimeZone defaultTimeZone] secondsFromGMTForDate:self];
  return [NSDate dateWithTimeInterval:-seconds sinceDate:self];
}

- (nullable NSDate *)beginningOfDay {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *todayDate = [dateFormatter stringFromDate:self];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  return [dateFormatter dateFromString:[todayDate stringByAppendingString:@" 00:00:00"]];
}

- (NSDate *)endingOfDay {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
  [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  NSString *todayDate = [dateFormatter stringFromDate:self];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  return [dateFormatter dateFromString:[todayDate stringByAppendingString:@" 23:59:59"]];
}

- (nonnull NSString *)beginningOfMonth {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
  [dateFormatter setDateFormat:@"MM月"];
  NSString *todayDate = [dateFormatter stringFromDate:self];
  return [todayDate stringByAppendingString:@"01日"];
}

@end
