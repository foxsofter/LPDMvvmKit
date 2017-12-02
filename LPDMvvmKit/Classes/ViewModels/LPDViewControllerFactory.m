//
//  LPDViewControllerFactory.m
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
#import "LPDViewControllerFactory.h"
#import "LPDViewModelProtocol.h"

@implementation LPDViewControllerFactory

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

+ (UIViewController *)viewControllerForViewModel:(id)viewModel {
  NSString *viewModelName = NSStringFromClass([viewModel class]);
  NSString *viewControllerName = [dictionaryOfMappings valueForKey:viewModelName];
//qs:这里为什么会viewControllerName==nil?
  if (!viewControllerName) {
    viewControllerName = [viewModelName stringByReplacingOccurrencesOfString:@"Model"
                                                                  withString:@"Controller"
                                                                     options:NSCaseInsensitiveSearch | NSBackwardsSearch
                                                                       range:NSMakeRange(viewModelName.length - 5, 5)];
  }
  Class vccls = NSClassFromString(viewControllerName);
  if ([vccls instancesRespondToSelector:@selector(initWithViewModel:)]) {
    return [[vccls alloc] initWithViewModel:viewModel];
  }
  return nil;
}

@end
