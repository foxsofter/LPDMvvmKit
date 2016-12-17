//
//  LPDReactViewController.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDReactViewController.h"
#import "LPDReactViewModel.h"
#import "LPDToastView.h"

@interface LPDReactViewController ()


@end

@implementation LPDReactViewController

- (instancetype)initWithViewModel:(id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    LPDReactViewModel *selfViewModel = viewModel;
    if (selfViewModel.tabBarItemImage) {
      self.tabBarItem =
      [[UITabBarItem alloc] initWithTitle:nil
                                    image:[UIImage imageNamed:selfViewModel.tabBarItemImage] tag:0];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  LPDReactViewModel *selfViewModel = self.viewModel;
  UIBarButtonItem *saveBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"save" style:UIBarButtonItemStylePlain target:nil action:nil];
  saveBarButtonItem.rac_command = selfViewModel.insertCellCommand;
  UIBarButtonItem *retrieveBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"retrieve"
                                                                          style:UIBarButtonItemStylePlain
                                                                         target:nil
                                                                         action:nil];
  retrieveBarButtonItem.rac_command = selfViewModel.removeCellCommand;
  UIBarButtonItem *testBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"test" style:UIBarButtonItemStylePlain target:self action:@selector(test)];

  self.navigationController.toolbarHidden = NO;
  [self setToolbarItems:@[
    saveBarButtonItem,
    retrieveBarButtonItem,
    testBarButtonItem,
  ] animated:YES];
}

- (void)test {
  
  [[[[[[RACSignal return:@1] doNext:^(id x) {
    NSLog(@"doNext 1");
  }] doNext:^(id x) {
    NSLog(@"doNext 2");
  }] doAfterNext:^(id x) {
    NSLog(@"doAfterNext 2");
  }] doAfterNext:^(id x) {
    NSLog(@"doAfterNext 1");
  }] subscribeNext:^(id x) {
    NSLog(@"subscribeNext");
  }];
}


@end
