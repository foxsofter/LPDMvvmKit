//
//  LPDUserDefaultsManager.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString *const kLPDUserDefaultsManagerDomain;

/**
 *  @brief 存储多个实例时用此类管理,只有一个实例使用LPDUserDefaults更简单
 */
@interface LPDUserDefaultsManager <__covariant ObjectType> : NSObject

+ (instancetype)sharedInstance;

- (instancetype)initWithClass:(Class)cls;

@property (nonatomic, strong, readonly) ObjectType latestSavedModel;

- (void)saveModel:(ObjectType)model forKey:(NSString *)modelKey;

- (nullable ObjectType)retrieveModelFromKey:(NSString *)modelKey;

- (void)removeModelForKey:(NSString *)modelKey;

- (void)removeAllModels;

@end

NS_ASSUME_NONNULL_END
