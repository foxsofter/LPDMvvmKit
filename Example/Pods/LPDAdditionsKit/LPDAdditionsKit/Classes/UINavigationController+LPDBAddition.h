//
//  UINavigationController+LPDBAddition.h
//  LPDBusiness
//
//  Created by ZhengYidong on 9/27/16.
//  Copyright © 2016 LPD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (LPDBAddition)

-(void)popToViewControllerWithClassName:(NSString *)vcClassName animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
