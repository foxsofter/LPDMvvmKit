//
//  LPDPlusCrossBarButtonItem.h
//  FoxKit
//
//  Created by fox softer on 15/10/25.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  @brief  Plus UIBarButtonItem & Close UIBarButtonItem switching
 */
@interface LPDPlusCrossBarButtonItem : UIBarButtonItem

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem
                                     target:(id)target
                                     action:(SEL)action NS_UNAVAILABLE;
- (instancetype)initWithCustomView:(UIView *)customView NS_UNAVAILABLE;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_UNAVAILABLE;
- (instancetype)initWithImage:(UIImage *)image
          landscapeImagePhone:(UIImage *)landscapeImagePhone
                        style:(UIBarButtonItemStyle)style
                       target:(id)target
                       action:(SEL)action NS_UNAVAILABLE;
- (instancetype)initWithTitle:(NSString *)title
                        style:(UIBarButtonItemStyle)style
                       target:(id)target
                       action:(SEL)action NS_UNAVAILABLE;

- (instancetype)initWithOpenImage:(UIImage *)openImage closeImage:(UIImage *)closeImage;

@property (nonatomic, strong, readonly) UIImage *openImage;   // normal state image
@property (nonatomic, strong, readonly) UIImage *closedImage; // opened state image
@property (nonatomic, assign) NSTimeInterval duration;        // default is 0.2f

@property (readonly, assign, getter=isOpening) BOOL opening;

- (void)open;
- (void)close;

@property (nonatomic, copy) void (^openBlock)();
@property (nonatomic, copy) void (^closeBlock)();

@end
