//
//  LPDRootTabBarController.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDMvvm.h"
#import "LPDRootTabBarController.h"
#import "LPDRootTabBarViewModel.h"

@implementation LPDRootTabBarController

#pragma mark - life cycle

+ (void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [LPDViewControllerRouter
        setViewController:NSStringFromClass(LPDRootTabBarController.class)
             forViewModel:NSStringFromClass(LPDRootTabBarViewModel.class)];
  });
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.tabBar.barTintColor = [UIColor blackColor];
}

@end
