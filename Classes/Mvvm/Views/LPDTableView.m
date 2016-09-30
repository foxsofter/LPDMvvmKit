//
//  LPDTableView.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/5.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDTableView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "UIScrollView+LPDAccessor.h"

@interface LPDTableView ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDTableViewModelProtocol> viewModel;

@end

@implementation LPDTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
  self = [super initWithFrame:frame style:style];
  if (self) {
    self.estimatedRowHeight = 88;
    self.backgroundColor = [UIColor colorWithRed:0.9214 green:0.9206 blue:0.9458 alpha:1.0];
  }
  return self;
}

- (void)bindingTo:(__kindof id<LPDTableViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;

  @weakify(self);
  [[self.viewModel.scrollViewModel viewDidLoadSignal] subscribeNext:^(id x) {
    @strongify(self);

    super.delegate = self.viewModel.delegate;
    super.dataSource = self.viewModel.dataSource;

    [[self.viewModel.reloadDataSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
      subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        [self reloadData];
      }];

    [[self.viewModel.insertSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
      subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if ((UITableViewRowAnimation)[tuple.second integerValue] == UITableViewRowAnimationNone) {
          [self reloadData];
//          [self insertSections:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second integerValue]];

        } else {
          [self insertSections:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second integerValue]];
        }
      }];

    [[self.viewModel.deleteSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
      subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if ((UITableViewRowAnimation)[tuple.second integerValue] == UITableViewRowAnimationNone) {
          [self reloadData];
        } else {
          [self deleteSections:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second integerValue]];
        }
      }];

    [[self.viewModel.replaceSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
      subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        //        [self beginUpdates];
        //        [self deleteSections:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second
        //        integerValue]];
        //        [self insertSections:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second
        //        integerValue]];
        //        [self endUpdates];

        [self reloadData];

        //        [self reloadSections:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second
        //        integerValue]];
      }];

    [[self.viewModel.reloadSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
      subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        if ((UITableViewRowAnimation)[tuple.second integerValue] == UITableViewRowAnimationNone) {
          [self reloadData];
        } else {
          [self reloadSections:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second integerValue]];
        }
      }];

    [[[self.viewModel.insertRowsAtIndexPathsSignal deliverOnMainThread]
      takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      if ((UITableViewRowAnimation)[tuple.second integerValue] == UITableViewRowAnimationNone) {
        [self reloadData];
      } else {
        [self insertRowsAtIndexPaths:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second integerValue]];
      }
    }];

    [[[self.viewModel.deleteRowsAtIndexPathsSignal deliverOnMainThread]
      takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      NSMutableArray<NSIndexPath *> *indexPaths = [NSMutableArray arrayWithArray:tuple.first];
      for (NSInteger i = indexPaths.count - 1; i >= 0; i--) {
        NSIndexPath *indexPath = [indexPaths objectAtIndex:i];
        UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
        if (!cell) {
          [indexPaths removeObjectAtIndex:i];
        }
      }
      if (indexPaths.count > 0) {
        if ([[UIDevice currentDevice].systemVersion floatValue] < 8.0) {
          [self reloadData];
        } else {
          if ((UITableViewRowAnimation)[tuple.second integerValue] == UITableViewRowAnimationNone) {
            [self reloadData];
          } else {
            [self deleteRowsAtIndexPaths:tuple.first
                        withRowAnimation:(UITableViewRowAnimation)[tuple.second integerValue]];
          }
        }
      }
    }];

    [[self.viewModel.reloadRowsAtIndexPathsSignal
      takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      if ((UITableViewRowAnimation)[tuple.second integerValue] == UITableViewRowAnimationNone) {
        [self reloadData];
      } else {
        [self reloadRowsAtIndexPaths:tuple.first withRowAnimation:(UITableViewRowAnimation)[tuple.second integerValue]];
      }
    }];

    [[self.viewModel.replaceRowsAtIndexPathsSignal
      takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] subscribeNext:^(RACTuple *tuple) {
      @strongify(self);
      [self reloadData];
    }];

  }];
}

@end
