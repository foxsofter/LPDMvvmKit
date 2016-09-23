//
//  LPDExamCollectionViewController.m
//  LPDMvvmKit
//
//  Created by 李博 on 16/2/29.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionView.h"
#import "LPDExamCollectionViewController.h"
#import "LPDExamCollectionViewModel.h"
#import "Masonry.h"
#import "LPDAdditions.h"

@interface LPDExamCollectionViewController ()

@property (nonatomic, strong) LPDCollectionView *collectionView;

@property (nonatomic, strong, readonly) LPDExamCollectionViewModel *selfViewModel;

@end

@implementation LPDExamCollectionViewController

#pragma mark - life cycle

- (instancetype)initWithViewModel:(id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    self.tabBarItem =
      [[UITabBarItem alloc] initWithTitle:nil
                                    image:[[UIImage imageNamed:self.selfViewModel.tabBarItemImage]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                            selectedImage:[[UIImage imageNamed:self.selfViewModel.tabBarItemSelectedImage]
                                            imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
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
  self.collectionView.backgroundColor = [UIColor whiteColor];
  [self.collectionView bindingTo:self.selfViewModel.collectionViewModel];
  [self.view addSubview:self.collectionView];
  self.scrollView = self.collectionView;
  self.needLoading = YES;

  UIBarButtonItem *insertCellBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:nil action:nil];
  insertCellBarButtonItem.rac_command = self.selfViewModel.insertCellCommand;
  UIBarButtonItem *insertCellsBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"批量添加" style:UIBarButtonItemStylePlain target:nil action:nil];
  insertCellsBarButtonItem.rac_command = self.selfViewModel.insertCellsCommand;
  UIBarButtonItem *removeCellBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:nil action:nil];
  removeCellBarButtonItem.rac_command = self.selfViewModel.removeCellCommand;
  UIBarButtonItem *removeCellsBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"批量删除" style:UIBarButtonItemStylePlain target:nil action:nil];
  removeCellsBarButtonItem.rac_command = self.selfViewModel.removeCellsCommand;
  self.navigationController.toolbarHidden = NO;
  [self setToolbarItems:@[
    insertCellBarButtonItem,
    insertCellsBarButtonItem,
    removeCellBarButtonItem,
    removeCellsBarButtonItem,
  ] animated:YES];
}

- (void)viewDidLayoutSubviews {
  [super viewDidLayoutSubviews];

  [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
    make.edges.mas_equalTo(UIEdgeInsetsZero);
  }];
  [self.view layoutIfNeeded];
}

#pragma mark - properties

- (LPDExamCollectionViewModel *)selfViewModel {
  return self.viewModel;
}

@end
