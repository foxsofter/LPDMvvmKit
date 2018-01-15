//
//  NSString+URL.m
//  LPDBusiness
//
//  Created by ouyang on 16/6/7.
//  Copyright © 2016年 ELM. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)
- (nullable NSString *)lpd_urlEncode {
  return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

- (nullable NSString *)lpd_urlDecode {
  return [self stringByRemovingPercentEncoding];
}
@end
