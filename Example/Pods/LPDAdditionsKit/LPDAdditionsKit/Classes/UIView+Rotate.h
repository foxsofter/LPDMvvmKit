//
//  UIView+Rotate.h
//  LPDSuspendedButton_Example
//
//  Created by Assuner on 2017/10/20.
//  Copyright © 2017年 Assuner-Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Rotate)

- (void)startRotatingWithDuration:(NSTimeInterval)time;
- (void)stopRotating;
- (void)rotateWithAngle:(CGFloat)angle duration:(NSTimeInterval)time completion:(void(^)(void))completion;

@end
