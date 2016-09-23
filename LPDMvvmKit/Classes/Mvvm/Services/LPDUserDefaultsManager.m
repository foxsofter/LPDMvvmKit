//
//  LPDUserDefaultsManager.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/22.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "LPDUserDefaultsManager.h"

NS_ASSUME_NONNULL_BEGIN

NSString *const kLPDUserDefaultsManagerDomain = @"com.ele.me.lpd.user_defaults";

NSString *const kLPDUserDefaultsLatestSavedModelKey = @"com.ele.me.lpd.latest_saved_model";

@interface LPDUserDefaultsManager ()

@property (nonatomic, strong) NSUserDefaults *userDefaults;

@property (nullable, nonatomic, strong) NSMutableDictionary<NSString *, id> *dictionaryOfModel;

@property (nonatomic, strong, readwrite) NSObject<NSCoding> *latestSavedModel;

@property (nonatomic, copy) NSString *userDefaultsManagerDomain;

@property (nonatomic, copy) NSString *lastSavedUserDefaultsKey;

@end

@implementation LPDUserDefaultsManager

#pragma mark - life cycle

+ (instancetype)sharedInstance {
  static LPDUserDefaultsManager *instance;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    instance = [[LPDUserDefaultsManager alloc] init];
  });
  return instance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    _userDefaults = [[NSUserDefaults alloc] init];
    _userDefaultsManagerDomain = kLPDUserDefaultsManagerDomain;
    _lastSavedUserDefaultsKey = kLPDUserDefaultsLatestSavedModelKey;
    NSDictionary *dictionaryOfModel = [_userDefaults persistentDomainForName:_userDefaultsManagerDomain];
    _dictionaryOfModel = dictionaryOfModel ? [dictionaryOfModel mutableCopy] : [NSMutableDictionary dictionary];
  }
  return self;
}

- (instancetype)initWithClass:(Class)cls {
  self = [super init];
  if (self) {
    _userDefaults = [[NSUserDefaults alloc] init];
    _userDefaultsManagerDomain =
      [NSString stringWithFormat:@"%@.%@", kLPDUserDefaultsManagerDomain, NSStringFromClass(cls)];
    _lastSavedUserDefaultsKey =
      [NSString stringWithFormat:@"%@.%@", kLPDUserDefaultsManagerDomain, NSStringFromClass(cls)];
    NSDictionary *dictionaryOfModel = [_userDefaults persistentDomainForName:_userDefaultsManagerDomain];
    _dictionaryOfModel = dictionaryOfModel ? [dictionaryOfModel mutableCopy] : [NSMutableDictionary dictionary];
  }
  return self;
}

#pragma mark - public methods

- (NSObject<NSCoding> *)latestSavedModel {
  if (!_latestSavedModel) {
    NSData *latestData = [_userDefaults objectForKey:_lastSavedUserDefaultsKey];
    if (latestData) {
      _latestSavedModel = [NSKeyedUnarchiver unarchiveObjectWithData:latestData];
    } else {
      _latestSavedModel = nil;
    }
  }
  return _latestSavedModel;
}

- (void)saveModel:(NSObject<NSCoding> *)model forKey:(NSString *)modelKey {
  NSParameterAssert(model && modelKey && modelKey.length > 0);

  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
  [_dictionaryOfModel setObject:data forKey:modelKey];

  [_userDefaults setPersistentDomain:_dictionaryOfModel forName:_userDefaultsManagerDomain];
  _latestSavedModel = model;

  NSData *latestData = [NSKeyedArchiver archivedDataWithRootObject:_latestSavedModel];
  [_userDefaults setObject:latestData forKey:_lastSavedUserDefaultsKey];

  [_userDefaults synchronize];
}

- (nullable NSObject<NSCoding> *)retrieveModelFromKey:(NSString *)modelKey {
  NSParameterAssert(modelKey && modelKey.length > 0);

  NSData *data = [_dictionaryOfModel objectForKey:modelKey];
  if (data) {
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
  }
  return nil;
}

- (void)removeModelForKey:(NSString *)modelKey {
  NSParameterAssert(modelKey && modelKey.length > 0);

  [_dictionaryOfModel removeObjectForKey:modelKey];

  [_userDefaults setPersistentDomain:_dictionaryOfModel forName:_userDefaultsManagerDomain];
  [_userDefaults synchronize];
}

- (void)removeAllModels {
  [_dictionaryOfModel removeAllObjects];

  [_userDefaults removePersistentDomainForName:_userDefaultsManagerDomain];
  [_userDefaults synchronize];
}

@end

NS_ASSUME_NONNULL_END
