//
//  LPDPostModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/21.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDModel.h"

extern NSString *const kLPDApiEndpointPosts;

@interface LPDPostModel : LPDModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

@end
