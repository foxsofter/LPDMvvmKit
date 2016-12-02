//
//  LPDViewControllerRouter.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDNavigationControllerProtocol.h"
#import "LPDNavigationViewModelProtocol.h"
#import "LPDTabBarControllerProtocol.h"
#import "LPDTabBarViewModelProtocol.h"
#import "LPDViewControllerProtocol.h"
#import "LPDViewControllerRouter.h"
#import "LPDViewModelProtocol.h"

@implementation LPDViewControllerRouter

static NSMutableDictionary *dictionaryOfMappings;

+ (void)setViewController:(NSString *)viewControllerClass forViewModel:(NSString *)viewModelClass {
  if (!dictionaryOfMappings) {
    dictionaryOfMappings = [NSMutableDictionary dictionary];
  }
  if ([NSClassFromString(viewModelClass) conformsToProtocol:@protocol(LPDViewModelProtocol)]) {
    NSParameterAssert([NSClassFromString(viewControllerClass) conformsToProtocol:@protocol(LPDViewControllerProtocol)]);
  } else if ([NSClassFromString(viewModelClass) conformsToProtocol:@protocol(LPDNavigationViewModelProtocol)]) {
    NSParameterAssert(
      [NSClassFromString(viewControllerClass) conformsToProtocol:@protocol(LPDNavigationControllerProtocol)]);
  } else if ([NSClassFromString(viewModelClass) conformsToProtocol:@protocol(LPDTabBarViewModelProtocol)]) {
    NSParameterAssert(
      [NSClassFromString(viewControllerClass) conformsToProtocol:@protocol(LPDTabBarControllerProtocol)]);
  } else {
    NSParameterAssert(NO);
  }

  [dictionaryOfMappings setObject:viewControllerClass forKey:viewModelClass];
}

+ (id)viewControllerForViewModel:(id)viewModel {
  NSString *viewModelName = NSStringFromClass(((NSObject *)viewModel).class);
  NSString *viewControllerName = [dictionaryOfMappings valueForKey:viewModelName];

  if (!viewControllerName) {
    viewControllerName = [viewModelName stringByReplacingOccurrencesOfString:@"Model"
                                                                  withString:@"Controller"
                                                                     options:NSCaseInsensitiveSearch | NSBackwardsSearch
                                                                       range:NSMakeRange(viewModelName.length - 5, 5)];
  }
  NSParameterAssert(viewControllerName);
  NSParameterAssert([NSClassFromString(viewControllerName) instancesRespondToSelector:@selector(initWithViewModel:)]);

  return [[NSClassFromString(viewControllerName) alloc] initWithViewModel:viewModel];
}

@end
