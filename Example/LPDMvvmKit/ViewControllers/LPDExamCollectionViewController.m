//
//  LPDExamCollectionViewController.m
//  LPDMvvmKit
//
//  Created by 李博 on 16/2/29.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <LPDMvvmKit/LPDMvvmKit.h>

#import "LPDExamCollectionViewController.h"
#import "LPDExamCollectionViewModel.h"
#import "Masonry.h"

@interface LPDExamCollectionViewController ()

@property (nonatomic, strong) LPDCollectionView *collectionView;

@end

@implementation LPDExamCollectionViewController

#pragma mark - life cycle

- (instancetype)initWithViewModel:(id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    LPDExamCollectionViewModel *selfViewModel = (LPDExamCollectionViewModel *)viewModel;
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

  UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
  collectionViewFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
  collectionViewFlowLayout.itemSize = CGSizeMake((UIScreen.width - 30) / 2, (UIScreen.width - 30) / 2);
  collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
  collectionViewFlowLayout.headerReferenceSize = CGSizeMake(self.view.bounds.size.width, 1);
  collectionViewFlowLayout.footerReferenceSize = CGSizeMake(self.view.bounds.size.width, 1);

  self.collectionView =
    [[LPDCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
  LPDExamCollectionViewModel *selfViewModel = self.viewModel;
  self.collectionView.backgroundColor = [UIColor whiteColor];
  [self.collectionView bindingTo:selfViewModel.collectionViewModel];
  [self.view addSubview:self.collectionView];
  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsZero);
  }];
  
  self.scrollView = self.collectionView;
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
