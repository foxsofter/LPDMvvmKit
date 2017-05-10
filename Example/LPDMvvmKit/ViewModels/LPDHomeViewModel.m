//
//  LPDHomeViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDHomeViewModel.h"
#import <LPDMvvmKit/LPDMvvmKit.h>

@implementation LPDHomeViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"navigation";
    self.tabBarItemImage = @"navigation";
    self.tabBarItemTitle = @"navigation";
  }
  return self;
}

- (void)pushViewModel {
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  [self.navigation pushViewModel:vm animated:YES];
}

- (void)popViewModel {
  [self.navigation popViewModelAnimated:YES];
}

- (void)popToRootViewModel {
  [self.navigation popToRootViewModelAnimated:YES];
}

- (void)presentViewModel {
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  [self.navigation presentNavigationViewModel:[[LPDNavigationViewModel alloc] initWithRootViewModel:vm]
                                     animated:YES
                                   completion:nil];
}

- (void)dismissViewModel {
  [self.navigation dismissNavigationViewModelAnimated:YES
                                           completion:^{
                                             
                                           }];
}

- (void)dealloc {
  NSLog(@"fwfwfw");
}

@end
