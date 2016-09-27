//
//  LPDPopupActionSheet.h
//  FoxKit
//
//  Created by foxsofter on 15/10/9.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @author foxsofter, 15-10-09 09:10:19
 *
 *  @brief  popup action sheet
 */
@interface LPDPopupActionSheet : NSObject

#pragma mark - show action sheet without title

+ (void)show:(NSString *)title action:(void (^)(void))action;

+ (void)show:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2;

+ (void)show:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3;

+ (void)show:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3
      title4:(NSString *)title4
     action4:(void (^)(void))action4;

#pragma mark - show action sheet with title.

+ (void)show:(NSString *)caption title:(NSString *)title action:(void (^)(void))action;

+ (void)show:(NSString *)caption
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2;

+ (void)show:(NSString *)caption
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3;

+ (void)show:(NSString *)caption
      title1:(NSString *)title1
     action1:(void (^)(void))action1
      title2:(NSString *)title2
     action2:(void (^)(void))action2
      title3:(NSString *)title3
     action3:(void (^)(void))action3
      title4:(NSString *)title4
     action4:(void (^)(void))action4;

@end
