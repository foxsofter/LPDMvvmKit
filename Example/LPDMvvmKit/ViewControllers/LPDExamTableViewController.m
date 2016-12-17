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

+(void)load {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    [self beginLodingBlock:^(UIView *_Nonnull view) {
      UIView *contentView = [view viewWithTag:777777];
      if (contentView) {
        return;
      }
      contentView = [[UIView alloc] initWithFrame:view.bounds];
      contentView.tag = 777777;
      contentView.backgroundColor = [UIColor clearColor];
      [view addSubview:contentView];
      UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
      loadingView.layer.cornerRadius = 10;
      loadingView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
      
      UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 57, 42)];
      imageView.animationImages = @[
                                    [UIImage imageNamed:@"01"],
                                    [UIImage imageNamed:@"02"],
                                    [UIImage imageNamed:@"03"],
                                    [UIImage imageNamed:@"04"],
                                    [UIImage imageNamed:@"05"],
                                    [UIImage imageNamed:@"06"]
                                    ];
      [loadingView addSubview:imageView];
      imageView.center = CGPointMake(loadingView.width / 2, loadingView.height / 2);
      [contentView addSubview:loadingView];
      
      if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8) {
        loadingView.center = [[UIApplication sharedApplication]
                              .keyWindow convertPoint:CGPointMake(UIScreen.width / 2, UIScreen.height / 2)
                              toView:contentView];
      } else {
        loadingView.center = CGPointMake([UIApplication sharedApplication].keyWindow.center.x,
                                         [UIApplication sharedApplication].keyWindow.center.y - 64);
      }
      [imageView startAnimating];
    }];
    [self endLodingBlock:^(UIView *_Nonnull view) {
      UIView *contentView = [view viewWithTag:777777];
      if (contentView) {
        [contentView removeFromSuperview];
      }
    }];
    [self showSuccessBlock:^(NSString *_Nullable status) {
      [LPDToastView show:status];
    }];
    [self showErrorBlock:^(NSString *_Nullable status) {
      [LPDToastView show:status];
    }];

  });
}

- (instancetype)initWithViewModel:(id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    LPDExamTableViewModel *selfViewModel = (LPDExamTableViewModel*)viewModel;
    self.tabBarItem =
      [[UITabBarItem alloc] initWithTitle:nil
                                    image:[[UIImage imageNamed:selfViewModel.tabBarItemImage]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                            selectedImage:[[UIImage imageNamed:selfViewModel.tabBarItemSelectedImage]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
  self.needLoading = YES;

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
