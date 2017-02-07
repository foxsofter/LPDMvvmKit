//
//  LPDExamTableViewController.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <LPDMvvmKit/LPDMvvmKit.h>

#import "LPDExamTableViewController.h"
#import "LPDExamTableViewModel.h"

#import "Masonry.h"
#import "LPDToastView.h"

@interface LPDExamTableViewController ()

@property (nonatomic, strong) LPDTableView *tableView;

@end

@implementation LPDExamTableViewController

#pragma mark - life cycle

- (instancetype)initWithViewModel:(id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    LPDExamTableViewModel *selfViewModel = (LPDExamTableViewModel*)viewModel;
    if (selfViewModel.tabBarItemImage) {
      self.tabBarItem =
      [[UITabBarItem alloc] initWithTitle:selfViewModel.tabBarItemTitle
                                    image:[UIImage imageNamed:selfViewModel.tabBarItemImage] tag:0];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];

  self.tableView = [[LPDTableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
  LPDExamTableViewModel *selfViewModel = (LPDExamTableViewModel*)self.viewModel;
  [self.tableView bindingTo:selfViewModel.tableViewModel];
  [self.view addSubview:self.tableView];
//  self.tableView.contentInsetTop -= 33;
  [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.left.right.equalTo(@0);
    make.top.equalTo(self.mas_topLayoutGuideBottom);
    make.bottom.equalTo(self.mas_bottomLayoutGuideTop);
  }];

  self.scrollView = self.tableView;
  self.needLoadingHeader = YES;

  UIBarButtonItem *insertCellBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:nil action:nil];
  insertCellBarButtonItem.rac_command = selfViewModel.insertCellCommand;
  UIBarButtonItem *insertCellsBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"批量添加" style:UIBarButtonItemStylePlain target:nil action:nil];
  insertCellsBarButtonItem.rac_command = selfViewModel.insertCellsCommand;
  UIBarButtonItem *removeCellBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:nil action:nil];
  removeCellBarButtonItem.rac_command = selfViewModel.removeCellCommand;
  UIBarButtonItem *removeCellsBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"批量删除" style:UIBarButtonItemStylePlain target:nil action:nil];
  removeCellsBarButtonItem.rac_command = selfViewModel.removeCellsCommand;
  self.navigationController.toolbarHidden = NO;
  [self setToolbarItems:@[
    insertCellBarButtonItem,
    insertCellsBarButtonItem,
    removeCellBarButtonItem,
    removeCellsBarButtonItem,
  ] animated:YES];
}


@end
