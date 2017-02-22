//
//  LPDExamCollectionViewModel.m
//  LPDMvvmKit
//
//  Created by 李博 on 16/2/29.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDExamCollectionViewModel.h"
#import <LPDMvvmKit/LPDMvvmKit.h>
#import "LPDPhotoModel.h"
#import "LPDAppApiClient.h"
#import "LPDCollectionViewPhotoCell.h"
#import "LPDCollectionPhotoCellViewModel.h"

@interface LPDExamCollectionViewModel ()

@property (nonatomic, copy) NSArray *datas;

@end

@implementation LPDExamCollectionViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"collectionview";
    self.tabBarItemImage = @"collection";
    self.tabBarItemTitle = @"collection";

    self.collectionViewModel = [[LPDCollectionViewModel alloc] init];
    self.collectionViewModel.viewModel = self;

    @weakify(self);
    self.loadingSignal = [[[LPDAppApiClient sharedInstance] rac_GET:kLPDApiEndpointPhotos parameters:nil] doNext:^(RACTuple *tuple){
      @strongify(self);
      self.datas = [[NSMutableArray arrayWithArray:tuple.first] subarrayWithRange:NSMakeRange(0, 3)];
      [self reloadCollection];
    }];
    [[self.didLayoutSubviewsSignal take:1] subscribeNext:^(id x) {
      @strongify(self);
      self.loading = YES;
    }];
  }
  return self;
}

-(void)reloadCollection {
  if (self.datas && self.datas.count > 0) {
    NSMutableArray *cellViewModels = [NSMutableArray array];
    for (LPDPhotoModel *model in self.datas) {
      LPDCollectionPhotoCellViewModel *cellViewModel = [[LPDCollectionPhotoCellViewModel alloc]initWithViewModel:self.collectionViewModel];
      cellViewModel.model = model;
      [cellViewModels addObject:cellViewModel];
    }
    [self.collectionViewModel replaceSectionWithCellViewModels:cellViewModels];
  }else{
    [self.collectionViewModel removeAllSections];
  }
}

- (void)insertCell {
  LPDPhotoModel *model = [[LPDPhotoModel alloc]init];
  model.albumId = 111;
  model.identifier = 131;
  model.title = @"officia porro iure quia iusto qui ipsa ut modi";
  model.thumbnailUrl = @"http://placehold.it/150/1941e9";
  model.url = @"http://placehold.it/600/24f355";
  
  LPDCollectionPhotoCellViewModel *cellViewModel =
  [[LPDCollectionPhotoCellViewModel alloc] initWithViewModel:self.collectionViewModel];
  cellViewModel.model = model;
  [self.collectionViewModel insertCellViewModel:cellViewModel atIndex:0];
}

- (void)insertCells {
  NSMutableArray *cellViewModels = [NSMutableArray array];
  for (NSInteger i = 0; i < 3; i++) {
    LPDPhotoModel *model = [[LPDPhotoModel alloc]init];
    model.albumId = 111111;
    model.identifier = 1003131;
    model.title = @"officia porro iure quia iusto qui ipsa ut modi";
    model.thumbnailUrl = @"http://placehold.it/150/1941e9";
    model.url = @"http://placehold.it/600/24f355";
    
    LPDCollectionPhotoCellViewModel *cellViewModel =
    [[LPDCollectionPhotoCellViewModel alloc] initWithViewModel:self.collectionViewModel];
    cellViewModel.model = model;
    [cellViewModels addObject:cellViewModel];
  }
  [self.collectionViewModel insertCellViewModels:cellViewModels atIndex:0];
}

- (void)removeCell {
  [self.collectionViewModel removeCellViewModelAtIndex:0];
}

- (void)removeCells {
  [self.collectionViewModel removeSectionAtIndex:0];
}

@end
