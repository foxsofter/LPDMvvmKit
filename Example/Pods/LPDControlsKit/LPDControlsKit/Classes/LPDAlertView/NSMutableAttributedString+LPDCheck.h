//
//  NSMutableAttributedString+LPDCheck.h
//  LPDAdditions
//
//  Created by EyreFree on 2017/4/12.
//  Copyright © 2015年 LPD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (LPDCheck)

// 检查是否具有样式
- (BOOL)hasAttributes;

// 为空白部分添加基本样式
- (void)addBaseAttributes:(NSDictionary<NSString *, id> *) attributes;

@end
