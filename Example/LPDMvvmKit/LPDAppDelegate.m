//
//  LPDAppDelegate.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/23.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDAppDelegate.h"
#import "LPDExamCollectionViewController.h"
#import "LPDExamCollectionViewModel.h"
#import "LPDExamTableViewController.h"
#import "LPDExamTableViewModel.h"
#import "LPDHomeViewController.h"
#import "LPDHomeViewModel.h"
#import "LPDReactViewController.h"
#import "LPDReactViewModel.h"
#import "LPDRootTabBarController.h"
#import "LPDRootTabBarViewModel.h"
#import <LPDMvvmKit/LPDMvvmKit.h>

@interface LPDAppDelegate ()

@end

@implementation LPDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  LPDHomeViewModel *homeVM = [[LPDHomeViewModel alloc] init];
  LPDExamTableViewModel *tableVM = [[LPDExamTableViewModel alloc] init];
  LPDExamCollectionViewModel *collectionVM = [[LPDExamCollectionViewModel alloc] init];
  LPDReactViewModel *modelVM = [[LPDReactViewModel alloc] init];

  LPDRootTabBarViewModel *rootTabBarVM =
  [[LPDRootTabBarViewModel alloc] initWithViewModels:@[ [[LPDNavigationViewModel alloc] initWithRootViewModel:homeVM], [[LPDNavigationViewModel alloc] initWithRootViewModel:tableVM], [[LPDNavigationViewModel alloc] initWithRootViewModel:collectionVM], [[LPDNavigationViewModel alloc] initWithRootViewModel:modelVM]]];
  
  LPDRootTabBarController *rootTabBarVC = [[LPDRootTabBarController alloc] initWithViewModel:rootTabBarVM];
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  self.window.backgroundColor = [UIColor whiteColor];
  self.window.rootViewController = rootTabBarVC;
  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
  NSLog(@"didChangeAuthorizationStatus: %d", status);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
  NSLog(@"didUpdateLocations:");
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

@end
