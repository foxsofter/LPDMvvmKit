//
//  UINavigationController+LPDBAddition.m
//  LPDBusiness
//
//  Created by ZhengYidong on 9/27/16.
//  Copyright © 2016 LPD. All rights reserved.
//

#import "UINavigationController+LPDBAddition.h"

@implementation UINavigationController (LPDBAddition)

-(void)popToViewControllerWithClassName:(NSString *)vcClassName animated:(BOOL)animated {
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:NSClassFromString(vcClassName)]) {
            [self popToViewController:vc animated:animated];
        }
    }
}

@end
