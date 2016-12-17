//
//  LPDRootTabBarController.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDRootTabBarController.h"
#import "LPDRootTabBarViewModel.h"

@implementation LPDRootTabBarController

#pragma mark - life cycle

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [LPDViewControllerFactory
        setViewController:NSStringFromClass(LPDRootTabBarController.class)
             forViewModel:NSStringFromClass(LPDRootTabBarViewModel.class)];
  });
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tabBar.barTintColor = [UIColor blackColor];
  self.tabBar.tintColor = [UIColor colorWithHexString:@"2E937B"];
  self.tabBar.unselectedItemTintColor = [UIColor whiteColor];
}

@end
