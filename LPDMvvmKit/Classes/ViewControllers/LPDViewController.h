//
//  LPDViewController.h
//  LPDMvvm
//
//  Created by foxsofter on 15/10/11.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDViewControllerProtocol.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LPDViewController) <LPDViewControllerProtocol>

@end

@interface LPDViewController : UIViewController <LPDViewControllerProtocol>
{
@private
    UIView *_previewOverlay;
    UIView *_retryOverlay;
}
/**
 *  @brief 禁用无关函数
 */
+ (instancetype) new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithNibName:(nullable NSString *)nibNameOrNil
                         bundle:(nullable NSBundle *)nibBundleOrNil NS_UNAVAILABLE;
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated:(BOOL)flag
                   completion:(void (^__nullable)(void))completion NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
