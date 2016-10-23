//
//  LPDAlertView.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/4/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LPDAlertActionType) {
  LPDAlertActionTypeDefault,
  LPDAlertActionTypeCancel,
  LPDAlertActionTypeDestructive,
};

@interface LPDAlertAction : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void (^action)(void);

@property (nonatomic, assign) LPDAlertActionType actionType;

@end

/**
 *  @brief 支持重复弹出，后来居上
 */
@interface LPDAlertView : NSObject

#pragma mark - show alert view without title

+ (void)show:(NSString *)message title:(NSString *)title action:(void (^)(void))action;

+ (void)show:(NSString *)message
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2;

+ (void)show:(NSString *)message action:(LPDAlertAction *)action;

+ (void)show:(NSString *)message action1:(LPDAlertAction *)action1 action2:(LPDAlertAction *)action2;

#pragma mark - show alert view with title.

+ (void)show:(NSString *)caption message:(NSString *)message title:(NSString *)title action:(void (^)(void))action;

+ (void)show:(NSString *)caption
     message:(NSString *)message
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2;

+ (void)show:(NSString *)caption message:(NSString *)message action:(LPDAlertAction *)action;

+ (void)show:(NSString *)caption
     message:(NSString *)message
     action1:(LPDAlertAction *)action1
     action2:(LPDAlertAction *)action2;

+ (void)hideAll;

+ (void)hideWith:(NSString *)caption animated:(BOOL)animated;

+ (BOOL)existWith:(NSString *)caption;

@end
