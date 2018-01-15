//
//  LPDSliderView.h
//  RS_SliderView
//
//  Created by Du Yingfeng on 2017/10/31.
//  Copyright © 2017年 Roman Simenok. All rights reserved.
//

#define kBorderWidth 1.0 // size of border under the slider
#define kViewCornerRadius 5.0 // view corners radius
#define kAnimationSpeed 0.1 // speed when slider change position on tap

#import <UIKit/UIKit.h>

@class LPDSliderView;
@protocol LPDSliderViewDelegate <NSObject>

@optional

-(void)sliderValueChanged:(LPDSliderView *)sender; // calls when user is swiping slider
-(void)sliderValueChangeEnded:(LPDSliderView *)sender; // calls when user touchUpInside or toucUpOutside slider

@end

@interface LPDSliderView : UIControl

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, weak) id <LPDSliderViewDelegate> delegate;
@property (nonatomic, assign) float value;


-(void)setColorsForBackground:(UIColor *)bCol foreground:(UIColor *)fCol handle:(UIColor *)hCol border:(UIColor *)brdrCol;
//-(void)removeRoundCorners:(BOOL)corners removeBorder:(BOOL)border;

-(id)initWithFrame:(CGRect)frame withHandleWith:(CGFloat)handleWidth withHandleImage:(UIImage *)handleImage;

-(void)setValue:(float)value withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion;

@end
