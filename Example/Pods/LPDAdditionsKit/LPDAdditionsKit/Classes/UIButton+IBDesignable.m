//
//  UIButton+IBDesignable.m
//  LPDAdditionsKit
//
//  Created by Steve on 11/12/2017.
//

#import "UIButton+IBDesignable.h"
#import <objc/runtime.h>

@implementation UIButton (IBDesignable)

static const char CORNER_RADIUS = '\0';

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self willChangeValueForKey:@"CUSTOM_CORNER_RADIUS"]; // KVO
    objc_setAssociatedObject(self, &CORNER_RADIUS, [NSNumber numberWithDouble:cornerRadius], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"CUSTOM_CORNER_RADIUS"]; // KVO
    self.layer.cornerRadius = cornerRadius;
    self.layer.masksToBounds = YES;
}

- (CGFloat)cornerRadius {
    return [objc_getAssociatedObject(self, &CORNER_RADIUS) floatValue];
}

@end
