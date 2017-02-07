//
//  LPDHomeViewModel.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDHomeViewModel.h"
#import <LPDMvvmKit/LPDMvvmKit.h>

@interface LPDHomeViewModel ()

@property (nonatomic, strong, readwrite) RACCommand *pushViewModelCommand;
@property (nonatomic, strong, readwrite) RACCommand *popViewModelCommand;
@property (nonatomic, strong, readwrite) RACCommand *popToRootViewModelCommand;
@property (nonatomic, strong, readwrite) RACCommand *presentViewModelCommand;
@property (nonatomic, strong, readwrite) RACCommand *dismissViewModelCommand;

@end

@implementation LPDHomeViewModel

- (instancetype)init {
  self = [super init];
  if (self) {
    self.title = @"navigation";
    self.tabBarItemImage = @"navigation";
    self.tabBarItemTitle = @"navigation";
  }
  return self;
}

- (RACCommand *)pushViewModelCommand {
  if (!_pushViewModelCommand) {
    @weakify(self);
    _pushViewModelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
        [self.navigation pushViewModel:vm animated:YES];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
      }];
    }];
  }
  return _pushViewModelCommand;
}

- (RACCommand *)popViewModelCommand {
  if (!_popViewModelCommand) {
    @weakify(self);
    _popViewModelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.navigation popViewModelAnimated:YES];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
      }];
    }];
  }
  return _popViewModelCommand;
}

- (RACCommand *)popToRootViewModelCommand {
  if (!_popToRootViewModelCommand) {
    @weakify(self);
    _popToRootViewModelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.navigation popToRootViewModelAnimated:YES];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
      }];
    }];
  }
  return _popToRootViewModelCommand;
}

- (RACCommand *)presentViewModelCommand {
  if (!_presentViewModelCommand) {
    @weakify(self);
    _presentViewModelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
        [self.navigation presentNavigationViewModel:[[LPDNavigationViewModel alloc] initWithRootViewModel:vm]
                                 animated:YES
                               completion:nil];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
      }];
    }];
  }
  return _presentViewModelCommand;
}

- (RACCommand *)dismissViewModelCommand {
  if (!_dismissViewModelCommand) {
    @weakify(self);
    _dismissViewModelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
      return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        [self.navigation dismissNavigationViewModelAnimated:YES
                                       completion:^{

                                       }];
        [subscriber sendNext:nil];
        [subscriber sendCompleted];
        return nil;
      }];
    }];
  }
  return _dismissViewModelCommand;
}

@end
