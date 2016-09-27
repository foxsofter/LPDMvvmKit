//
//  NSNumber+LPDMoneyAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/11/26.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "NSNumber+LPDMoneyAddition.h"
#import "NSString+LPDAddition.h"

//  1234567890.31 <=> 壹拾貳億叁仟肆佰伍拾陸萬柒仟捌佰玖拾圓叁角壹分
@implementation NSNumber (LPDMoneyAddition)

static NSDictionary *numberKeyToTraditionalValues;

+ (NSString *)tranditionalCharByNumberString:(NSString *)numberString {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    numberKeyToTraditionalValues = @{
      @"1": @"壹",
      @"2": @"貳",
      @"3": @"叁",
      @"4": @"肆",
      @"5": @"伍",
      @"6": @"陸",
      @"7": @"柒",
      @"8": @"捌",
      @"9": @"玖",
      @"10": @"拾",
      @"100": @"佰",
      @"1000": @"仟",
    };
  });
  return [numberKeyToTraditionalValues objectForKey:numberString];
}

- (NSString *)traditionalMoneyString {
  NSUInteger startIndex = 0;
  NSString *moneyString = [[self moneyString] reverse];
  NSMutableString *traditionalMoneyString = [NSMutableString string];
  NSString *tranditionalChar = nil;
  if ([moneyString characterAtIndex:2] == '.') { // 有小数点
    tranditionalChar =
      [NSNumber tranditionalCharByNumberString:[moneyString substringWithRange:NSMakeRange(startIndex, 1)]];
    if (tranditionalChar) {
      [traditionalMoneyString insertString:@"分" atIndex:0];
      [traditionalMoneyString insertString:tranditionalChar atIndex:0];
    }
    moneyString = [moneyString substringFromIndex:1];

    tranditionalChar =
      [NSNumber tranditionalCharByNumberString:[moneyString substringWithRange:NSMakeRange(startIndex, 1)]];
    if (tranditionalChar) {
      [traditionalMoneyString insertString:@"角" atIndex:0];
      [traditionalMoneyString insertString:tranditionalChar atIndex:0];
    }
    moneyString = [moneyString substringFromIndex:2];
  } else {
    [traditionalMoneyString insertString:@"整" atIndex:0];
  }

  [traditionalMoneyString insertString:@"圓" atIndex:0];

  NSUInteger mileRangeLen = moneyString.length < 4 ? moneyString.length : 4;
  NSString *mileString = [self traditionalString:[moneyString substringWithRange:NSMakeRange(0, mileRangeLen)]];
  if (mileString && mileString.length > 0) {
    [traditionalMoneyString insertString:mileString atIndex:0];
  }
  moneyString = [moneyString substringFromIndex:mileRangeLen];
  if (moneyString.length > 0) {
    mileRangeLen = moneyString.length < 4 ? moneyString.length : 4;
    mileString = [self traditionalString:[moneyString substringWithRange:NSMakeRange(0, mileRangeLen)]];
    if (mileString && mileString.length > 0) {
      [traditionalMoneyString insertString:@"萬" atIndex:0];
      [traditionalMoneyString insertString:mileString atIndex:0];
    }
    moneyString = [moneyString substringFromIndex:mileRangeLen];
    if (moneyString.length > 0) {
      mileRangeLen = moneyString.length < 4 ? moneyString.length : 4;
      mileString = [self traditionalString:[moneyString substringWithRange:NSMakeRange(0, mileRangeLen)]];
      if (mileString && mileString.length > 0) {
        [traditionalMoneyString insertString:@"億" atIndex:0];
        [traditionalMoneyString insertString:mileString atIndex:0];
      }
    }
  }

  return [traditionalMoneyString copy];
}

- (NSString *)traditionalString:(NSString *)numberString {
  NSMutableString *traditionalString = [NSMutableString string];
  NSString *tranditionalChar = nil;
  NSString *tranditionalUnitChar = nil;
  NSUInteger startIndex = 0;
  while (startIndex < numberString.length) {
    tranditionalChar =
      [NSNumber tranditionalCharByNumberString:[numberString substringWithRange:NSMakeRange(startIndex, 1)]];
    if (tranditionalChar) {
      if (startIndex > 0) {
        tranditionalUnitChar = [NSNumber tranditionalCharByNumberString:@(pow(10, startIndex)).stringValue];
      }
      if (tranditionalUnitChar) {
        [traditionalString insertString:tranditionalUnitChar atIndex:0];
        tranditionalUnitChar = nil;
      }
      [traditionalString insertString:tranditionalChar atIndex:0];
    }
    startIndex++;
    tranditionalChar = nil;
  }
  return [traditionalString copy];
}

- (NSString *)moneyString {
  NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
  [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
  [formatter setCurrencySymbol:@"¥"];
  return [[formatter stringFromNumber:self] stringByReplacingOccurrencesOfString:@"," withString:@""];
}

@end
