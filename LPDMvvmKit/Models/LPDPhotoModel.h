//
//  LPDPhotoModel.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/9/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDModel.h"

extern NSString *const kLPDApiEndpointPhotos;

@interface LPDPhotoModel : LPDModel

@property (nonatomic, assign) NSInteger albumId;
@property (nonatomic, assign) NSInteger identifier;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *thumbnailUrl;

@end
