//
//  LPDHomeViewModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDViewModel.h"

@interface LPDHomeViewModel : LPDViewModel

@property (nonatomic, copy) NSString *tabBarItemTitle;
@property (nonatomic, copy) NSString *tabBarItemImage;
@property (nonatomic, copy) NSString *tabBarItemSelectedImage;

@property (nonatomic, strong, readonly) RACCommand *pushViewModelCommand;
@property (nonatomic, strong, readonly) RACCommand *popViewModelCommand;
@property (nonatomic, strong, readonly) RACCommand *popToRootViewModelCommand;
@property (nonatomic, strong, readonly) RACCommand *presentViewModelCommand;
@property (nonatomic, strong, readonly) RACCommand *dismissViewModelCommand;

@end
