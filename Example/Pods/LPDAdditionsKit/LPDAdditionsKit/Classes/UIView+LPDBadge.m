//
//  UIView+LPDBadge.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/15.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "NSObject+LPDAssociatedObject.h"

#import "UIColor+LPDAddition.h"
#import "UIView+LPDBadge.h"

@interface UIView ()

@property (nonatomic, strong) UIView *badgeView;

@end

@implementation UIView (LPDBadge)

#pragma mark - properties
- (NSString *)badgeString {
    return [self object:@selector(setBadgeString:)];
}

- (void)setBadgeString:(NSString *)badgeString {
    [self setCopyNonatomicObject:badgeString withKey:@selector(setBadgeString:)];
}

- (BOOL)shouldShowBadge {
    return [[self object:@selector(setShouldShowBadge:)] boolValue];
}

- (void)setShouldShowBadge:(BOOL)shouldShowBadge {
    [self setRetainNonatomicObject:@(shouldShowBadge) withKey:@selector(setShouldShowBadge:)];
    
    if (self) {
        if (shouldShowBadge) {
            if(self.badgeString){
                if (self.badgeLabel == nil) {
                    self.badgeLabel = [[UILabel alloc] init];
                    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
                    self.badgeLabel.textColor = [UIColor whiteColor];
                    self.badgeLabel.font = [UIFont systemFontOfSize:10];
                    self.badgeLabel.layer.cornerRadius = 6;
                    self.badgeLabel.layer.masksToBounds = YES;
                    self.badgeLabel.backgroundColor = [UIColor colorWithHexString:@"#FD3B46"];
                    self.badgeLabel.numberOfLines = 0;
                    [self addSubview:self.badgeLabel];
                    if (self.badgeConfigBlock) {
                        self.badgeConfigBlock(self.badgeLabel);
                    }
                }
                self.badgeLabel.text = self.badgeString;
                //                [self.badgeLabel sizeToFit];
                
            }
            else {
                if (self.badgeView == nil) {
                    self.badgeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
                    self.badgeView.layer.cornerRadius = 3;
                    self.badgeView.backgroundColor = [UIColor colorWithHexString:@"#FF5E1C"];
                    [self addSubview:self.badgeView];
                    if (self.badgeConfigBlock) {
                        self.badgeConfigBlock(self.badgeView);
                    }
                }
            }
        }
        if (!shouldShowBadge && self.badgeView) {
            [self.badgeView removeFromSuperview];
            self.badgeView = nil;
        }
        if (!shouldShowBadge && self.badgeLabel){
            [self.badgeLabel removeFromSuperview];
            self.badgeLabel = nil;
        }
    }
}

- (void (^)(UIView *))badgeConfigBlock {
    return [self object:@selector(setBadgeConfigBlock:)];
}

- (void)setBadgeConfigBlock:(void (^)(UIView *))badgeConfigBlock {
    [self setCopyNonatomicObject:badgeConfigBlock withKey:@selector(setBadgeConfigBlock:)];
}

- (UIView *)badgeView {
    return [self object:@selector(setBadgeView:)];
}

- (void)setBadgeView:(UIView *)badgeView {
    [self setRetainNonatomicObject:badgeView withKey:@selector(setBadgeView:)];
}

- (UILabel *)badgeLabel{
    return [self object:@selector(setBadgeLabel:)];
}

- (void)setBadgeLabel:(UILabel *)badgeLabel{
    [self setRetainNonatomicObject:badgeLabel withKey:@selector(setBadgeLabel:)];
}

@end
