//
//  main.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/23.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPDAppDelegate.h"
#import <FBRetainCycleDetector/FBAssociationManager.h>
#import <FBMemoryProfiler/FBMemoryProfiler.h>
#import <FBAllocationTracker/FBAllocationTrackerManager.h>

int main(int argc, char * argv[]) {
  @autoreleasepool {
    
    [FBAssociationManager hook];
    [[FBAllocationTrackerManager sharedManager] startTrackingAllocations];
    [[FBAllocationTrackerManager sharedManager] enableGenerations];

    return UIApplicationMain(argc, argv, nil, NSStringFromClass([LPDAppDelegate class]));
  }
}
