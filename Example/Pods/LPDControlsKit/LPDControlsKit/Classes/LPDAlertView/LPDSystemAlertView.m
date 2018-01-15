//
//  LPDSystemAlertView.m
//  LPDMvvmKit
//
//  Created by EyreFree on 2017/4/13.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDSystemAlertView.h"
#import <Masonry/Masonry.h>
#import "NSMutableArray+LPDStack.h"
#import "UIButton+LPDAddition.h"
#import "UIColor+LPDAddition.h"
#import "UIControl+Block.h"
#import "UIScreen+LPDAccessor.h"
#import "UIView+LPDAccessor.h"
#import "UIView+LPDBorders.h"
#import "NSMutableAttributedString+LPDCheck.h"

#define LPDSYSTEMALERTVIEW_MESSAGELABEL_TAG 2333

@implementation LPDAttributedAlertAction

@end

@interface LPDSystemAlertView ()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIControl *contentView;
@property (nonatomic, copy) NSString *caption;
@property (nonatomic, copy) NSArray *actions;
@property (nonatomic, strong) NSMutableArray *buttons;

@end

@implementation LPDSystemAlertView

- (void)dealloc {
    NSLog(@"LPDSystemAlertView");
}

#pragma mark - show alert view with title

+ (void)show:(NSString *)caption
     message:(NSString *)message
      action:(LPDAlertAction *)action {

    NSAttributedString *attributedCaption = caption ? [[NSAttributedString alloc] initWithString:caption] : nil;
    NSAttributedString *attributedMessage = message ? [[NSAttributedString alloc] initWithString:message] : nil;

    LPDAttributedAlertAction *attributedAction = [[LPDAttributedAlertAction alloc] init];
    attributedAction.actionType = action.actionType;
    attributedAction.action = action.action;
    attributedAction.attributedTitle = action.title ? [[NSAttributedString alloc] initWithString:action.title] : nil;

    [self show:attributedCaption attributedMessage:attributedMessage attributedActions:@[attributedAction]];
}

+ (void)show:(NSString *)caption
     message:(NSString *)message
     action1:(LPDAlertAction *)action1
     action2:(LPDAlertAction *)action2 {

    NSAttributedString *attributedCaption = caption ? [[NSAttributedString alloc] initWithString:caption] : nil;
    NSAttributedString *attributedMessage = message ? [[NSAttributedString alloc] initWithString:message] : nil;

    LPDAttributedAlertAction *attributedAction1 = [[LPDAttributedAlertAction alloc] init];
    attributedAction1.actionType = action1.actionType;
    attributedAction1.action = action1.action;
    attributedAction1.attributedTitle = action1.title ? [[NSAttributedString alloc] initWithString:action1.title] : nil;

    LPDAttributedAlertAction *attributedAction2 = [[LPDAttributedAlertAction alloc] init];
    attributedAction2.actionType = action2.actionType;
    attributedAction2.action = action2.action;
    attributedAction2.attributedTitle = action2.title ? [[NSAttributedString alloc] initWithString:action2.title] : nil;

    [self show:attributedCaption attributedMessage:attributedMessage attributedActions:@[attributedAction1, attributedAction2]];
}

#pragma mark - show alert view with attributed string

+ (void)show:(NSAttributedString *)attributedCaption
attributedMessage:(NSAttributedString *)attributedMessage
attributedAction:(LPDAttributedAlertAction *)attributedAction {
    [self show:attributedCaption attributedMessage:attributedMessage attributedActions:@[attributedAction]];
}

+ (void)show:(NSAttributedString *)attributedCaption
attributedMessage:(NSAttributedString *)attributedMessage
attributedAction1:(LPDAttributedAlertAction *)attributedAction1
attributedAction2:(LPDAttributedAlertAction *)attributedAction2 {
    [self show:attributedCaption attributedMessage:attributedMessage attributedActions:@[attributedAction1, attributedAction2]];
}

#pragma mark - hide or exit.

+ (void)hideAll {
    for (NSInteger i = self.alertViews.count - 1; i >= 0; i--) {
        LPDSystemAlertView *alertView = self.alertViews[i];
        [self.alertViews removeObjectAtIndex:i];
        [alertView hide];
    }
}

+ (void)hideWith:(NSString *)caption {
    [self hideWith:caption animated:YES];
}

+ (void)hideWith:(NSString *)caption animated:(BOOL)animated {
    for (NSInteger i = self.alertViews.count - 1; i >= 0; i--) {
        LPDSystemAlertView *alertView = self.alertViews[i];
        if ([alertView.caption isEqualToString:caption]) {
            [self.alertViews removeObjectAtIndex:i];
            if (animated) {
                [alertView hide:nil];
            } else {
                [alertView remove:nil];
            }
        }
    }
}

+ (BOOL)existWith:(NSString *)caption {
    for (NSInteger i = self.alertViews.count - 1; i >= 0; i--) {
        LPDSystemAlertView *alertView = self.alertViews[i];
        if ([alertView.caption isEqualToString:caption]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - private methods

+ (NSMutableArray *)alertViews {
    static NSMutableArray *alerts;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alerts = [NSMutableArray array];
    });
    return alerts;
}

+ (void)show:(NSAttributedString *)attributedCaption
attributedMessage:(NSAttributedString *)attributedMessage
attributedActions:(NSArray<LPDAttributedAlertAction *> *)attributedActions {
    @synchronized(self) {
        LPDSystemAlertView *alertView = [[self alertViews] peekObject];
        if (alertView) {
            [alertView hide];
        }
        alertView = [[LPDSystemAlertView alloc] init];

        NSMutableAttributedString *mutableAttributedCaption = attributedCaption ? [[NSMutableAttributedString alloc] initWithAttributedString:attributedCaption] : nil;
        NSMutableAttributedString *mutableAttributedMessage = attributedMessage ? [[NSMutableAttributedString alloc] initWithAttributedString:attributedMessage] : nil;

        [alertView show:mutableAttributedCaption attributedMessage:mutableAttributedMessage attributedActions:attributedActions];
        [[self alertViews] pushObject:alertView];
    }
}

- (void)show:(NSMutableAttributedString *)attributedCaption
attributedMessage:(NSMutableAttributedString *)attributedMessage
attributedActions:(NSArray<LPDAttributedAlertAction *> *)attributedActions {

    _backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.width, UIScreen.height)];

    _contentView = [[UIControl alloc] init];
    _contentView.backgroundColor = [UIColor colorWithHexString:@"#f9f9f9"];
    _contentView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    _contentView.layer.cornerRadius = 14;
    _contentView.clipsToBounds = YES;
    _contentView.userInteractionEnabled = YES;
    [_contentView addTarget:self action:@selector(contentTouchDragInsideAndDown:forEvent:) forControlEvents:UIControlEventTouchDragInside];
    [_contentView addTarget:self action:@selector(contentTouchDragInsideAndDown:forEvent:) forControlEvents:UIControlEventTouchDown];
    [_contentView addTarget:self action:@selector(contentTouchUpInside:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addTarget:self action:@selector(contentTouchUpOutside:forEvent:) forControlEvents:UIControlEventTouchUpOutside];
    [_backgroundView addSubview:_contentView];

    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(UIScreen.width * 0.14));
        make.right.equalTo(@(-UIScreen.width * 0.14));
        make.center.equalTo(self.backgroundView);
        make.height.greaterThanOrEqualTo(@80);
    }];

    UILabel *captionLabel = nil;
    if (attributedCaption && attributedCaption.length > 0) {
        captionLabel = [[UILabel alloc] init];
        if (NO == [attributedCaption hasAttributes]) {
            captionLabel.text = attributedCaption.string;
            captionLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            captionLabel.font = [UIFont systemFontOfSize:17];
        } else {
            [attributedCaption addBaseAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],
                                                   NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
            captionLabel.attributedText = attributedCaption;
        }
        captionLabel.numberOfLines = 0;
        captionLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:captionLabel];
        [captionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@20);
            make.left.equalTo(@22);
            make.right.equalTo(@(-22));
        }];
    }

    UILabel *messageLabel = nil;
    if (attributedMessage && attributedMessage.length > 0) {
        messageLabel = [[UILabel alloc] init];
        if (NO == [attributedMessage hasAttributes]) {
            messageLabel.text = attributedMessage.string;
            messageLabel.textColor = [UIColor colorWithHexString:@"#333333"];
            messageLabel.font = [UIFont systemFontOfSize:13];
        } else {
            [attributedMessage addBaseAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13],
                                                   NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#333333"]}];
            messageLabel.attributedText = attributedMessage;
        }
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.tag = LPDSYSTEMALERTVIEW_MESSAGELABEL_TAG;
        [_contentView addSubview:messageLabel];
        [messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.right.equalTo(@(-20));
            if (attributedCaption) {
                make.top.equalTo(captionLabel.mas_bottom).with.offset(4);
            } else {
                make.top.equalTo(@20);
            }
        }];
    }

    UIButton *button = nil;
    CGFloat buttonWidth = UIScreen.width * 0.73 / attributedActions.count;
    CGFloat left = 0;
    _buttons = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < attributedActions.count; i++) {
        LPDAttributedAlertAction *action = [attributedActions objectAtIndex:i];
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, buttonWidth, 44);

        NSMutableAttributedString *actionAttributedTitle = action.attributedTitle ? [[NSMutableAttributedString alloc] initWithAttributedString:action.attributedTitle] : nil;
        if (NO == [actionAttributedTitle hasAttributes]) {
            [button setTitle:actionAttributedTitle.string forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:16];
        } else {
            [attributedCaption addBaseAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
            [button setAttributedTitle:actionAttributedTitle forState:UIControlStateNormal];
        }

        button.contentMode = UIViewContentModeCenter;
        button.userInteractionEnabled = NO;
        button.tag = i;
        //[button setBackgroundColor:[UIColor colorWithHexString:@"#ebebeb"] forState:UIControlStateHighlighted];
        [_contentView addSubview:button];
        [_buttons addObject:button];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(left));
            make.bottom.equalTo(@0);
            make.width.equalTo(@(buttonWidth));
            make.height.equalTo(@44);
        }];

        left += buttonWidth;

        if (action.actionType == LPDAlertActionTypeDefault) {
            [button setTitleColor:[UIColor colorWithHexString:@"#008AF1"] forState:UIControlStateNormal];
        } else if (action.actionType == LPDAlertActionTypeDestructive) {
            [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        } else {
            [button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        }

        if (i == 0) {
            [button setBorder:0.5
                  borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.18]
               borderPosition:LPDUIViewBorderPositionTop];
        } else {
            [button setBorder:0.5
                  borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.18]
               borderPosition:LPDUIViewBorderPositionTop | LPDUIViewBorderPositionLeft];
        }

        __weak typeof (self) weakSelf = self;
        [button touchUpInside:^{
            __strong typeof (self) strongSelf = weakSelf;
            if (strongSelf) {
                [self hide:action.action];
            }
        }];

        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (messageLabel) {
                make.top.equalTo(messageLabel.mas_bottom).with.offset(20).priority(MASLayoutPriorityFittingSizeLevel);
            } else if (captionLabel) {
                make.top.equalTo(captionLabel.mas_bottom).with.offset(20).priority(MASLayoutPriorityFittingSizeLevel);
            } else {
                make.top.equalTo(@20).priority(MASLayoutPriorityFittingSizeLevel);
            }
        }];
    }
    [self show];
}

- (IBAction)contentTouchDragInsideAndDown:(UIControl *)control forEvent:(UIEvent*)event {
    CGPoint location = [[[event touchesForView:control] anyObject] locationInView:control];
    int targetIndex = -1;
    for (int index = 0; index < _buttons.count; ++index) {
        UIButton *button = _buttons[index];
        if ([self isPoint:location inRect:button.frame]) {
            targetIndex = index;
        } else {
            [self setButton:button selected:NO];
        }
    }
    if (YES == targetIndex > -1) {
        [self setButton:_buttons[targetIndex] selected:YES];
    }
}

- (IBAction)contentTouchUpInside:(UIControl *)control forEvent:(UIEvent*)event {
    CGPoint location = [[[event touchesForView:control] anyObject] locationInView:control];
    for (UIButton * button in _buttons) {
        if ([self isPoint:location inRect:button.frame]) {
            [button sendActionsForControlEvents: UIControlEventTouchUpInside];
        }
    }
}

- (IBAction)contentTouchUpOutside:(UIControl *)control forEvent:(UIEvent*)event {
    for (UIButton * button in _buttons) {
        [self setButton:button selected:NO];
    }
}

- (BOOL)isPoint:(CGPoint)point inRect:(CGRect)rect {
    if(point.x > CGRectGetMinX(rect) && point.x < CGRectGetMaxX(rect)
       && point.y > CGRectGetMinY(rect) && point.y < CGRectGetMaxY(rect)) {
        return YES;
    }
    return NO;
}

- (void)setButton:(UIButton *)button selected:(BOOL)selected {
    // BG
    [button setBackgroundColor:[UIColor colorWithHexString:selected == YES ? @"#ebebeb" : @"#f9f9f9"] forState:UIControlStateNormal];

    // Border
    if (YES == selected) {
        if ((_buttons.count - 1) == button.tag) {
            [button setBorder:0.5
                  borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.18]
               borderPosition:LPDUIViewBorderPositionTop];
        } else {
            [button setBorder:0.5
                  borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.18]
               borderPosition:LPDUIViewBorderPositionTop];
            [_buttons[button.tag + 1] setBorder:0.5
                                    borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.18]
                                 borderPosition:LPDUIViewBorderPositionTop];
        }
    } else {
        if (button.tag == 0) {
            [button setBorder:0.5
                  borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.18]
               borderPosition:LPDUIViewBorderPositionTop];
        } else {
            [button setBorder:0.5
                  borderColor:[[UIColor blackColor] colorWithAlphaComponent:0.18]
               borderPosition:LPDUIViewBorderPositionTop | LPDUIViewBorderPositionLeft];
        }
    }
}

- (void)show {
    NSEnumerator *frontToBackWindows = [[[UIApplication sharedApplication] windows] reverseObjectEnumerator];

    for (UIWindow *window in frontToBackWindows) {
        if (window.windowLevel == UIWindowLevelNormal && !window.hidden) {
            [window addSubview:_backgroundView];
            break;
        }
    }
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.contentView.alpha = 0.01;
    self.contentView.transform = CGAffineTransformMakeScale(1.18, 1.18);

    // 一行居中 多行居左
    [_contentView layoutSubviews];
    UILabel *messageLabel = [_contentView viewWithTag:LPDSYSTEMALERTVIEW_MESSAGELABEL_TAG];
    if (messageLabel.frame.size.height > 20) {
        messageLabel.textAlignment = NSTextAlignmentLeft;
    }

    [UIView animateWithDuration:0.24
                     animations:^{
                         self.backgroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                         self.contentView.transform = CGAffineTransformMakeScale(1, 1);
                         self.contentView.alpha = 1;
                     }];
}

- (void)hide:(void (^)(void))completion {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.contentView.alpha = 0.01;
                         self.backgroundView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {
                         [self remove:completion];
                     }];
}

- (void)remove:(void (^)(void))completion {
    [self.backgroundView removeFromSuperview];
    self.backgroundView = nil;
    [[self.class alertViews] removeObject:self];
    LPDSystemAlertView *alertView = [[self.class alertViews] peekObject];
    if (alertView) {
        [alertView show];
    }
    if (completion) {
        completion();
    }
}

- (void)hide {
    [UIView animateWithDuration:0.2
                     animations:^{
                         self.contentView.alpha = 0.01;
                         self.backgroundView.backgroundColor = [UIColor clearColor];
                     }
                     completion:^(BOOL finished) {
                         [self.backgroundView removeFromSuperview];
                     }];
}

@end
