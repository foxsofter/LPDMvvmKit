//
//  LPDExamCollectionViewModel.m
//  LPDMvvmKit
//
//  Created by 李博 on 16/2/29.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDExamCollectionViewModel.h"
#import "LPDMvvm.h"
#import "LPDPhotoModel.h"
#import "LPDAppApiClient.h"
#import "LPDCollectionViewPhotoCell.h"
#import "LPDCollectionPhotoCellViewModel.h"

@interface LPDExamCollectionViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *insertCellCommand;
@property (nonatomic, strong, readwrite) RACCommand *insertCellsCommand;
@property (nonatomic, strong, readwrite) RACCommand *removeCellCommand;
@property (nonatomic, strong, readwrite) RACCommand *removeCellsCommand;

@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation LPDExamCollectionViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"collectionview";
    self.tabBarItemImage = @"YuetTabItemNormalIcon";
    self.tabBarItemSelectedImage = @"YuetTabItemIcon";

    self.collectionViewModel = [[LPDCollectionViewModel alloc] initWithScrollViewModel:self];

    @weakify(self);
    self.loadingSignal = [[[LPDAppApiClient sharedInstance] rac_GET:kLPDApiEndpointPhotos parameters:nil] doNext:^(RACTuple *tuple){
      @strongify(self);
      self.datas = [NSMutableArray arrayWithArray:tuple.first];
      [self.datas removeObjectsInRange:NSMakeRange(200, self.datas.count - 200)];
      [self reloadCollection];
    }];
    [[self.viewDidLayoutSubviewsSignal take:1] subscribeNext:^(id x) {
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

- (RACCommand *)insertCellCommand {
  if (!_insertCellCommand) {
    @weakify(self);
    _insertCellCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
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
        
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
      }];
    }];
  }
  return _insertCellCommand;
}

- (RACCommand *)insertCellsCommand {
  if (!_insertCellsCommand) {
    @weakify(self);
    _insertCellsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
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
        
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{

        }];
      }];
    }];
  }
  return _insertCellsCommand;
}

- (RACCommand *)removeCellCommand {
  if (!_removeCellCommand) {
    @weakify(self);
    _removeCellCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.collectionViewModel removeCellViewModelAtIndex:0];

        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
      }];
    }];
  }
  return _removeCellCommand;
}

- (RACCommand *)removeCellsCommand {
  if (!_removeCellsCommand) {
    @weakify(self);
    _removeCellsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.collectionViewModel removeSectionAtIndex:0];
        
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
      }];
    }];
  }
  return _removeCellsCommand;
}

@end
