//
//  NSString+URL.h
//  LPDBusiness
//
//  Created by ouyang on 16/6/7.
//  Copyright © 2016年 ELM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)

- (nullable NSString *)lpd_urlEncode;

- (nullable NSString *)lpd_urlDecode;

@end
