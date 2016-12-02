//
//  LPDCollectionView.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDCollectionView.h"
#import <ReactiveCocoa/ReactiveCocoa.h>


@interface LPDCollectionView ()

@property (nullable, nonatomic, weak, readwrite) __kindof id<LPDCollectionViewModelProtocol> viewModel;

@end

@implementation LPDCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
  self = [super initWithFrame:frame collectionViewLayout:layout];
  if (self) {
    self.backgroundColor = [UIColor colorWithRed:0.9214 green:0.9206 blue:0.9458 alpha:1.0];
  }
  return self;
}

- (void)bindingTo:(__kindof id<LPDCollectionViewModelProtocol>)viewModel {
  NSParameterAssert(viewModel);

  self.viewModel = viewModel;

  @weakify(self);
  [
    //   [[self rac_signalForSelector:@selector(didMoveToSuperview)] setNameWithFormat:@"-didMoveToSuperview"]
    [self.viewModel.scrollViewModel viewDidLoadSignal] subscribeNext:^(id x) {
      @strongify(self);
      super.delegate = self.viewModel.delegate;
      super.dataSource = self.viewModel.dataSource;

      [[self.viewModel.reloadDataSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(id x) {
          @strongify(self);
          [self reloadData];
        }];

      [[self.viewModel.insertSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(NSIndexSet *indexSet) {
          @strongify(self);
          //          [self insertSections:indexSet];
          [self reloadData];
        }];

      [[self.viewModel.deleteSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(NSIndexSet *indexSet) {
          @strongify(self);
          //          [self deleteSections:indexSet];
          [self reloadData];
        }];

      [[self.viewModel.replaceSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(NSIndexSet *indexSet) {
          @strongify(self);
          //          [self reloadSections:indexSet];
          [self reloadData];
        }];

      [[self.viewModel.reloadSectionsSignal takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(NSIndexSet *indexSet) {
          @strongify(self);
          //          [self deleteSections:indexSet];
          //          [self insertSections:indexSet];
          [self reloadData];
        }];

      [[self.viewModel.insertItemsAtIndexPathsSignal
        takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(NSArray<NSIndexPath *> *indexPaths) {
          @strongify(self);
          //          [self insertItemsAtIndexPaths:indexPaths];
          [self reloadData];
        }];

      [[self.viewModel.deleteItemsAtIndexPathsSignal
        takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(NSArray<NSIndexPath *> *indexPaths) {
          @strongify(self);
          //          [self deleteItemsAtIndexPaths:indexPaths];
          [self reloadData];
        }];

      [[self.viewModel.replaceItemsAtIndexPathsSignal
        takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]] subscribeNext:^(RACTuple *tuple) {
        @strongify(self);
        //        [self deleteItemsAtIndexPaths:tuple.first];
        //        [self insertItemsAtIndexPaths:tuple.second];
        [self reloadData];
      }];

      [[self.viewModel.reloadItemsAtIndexPathsSignal
        takeUntil:[self rac_signalForSelector:@selector(removeFromSuperview)]]
        subscribeNext:^(NSArray<NSIndexPath *> *indexPaths) {
          @strongify(self);
          [self reloadItemsAtIndexPaths:indexPaths];
        }];
    }];
}

@end
