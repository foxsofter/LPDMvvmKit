//
//  LPDSliderView.m
//  RS_SliderView
//
//  Created by Du Yingfeng on 2017/10/31.
//  Copyright © 2017年 Roman Simenok. All rights reserved.
//

#import "LPDSliderView.h"
@interface LPDSliderView ()
@property (nonatomic, strong) UIView *foregroundView;
@property (nonatomic, strong) UIImageView *handleView;
@property (nonatomic, assign) CGFloat handleWidth;
@property (nonatomic, strong) UIImage *handleImage;
//@property (nonatomic, assign) float value;

@end


@implementation LPDSliderView

-(id)initWithFrame:(CGRect)frame withHandleWith:(CGFloat)handleWidth withHandleImage:(UIImage *)handleImage{
    if (self = [super initWithFrame:frame]) {
        [self initSlider];
        self.handleWidth = handleWidth;
        self.handleImage = handleImage;
    }
    
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super initWithCoder:aDecoder]) {
        [self initSlider];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = CGRectMake(44, 0, self.frame.size.width-44, self.frame.size.height);
}


-(void)initSlider {
    self.foregroundView = [[UIView alloc] init];
    self.handleView = [[UIImageView alloc] init];
    self.handleView.layer.cornerRadius = kViewCornerRadius;
    self.handleView.layer.masksToBounds = YES;
    
    self.label = [[UILabel alloc] initWithFrame:self.bounds];
    
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont fontWithName:@"Helvetica" size:24];
    [self addSubview:self.label];
    [self addSubview:self.foregroundView];
    [self addSubview:self.handleView];
    
    self.layer.cornerRadius = kViewCornerRadius;
    self.layer.masksToBounds = YES;
    [self.layer setBorderWidth:kBorderWidth];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMoveGesture:)];
    self.handleView.userInteractionEnabled = YES;
    [self.handleView addGestureRecognizer:panGesture];
    
    // set defauld value for slider. Value should be between 0 and 1
    [self setValue:0.0 withAnimation:NO completion:nil];
}

static float handleViewLeft = 0.0f;

-(void)panMoveGesture:(UIPanGestureRecognizer *)recognizer{
    CGPoint __block point = [recognizer translationInView:self.handleView];
    NSLog(@"point = %@", NSStringFromCGPoint(point));
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            handleViewLeft = self.handleView.frame.origin.x;
        case UIGestureRecognizerStateChanged:
        {
            CGFloat pointX = point.x+handleViewLeft;
            pointX = MIN(self.frame.size.width - self.handleView.frame.size.width, MAX(0, pointX));
            self.value = (pointX + self.handleView.frame.size.width)/self.frame.size.width;
            __weak __typeof(self)weakSelf = self;
            [UIView animateWithDuration:kAnimationSpeed animations:^ {
                weakSelf.handleView.frame = CGRectMake(pointX, 0, self.handleView.frame.size.width, self.handleView.frame.size.height);
                weakSelf.foregroundView.frame = CGRectMake(0, 0, self.handleView.frame.origin.x+self.handleView.frame.size.width/2, self.frame.size.height);
            } completion:^(BOOL finished) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sliderValueChanged:)]) {
                    [weakSelf.delegate sliderValueChanged:weakSelf];
                }
            }];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGRect frame = CGRectMake(0, 0, self.handleView.frame.size.width, self.handleView.frame.size.height);
            if (self.handleView.frame.origin.x + self.handleView.frame.size.width > 0.75 * self.frame.size.width) {
                frame = CGRectMake(self.frame.size.width - self.handleView.frame.size.width, 0, self.handleView.frame.size.width, self.handleView.frame.size.height);
                self.value = 1.0;
                //                [self setValue:1.0 withAnimation:NO completion:nil];
            }else{
                //                [self setValue:0.0 withAnimation:NO completion:nil];
                self.value = 0.0;
            }
            __weak __typeof(self)weakSelf = self;
            [UIView animateWithDuration:kAnimationSpeed animations:^ {
                weakSelf.handleView.frame = frame;
                weakSelf.foregroundView.frame = CGRectMake(0, 0, self.handleView.frame.origin.x + self.handleView.frame.size.width/2, self.frame.size.height);
            } completion:^(BOOL finished) {
                NSLog(@"===================end===========");
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(sliderValueChangeEnded:)]) {
                    [weakSelf.delegate sliderValueChangeEnded:weakSelf];
                }
            }];
            break;
        }
        default:
            break;
    }
    
}


#pragma mark - Set Value

-(void)setValue:(float)value withAnimation:(bool)isAnimate completion:(void (^)(BOOL finished))completion {
    NSAssert((value >= 0.0)&&(value <= 1.0), @"Value must be between 0 and 1");
    
    if (value < 0) {
        value = 0;
    }
    
    if (value > 1) {
        value = 1;
    }
    
    CGPoint point;
    point = CGPointMake(value * self.frame.size.width, 0);
    
    if(isAnimate) {
        __weak __typeof(self)weakSelf = self;
        
        [UIView animateWithDuration:kAnimationSpeed animations:^ {
            [weakSelf changeStarForegroundViewWithPoint:point];
            
        } completion:^(BOOL finished) {
            if (completion) {
                completion(finished);
            }
        }];
    } else {
        [self changeStarForegroundViewWithPoint:point];
    }
}

#pragma mark - Other methods

-(void)setColorsForBackground:(UIColor *)bCol foreground:(UIColor *)fCol handle:(UIColor *)hCol border:(UIColor *)brdrCol {
    self.backgroundColor = bCol;
    self.foregroundView.backgroundColor = fCol;
    self.handleView.backgroundColor = hCol;
    [self.layer setBorderColor:brdrCol.CGColor];
}

-(void)setHandleImage:(UIImage *)handleImage{
    _handleImage = handleImage;
    _handleView.image = handleImage;
    _handleView.contentMode = UIViewContentModeCenter;
    
    [_handleView sizeToFit];
    [self setValue:0.0 withAnimation:NO completion:nil];
}

-(void)removeRoundCorners:(BOOL)corners removeBorder:(BOOL)borders {
    if (corners) {
        self.layer.cornerRadius = 0.0;
        self.layer.masksToBounds = YES;
    }
    if (borders) {
        [self.layer setBorderWidth:0.0];
    }
}

#pragma mark - Change Slider Foreground With Point

- (void)changeStarForegroundViewWithPoint:(CGPoint)point {
    CGPoint p = point;
    
    if (p.x < 0) {
        p.x = 0;
    }
    
    if (p.x > self.frame.size.width) {
        p.x = self.frame.size.width;
    }
    
    self.value = p.x / self.frame.size.width;
    self.foregroundView.frame = CGRectMake(0, 0, p.x, self.frame.size.height);
    
    if (self.foregroundView.frame.size.width <= 0) {
        self.handleView.frame = CGRectMake(0, 0, self.handleWidth, self.foregroundView.frame.size.height);
        [self.delegate sliderValueChanged:self]; // or use sliderValueChangeEnded method
    }else if (self.foregroundView.frame.size.width >= self.frame.size.width) {
        self.handleView.frame = CGRectMake(self.foregroundView.frame.size.width-self.handleWidth, 0, self.handleWidth, self.foregroundView.frame.size.height);
        [self.delegate sliderValueChanged:self]; // or use sliderValueChangeEnded method
    }else{
        self.handleView.frame = CGRectMake(self.foregroundView.frame.size.width-self.handleWidth/2, 0, self.handleWidth, self.foregroundView.frame.size.height);
    }
    
}

@end
