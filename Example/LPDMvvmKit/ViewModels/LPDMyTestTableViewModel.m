//
//  LPDMyTestTableViewModel.m
//  LPDMvvmKit
//
//  Created by 彭柯柱 on 16/1/26.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCustomCellModel.h"
#import "LPDCustomTableHeaderViewModel.h"
#import "LPDMyTestTableViewModel.h"

@implementation LPDMyTestTableViewModel

- (instancetype)init {
  if (self = [super init]) {
    self.tabBarItemTitle = @"我的";
    self.tabBarItemImage = @"";
    self.tabBarItemSelectedImage = @"";
    self.tableViewModel = [[LPDTableViewModel alloc] initWithScrollViewModel:self];

    LPDTableSectionWithHeadFootViewViewModel *headerOrFooterSectionViewModel =
      [LPDTableSectionWithHeadFootViewViewModel section];

    LPDCustomTableHeaderViewModel *customHeaderViewModel =
      [[LPDCustomTableHeaderViewModel alloc] initWithViewModel:self.tableViewModel];
    headerOrFooterSectionViewModel.headerViewModel = customHeaderViewModel;
    customHeaderViewModel.myText = @"header";
    headerOrFooterSectionViewModel.headerViewModel.height = 50;

    LPDCustomTableHeaderViewModel *customHeaderViewModel1 =
      [[LPDCustomTableHeaderViewModel alloc] initWithViewModel:self.tableViewModel];

    headerOrFooterSectionViewModel.footerViewModel = customHeaderViewModel1;
    customHeaderViewModel1.myText = @"footer";
    headerOrFooterSectionViewModel.footerViewModel.height = 150;

    NSMutableArray *cellModels = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
      LPDCustomCellModel *model = [[LPDCustomCellModel alloc] initWithViewModel:self.tableViewModel];
      model.myText = @"myText";
      model.rows = [NSString stringWithFormat:@"第%d行", i];
      [cellModels addObject:model];
    }
    [self.tableViewModel addSectionViewModel:headerOrFooterSectionViewModel withCellViewModels:cellModels];
    [self.tableViewModel addSectionViewModel:headerOrFooterSectionViewModel withCellViewModels:cellModels];
  }
  return self;
}

- (RACSignal *)loadingMoreSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSLog(@"begin load more");
    [subscriber sendNext:@"load more"];
    [subscriber sendCompleted];
    return [RACDisposable disposableWithBlock:^{

    }];
  }];
}

- (RACSignal *)loadingSignal {
  return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
    NSLog(@"reload");
    [subscriber sendNext:nil];
    [subscriber sendCompleted];
    return [RACDisposable disposableWithBlock:^{

    }];
  }];
}

@end
