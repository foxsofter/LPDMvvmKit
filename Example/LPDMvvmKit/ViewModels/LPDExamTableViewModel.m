//
//  LPDExamTableViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <LPDMvvmKit/LPDMvvmKit.h>
#import "LPDExamTableViewModel.h"
#import "LPDAppApiClient.h"
#import "LPDPostModel.h"
#import "LPDTablePostCellViewModel.h"

@interface LPDExamTableViewModel ()

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation LPDExamTableViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"tableview";
    self.tabBarItemImage = @"table";
    self.tabBarItemTitle = @"table";

    self.tableViewModel = [[LPDTableViewModel alloc] init];
    self.tableViewModel.viewModel = self;
    @weakify(self);
    self.loadingSignal = [[[LPDAppApiClient sharedInstance] rac_GET:kLPDApiEndpointPosts parameters:nil] doNext:^(RACTuple *tuple){
      @strongify(self);
//      self.datas = [NSMutableArray arrayWithArray:tuple.first];
//      [self reloadTable];
      [self setEmptyImage:[UIImage imageNamed:@"image_default_order"] title:@"暂无订单" subTitle:@"孤单，是因为兜里没有单"];
    }];
    [[self.didLayoutSubviewsSignal take:1] subscribeNext:^(id x) {
      @strongify(self);
      self.loading = YES;
    }];
  }
  return self;
}


-(void)reloadTable {
  if (self.datas && self.datas.count > 0) {
    NSMutableArray *cellViewModels = [NSMutableArray array];
    for (LPDPostModel *model in self.datas) {
      LPDTablePostCellViewModel *cellViewModel = [[LPDTablePostCellViewModel alloc]initWithViewModel:self.tableViewModel];
      cellViewModel.model = model;
      [cellViewModels addObject:cellViewModel];
    }
    [self.tableViewModel replaceSectionWithCellViewModels:cellViewModels withRowAnimation:UITableViewRowAnimationTop];
  }else{
    [self.tableViewModel removeAllSections];
  }
}

- (void)insertCell {
  LPDPostModel *model = [[LPDPostModel alloc]init];
  model.userId = 111111;
  model.identifier = 1003131;
  model.title = @"First Chapter";
  model.body = @"GitBook allows you to organize your book into chapters, each chapter is stored in a separate file like this one.";
  LPDTablePostCellViewModel *cellViewModel = [[LPDTablePostCellViewModel alloc]initWithViewModel:self.tableViewModel];
  cellViewModel.model = model;
  [self.tableViewModel insertCellViewModel:cellViewModel atIndex:0 withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)insertCells {
  NSMutableArray *cellViewModels = [NSMutableArray array];
  LPDTableDefaultCellViewModel *cellViewModel1 =
  [[LPDTableDefaultCellViewModel alloc] initWithViewModel:self.tableViewModel];
  cellViewModel1.text = @"芬兰无法";
  cellViewModel1.detail = @"蜂王浆发了";
  cellViewModel1.image = [UIImage imageNamed:@"01"];
  [cellViewModels addObject:cellViewModel1];
  LPDTableValue1CellViewModel *cellViewModel2 =
  [[LPDTableValue1CellViewModel alloc] initWithViewModel:self.tableViewModel];
  cellViewModel2.text = @"芬兰无法";
  cellViewModel2.detail = @"蜂王浆发了";
  cellViewModel2.image = [UIImage imageNamed:@"02"];
  [cellViewModels addObject:cellViewModel2];
  LPDTableValue2CellViewModel *cellViewModel3 =
  [[LPDTableValue2CellViewModel alloc] initWithViewModel:self.tableViewModel];
  cellViewModel3.text = @"芬兰无法";
  cellViewModel3.detail = @"蜂王浆发了";
  [cellViewModels addObject:cellViewModel3];
  LPDTableSubtitleCellViewModel *cellViewModel4 =
  [[LPDTableSubtitleCellViewModel alloc] initWithViewModel:self.tableViewModel];
  cellViewModel4.text = @"芬兰无法";
  cellViewModel4.detail = @"蜂王浆发了";
  cellViewModel4.image = [UIImage imageNamed:@"03"];
  [cellViewModels addObject:cellViewModel4];
  
  [self.tableViewModel insertCellViewModels:cellViewModels atIndex:0 withRowAnimation:UITableViewRowAnimationLeft];
}

- (void)removeCell {
  [self.tableViewModel removeCellViewModelAtIndex:0 withRowAnimation:UITableViewRowAnimationRight];
}

- (void)removeCells {
  [self.tableViewModel removeSectionAtIndex:0 withRowAnimation:UITableViewRowAnimationRight];
}

@end
