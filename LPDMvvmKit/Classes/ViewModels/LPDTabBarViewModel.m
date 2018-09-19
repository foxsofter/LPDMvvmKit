//
//  LPDTabBarViewModel.m
//  LPDMvvm
//
//  Created by foxsofter on 15/10/13.
//  Copyright © 2015年 foxsofter. All rights reserved.
//

#import "LPDTabBarViewModel.h"

@interface LPDTabBarViewModel ()

@property (nullable, nonatomic, strong, readwrite) NSMutableArray<__kindof id<LPDNavigationViewModelProtocol> > *viewModels;

@end

@implementation LPDTabBarViewModel

@synthesize selectedIndex = _selectedIndex;

#pragma mark - life cycle

- (instancetype)initWithViewModels:(NSArray<__kindof id<LPDNavigationViewModelProtocol> > *)viewModels
{
    self = [super init];
    if (self) {
        self.viewModels = [NSMutableArray arrayWithArray:viewModels];
        for (id<LPDNavigationViewModelProtocol> viewModel in viewModels) {
            viewModel.tabBar = self;
        }
        _selectedIndex = 0;
    }
    return self;
}

#pragma mark - properties

- (__kindof id<LPDNavigationViewModelProtocol>)selectedViewModel
{
    return [_viewModels objectAtIndex:_selectedIndex];
}

@end
