//
//  NSString+LPDAddition.m
//  LPDAdditions
//
//  Created by foxsofter on 15/11/26.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "NSString+LPDAddition.h"

@implementation NSString (LPDAddition)

- (NSString *)reverse {
  NSMutableString *reversedString = [NSMutableString string];
  NSInteger charIndex = [self length];
  while (charIndex > 0) {
    charIndex--;
    NSRange subStrRange = NSMakeRange(charIndex, 1);
    [reversedString appendString:[self substringWithRange:subStrRange]];
  }
  return [reversedString copy];
}

- (NSString *)stringByRemovingWithPattern:(NSString *)patternString {
  NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:patternString
                                                                         options:NSRegularExpressionCaseInsensitive
                                                                           error:nil];
  return [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
}

- (NSMutableAttributedString *)adjustTextColor:(UIColor *)color range:(NSRange)range {
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
  [attributedString setAttributes:@{ NSForegroundColorAttributeName: color } range:range];
  return attributedString;
}

- (BOOL)isEmpty {
  NSString *string =
    [[self stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"\n"
                                                                                                withString:@""];
  return !string.length;
}

- (BOOL)containsString:(NSString *)str {
  NSRange range = [self rangeOfString:str];
  return range.length != 0;
}

@end
