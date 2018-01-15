//
//  NSData+LPDAddition.m
//  LPDBusiness
//
//  Created by xiaozihao on 2016/7/27.
//  Copyright © 2016年 ELM. All rights reserved.
//

#import "NSDate+LPDAddition.h"

@implementation NSDate (LPDAddition)

/**
 获取时间字符串，指定 dataFormat

 @param date
 @param dataFormat
 @return
 */
+ (NSString *)stringFromDate:(NSDate *)date setDateFormat:(NSString *)dataFormat {
  //用于格式化NSDate对象

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  if (dataFormat) {
    [dateFormatter setDateFormat:dataFormat];
  } else {
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  }
  NSString *currentDateString = [dateFormatter stringFromDate:date];
  return currentDateString;
}

/**
 获取 NSDate，指定 dataFormat

 @param dateString
 @param dataFormat
 @return
 */
+ (nullable NSDate *)dateFromString:(NSString *)dateString setDateFormat:(NSString *)dataFormat {

  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  if (dataFormat) {
    [dateFormatter setDateFormat:dataFormat];
  } else {
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  }
  NSDate *date = [dateFormatter dateFromString:dateString];
  return date;
}

/**
 获取当前时间字符串，指定 dataFormat

 @param format @"yyyy-MM-dd HH:mm:ss"、@"yyyy年MM月dd日 HH时mm分ss秒"
 @return
 */
+ (NSString *)currentDateWithFormat:(NSString *)format {
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:format];
  return [dateFormatter stringFromDate:[NSDate date]];
}

/**
 计算两个时间戳的差值

 @param timestamp
 @param anotherTimestamp
 @return 差值
 */
+ (NSInteger)differenceOfTimestamp:(NSInteger)timestamp anotherTimestamp:(NSInteger)anotherTimestamp {

  CGFloat timeDifference;
  if (!timestamp) {
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    timeDifference = currentTime * 1000 - anotherTimestamp;
  } else {
    timeDifference = timestamp - anotherTimestamp;
  }
  return (NSInteger)timeDifference;
}

/**
 根据时间戳计算距离现在的时间

 @param lastTime
 @param currentTime
 @return
 */
+ (NSString *)timeIntervalFromLastTime:(NSDate *)lastTime ToCurrentTime:(NSDate *)currentTime {
  NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
  //上次时间
  NSDate *lastDate = [lastTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:lastTime]];
  //当前时间
  NSDate *currentDate = [currentTime dateByAddingTimeInterval:[timeZone secondsFromGMTForDate:currentTime]];
  //时间间隔
  NSInteger intevalTime = [currentDate timeIntervalSinceReferenceDate] - [lastDate timeIntervalSinceReferenceDate];

  //秒、分、小时、天、月、年
  NSInteger minutes = intevalTime / 60;
  NSInteger hours = intevalTime / 60 / 60;
  NSInteger day = intevalTime / 60 / 60 / 24;
  NSInteger month = intevalTime / 60 / 60 / 24 / 30;
  NSInteger yers = intevalTime / 60 / 60 / 24 / 365;

  if (minutes <= 10) {
    return @"刚刚";
  } else if (minutes < 60) {
    return [NSString stringWithFormat:@"%ld分钟前", (long)minutes];
  } else if (hours < 24) {
    return [NSString stringWithFormat:@"%ld小时前", (long)hours];
  } else if (day < 30) {
    return [NSString stringWithFormat:@"%ld天前", (long)day];
  } else if (month < 12) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"M-d";
    NSString *time = [df stringFromDate:lastDate];
    return time;
  } else if (yers >= 1) {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-M-d";
    NSString *time = [df stringFromDate:lastDate];
    return time;
  }
  return @"";
}

/**
 *  获取时间段的描述，xx时xx分
 *
 *  @param timeInterval 多少秒
 */
+ (NSString *)timeIntervalString:(NSInteger)timeInterval {
  if (timeInterval > 0 && timeInterval < 60) {
    return [NSString stringWithFormat:@"%ld秒", (long)timeInterval];
  } else if (timeInterval >= 60 && timeInterval < 3600) {
    return [NSString stringWithFormat:@"%ld分", (long)(timeInterval / 60)];
  } else if (timeInterval >= 3600) {
    NSInteger minutes = (timeInterval % 3600) / 60;
    if (minutes > 0) {
      return [NSString stringWithFormat:@"%ld时%ld分", (long)(timeInterval / 3600), (long)((timeInterval % 3600) / 60)];
    } else {
      return [NSString stringWithFormat:@"%ld时",(long)(timeInterval / 3600)];
    }
  }
  return @"";
}

@end
