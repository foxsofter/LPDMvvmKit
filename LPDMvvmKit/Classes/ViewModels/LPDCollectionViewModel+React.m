//
//  LPDCollectionViewModel+React.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/2/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <objc/runtime.h>
#import "LPDCollectionViewModel+React.h"

@implementation LPDCollectionViewModel (React)

- (__kindof id<LPDViewModelProtocol>)viewModel {
  return objc_getAssociatedObject(self, @selector(setViewModel:));
}

- (void)setViewModel:(__kindof id<LPDViewModelProtocol> _Nullable)viewModel {
  objc_setAssociatedObject(self, @selector(setViewModel:), viewModel, OBJC_ASSOCIATION_ASSIGN);
}

@end
