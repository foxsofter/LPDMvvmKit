//
//  LPDSystemAlertView.h
//  LPDMvvmKit
//
//  Created by EyreFree on 2017/4/13.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPDAlertView.h"

@interface LPDAttributedAlertAction : NSObject

@property (nonatomic, copy) NSAttributedString *attributedTitle;

@property (nonatomic, copy) void (^action)(void);

@property (nonatomic, assign) LPDAlertActionType actionType;

@end

/**
 *  @brief 支持重复弹出，后来居上
 */
@interface LPDSystemAlertView : NSObject

#pragma mark - show alert view with normal string

+ (void)show:(NSString *)caption
     message:(NSString *)message
      action:(LPDAlertAction *)action;

+ (void)show:(NSString *)caption
     message:(NSString *)message
     action1:(LPDAlertAction *)action1
     action2:(LPDAlertAction *)action2;

#pragma mark - show alert view with attributed string

+ (void)show:(NSAttributedString *)attributedCaption
attributedMessage:(NSAttributedString *)attributedMessage
attributedAction:(LPDAttributedAlertAction *)attributedAction;

+ (void)show:(NSAttributedString *)attributedCaption
attributedMessage:(NSAttributedString *)attributedMessage
attributedAction1:(LPDAttributedAlertAction *)attributedAction1
attributedAction2:(LPDAttributedAlertAction *)attributedAction2;

#pragma mark - hide or exit.

+ (void)hideAll;

+ (void)hideWith:(NSString *)caption;

+ (void)hideWith:(NSString *)caption animated:(BOOL)animated;

+ (BOOL)existWith:(NSString *)caption;

@end
