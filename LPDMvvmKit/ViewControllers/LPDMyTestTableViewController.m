//
//  LPDMyTestTableViewController.m
//  LPDMvvmKit
//
//  Created by 彭柯柱 on 16/1/27.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDMyTestTableViewController.h"
#import "LPDMyTestTableViewModel.h"

@interface LPDMyTestTableViewController ()

@property (nonatomic, strong) LPDTableView *tableView;

@property (nonatomic, strong) LPDMyTestTableViewModel *selfViewModel;

@end

@implementation LPDMyTestTableViewController

- (instancetype)initWithViewModel:(__kindof id<LPDViewModelProtocol>)viewModel {
  if (self = [super initWithViewModel:viewModel]) {
    self.tabBarItem =
      [[UITabBarItem alloc] initWithTitle:self.selfViewModel.tabBarItemTitle
                                    image:[[UIImage imageNamed:self.selfViewModel.tabBarItemImage]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                            selectedImage:[[UIImage imageNamed:self.selfViewModel.tabBarItemSelectedImage]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView = [[LPDTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  [self.tableView bindTo:self.selfViewModel.tableViewModel];
  [self.view addSubview:self.tableView];
  self.scrollView = self.tableView;
  [_selfViewModel loadingMoreSignal];
  self.needLoading = YES;
  self.needLoadingMore = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - properties

- (LPDMyTestTableViewModel *)selfViewModel {
  return self.viewModel;
}

@end
