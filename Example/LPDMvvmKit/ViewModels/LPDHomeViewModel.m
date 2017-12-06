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

- (void)popToViewModel {
    NSInteger count = self.navigation.viewModels.count;
    NSInteger num = 0;
    if (count > 1) {
        num = 1;
        LPDHomeViewModel *vm = self.navigation.viewModels[num];
        [self.navigation popToViewModel:vm animated:YES];
    } else {
        return;
    }
    
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

- (void)setViewModels {
    LPDHomeViewModel *vm1 = [[LPDHomeViewModel alloc] init];
    vm1.title =  @"vm1";
    LPDHomeViewModel *vm2 = [[LPDHomeViewModel alloc] init];
    vm2.title =  @"vm2";
    LPDHomeViewModel *vm3 = [[LPDHomeViewModel alloc] init];
    vm3.title =  @"vm3";
//    NSArray *vms = @[vm1,vm2,vm3];
    NSMutableArray *vms = [[NSMutableArray alloc] init];
    [vms addObject:vm1];
    [vms addObject:vm2];
    [vms addObject:vm3];
    [self.navigation setViewModels:vms animated:YES];
}

- (void)dealloc {
  NSLog(@"fwfwfw");
}

@end
