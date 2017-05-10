//
//  NSMutableAttributedString+LPDCheck.h
//  LPDAdditions
//
//  Created by EyreFree on 2017/4/12.
//  Copyright © 2015年 LPD. All rights reserved.
//

#import "NSMutableAttributedString+LPDCheck.h"

@implementation NSMutableAttributedString (LPDCheck)

- (BOOL)hasAttributes {
    return [self attributes].count > 0;
}

- (void)addBaseAttributes:(NSDictionary<NSString *, id> *) attributes {
    // 遍历样式并保存
    NSMutableArray *attrList = [[NSMutableArray alloc] init];
    NSMutableArray *rangeList = [[NSMutableArray alloc] init];
    [self enumerateAttributesInRange:NSMakeRange(0, self.length)
                             options:0
                          usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
                              [attrList addObject: [[NSDictionary alloc] initWithDictionary:attrs]];
                              [rangeList addObject: [NSValue valueWithRange:range]];
                          }];
    // 移除所有旧的样式
    [self setAttributes:@{} range:NSMakeRange(0, self.length)];
    // 添加基础样式
    [self addAttributes:attributes range:NSMakeRange(0, self.length)];
    // 把旧的样式添加回来
    for (int index = 0; index < attrList.count; ++index) {
        [self addAttributes:((NSDictionary<NSString *,id> *)attrList[index]) range: [((NSValue *)rangeList[index]) rangeValue]];
    }
}

- (NSDictionary<NSString *, id> *)attributes {
    for (int index = 0; index < self.length; ++index) {
        NSDictionary<NSString *, id> *tempValue = [self attributesAtIndex:index
                                                    longestEffectiveRange:nil
                                                                  inRange:NSMakeRange(index, self.length - index)];
        if (nil != tempValue && tempValue.count > 0) {
            return tempValue;
        }
    }
    return nil;
}

@end
