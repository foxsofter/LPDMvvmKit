//
//  LPDReactViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDReactViewModel.h"
#import "LPDUserDefaultsManager.h"

@interface LPDReactViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *insertCellCommand;
@property (nonatomic, strong, readwrite) RACCommand *removeCellCommand;

@end

@implementation LPDReactViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"rac";
    self.tabBarItemSelectedImage = @"MineTabItemIcon";
    self.tabBarItemImage = @"MineTabItemNormalIcon";
  }
  return self;
}

- (RACCommand *)insertCellCommand {
  if (!_insertCellCommand) {
    _insertCellCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        LPDTestModel *testModel = [[LPDTestModel alloc] init];
//        testModel.n1 = @2;
//        testModel.s1 = @"ffesfesfes";
//        [[LPDUserDefaultsManager sharedInstance] saveModel:testModel forKey:@"sssssss"];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
      }];
    }];
  }
  return _insertCellCommand;
}

- (RACCommand *)removeCellCommand {
  if (!_removeCellCommand) {
//    @weakify(self);
    _removeCellCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self);

//        LPDTestModel *testModel =
//          (LPDTestModel *)[[LPDUserDefaultsManager sharedInstance] retrieveModelFromKey:@"sssssss"];
//        NSParameterAssert([testModel.n1 isEqualToNumber:@2]);
//        NSParameterAssert([testModel.s1 isEqualToString:@"ffesfesfes"]);

        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
        }];
      }];
    }];
  }
  return _removeCellCommand;
}

@end
