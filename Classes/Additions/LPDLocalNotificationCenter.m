//
//  LPDLocalNotificationCenter.m
//  LPDTeam
//
//  Created by jarinosuke on 7/27/13.
//  Copyright (c) 2013 jarinosuke. All rights reserved.
//

#import "LPDLocalNotificationCenter.h"

NSString *const kLPDLocalNotificationHandlingKeyName = @"kLPDLocalNotificationHandlingKeyName";
NSString *const kLPDApplicationDidReceiveLocalNotification = @"kLPDApplicationDidReceiveLocalNotification";

@interface LPDLocalNotificationCenter ()

@property (nonatomic, strong) NSMutableDictionary *localPushDictionary;
@property (nonatomic) BOOL checkRemoteNotificationAvailability;

@end

@implementation LPDLocalNotificationCenter

static LPDLocalNotificationCenter *defaultCenter;

+ (instancetype)defaultCenter {
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    defaultCenter = [[LPDLocalNotificationCenter alloc] init];
    defaultCenter.localPushDictionary = [NSMutableDictionary dictionary];
    [defaultCenter cancelAllLocalNotifications];
    defaultCenter.checkRemoteNotificationAvailability = NO;
    defaultCenter.localNotificationHandler = nil;
  });
  return defaultCenter;
}

- (void)loadScheduledLocalPushNotificationsFromApplication {
  NSArray *scheduleLocalPushNotifications = [[UIApplication sharedApplication] scheduledLocalNotifications];
  for (UILocalNotification *localNotification in scheduleLocalPushNotifications) {
    if (localNotification.userInfo[kLPDLocalNotificationHandlingKeyName]) {
      [self.localPushDictionary setObject:localNotification
                                   forKey:localNotification.userInfo[kLPDLocalNotificationHandlingKeyName]];
    }
  }
}

- (NSArray *)localNotifications {
  return [[NSArray alloc] initWithArray:[self.localPushDictionary allValues]];
}

- (void)didReceiveLocalNotification:(UILocalNotification *)notification {
  NSString *name = notification.userInfo[kLPDLocalNotificationHandlingKeyName];
  if (!name) {
    return;
  }
  [self.localPushDictionary removeObjectForKey:name];

  [[NSNotificationCenter defaultCenter] postNotificationName:kLPDApplicationDidReceiveLocalNotification
                                                      object:nil
                                                    userInfo:notification.userInfo];

  if (self.localNotificationHandler) {
    self.localNotificationHandler(name, notification);
  }
}

- (void)cancelAllLocalNotifications {
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  [self.localPushDictionary removeAllObjects];
}

- (void)cancelLocalNotification:(UILocalNotification *)localNotification {
  if (!localNotification) {
    return;
  }

  [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
  if (localNotification.userInfo[kLPDLocalNotificationHandlingKeyName]) {
    [self.localPushDictionary removeObjectForKey:localNotification.userInfo[kLPDLocalNotificationHandlingKeyName]];
  }
}

- (void)cancelLocalNotificationForName:(NSString *)name {
  if (!self.localPushDictionary[name]) {
    return;
  }

  NSLog(@"cancelLocalNotificationForName:%@", name);
  UILocalNotification *localNotification = self.localPushDictionary[name];
  [[UIApplication sharedApplication] cancelLocalNotification:localNotification];
  [self.localPushDictionary removeObjectForKey:name];
}

- (void)cancelKindOfLocalNotificationForName:(NSString *)contains {
  NSMutableArray *matchKeys = [NSMutableArray array];
  for (NSString *key in self.localPushDictionary.allKeys) {
    if ([key containsString:contains]) {
      [matchKeys addObject:key];
    }
  }
  for (NSString *key in matchKeys) {
    [self cancelLocalNotificationForName:key];
  }
}

#pragma mark - Post on now

- (UILocalNotification *)postNotificationOnNowForName:(NSString *)name alertBody:(NSString *)alertBody {
  return [self postNotificationOnNow:YES
                            fireDate:nil
                             forName:name
                           alertBody:alertBody
                         alertAction:nil
                           soundName:nil
                         launchImage:nil
                            userInfo:nil
                          badgeCount:0
                      repeatInterval:0];
}

- (UILocalNotification *)postNotificationOnNowForName:(NSString *)name
                                            alertBody:(NSString *)alertBody
                                             userInfo:(NSDictionary *)userInfo {
  return [self postNotificationOnNow:YES
                            fireDate:nil
                             forName:name
                           alertBody:alertBody
                         alertAction:nil
                           soundName:nil
                         launchImage:nil
                            userInfo:userInfo
                          badgeCount:0
                      repeatInterval:0];
}

- (UILocalNotification *)postNotificationOnNowForName:(NSString *)name
                                            alertBody:(NSString *)alertBody
                                             userInfo:(NSDictionary *)userInfo
                                           badgeCount:(NSInteger)badgeCount {
  return [self postNotificationOnNow:YES
                            fireDate:nil
                             forName:name
                           alertBody:alertBody
                         alertAction:nil
                           soundName:nil
                         launchImage:nil
                            userInfo:userInfo
                          badgeCount:badgeCount
                      repeatInterval:0];
}

- (UILocalNotification *)postNotificationOnNowForName:(NSString *)name
                                            alertBody:(NSString *)alertBody
                                          alertAction:(NSString *)alertAction
                                            soundName:(NSString *)soundName
                                          launchImage:(NSString *)launchImage
                                             userInfo:(NSDictionary *)userInfo
                                           badgeCount:(NSUInteger)badgeCount
                                       repeatInterval:(NSCalendarUnit)repeatInterval {
  return [self postNotificationOnNow:YES
                            fireDate:nil
                             forName:name
                           alertBody:alertBody
                         alertAction:alertAction
                           soundName:soundName
                         launchImage:launchImage
                            userInfo:userInfo
                          badgeCount:badgeCount
                      repeatInterval:repeatInterval];
}

#pragma mark - Post on specified date

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                    forName:(NSString *)name
                                  alertBody:(NSString *)alertBody {
  return [self postNotificationOnNow:NO
                            fireDate:fireDate
                             forName:name
                           alertBody:alertBody
                         alertAction:nil
                           soundName:nil
                         launchImage:nil
                            userInfo:nil
                          badgeCount:0
                      repeatInterval:0];
}

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                    forName:(NSString *)name
                                  alertBody:(NSString *)alertBody
                                   userInfo:(NSDictionary *)userInfo {
  return [self postNotificationOnNow:NO
                            fireDate:fireDate
                             forName:name
                           alertBody:alertBody
                         alertAction:nil
                           soundName:nil
                         launchImage:nil
                            userInfo:userInfo
                          badgeCount:0
                      repeatInterval:0];
}

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                    forName:(NSString *)name
                                  alertBody:(NSString *)alertBody
                                   userInfo:(NSDictionary *)userInfo
                                 badgeCount:(NSInteger)badgeCount {
  return [self postNotificationOnNow:NO
                            fireDate:fireDate
                             forName:name
                           alertBody:alertBody
                         alertAction:nil
                           soundName:nil
                         launchImage:nil
                            userInfo:userInfo
                          badgeCount:badgeCount
                      repeatInterval:0];
}

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                    forName:(NSString *)name
                                  alertBody:(NSString *)alertBody
                                alertAction:(NSString *)alertAction
                                  soundName:(NSString *)soundName
                                launchImage:(NSString *)launchImage
                                   userInfo:(NSDictionary *)userInfo
                                 badgeCount:(NSUInteger)badgeCount
                             repeatInterval:(NSCalendarUnit)repeatInterval {
  return [self postNotificationOnNow:NO
                            fireDate:fireDate
                             forName:name
                           alertBody:alertBody
                         alertAction:alertAction
                           soundName:soundName
                         launchImage:launchImage
                            userInfo:userInfo
                          badgeCount:badgeCount
                      repeatInterval:repeatInterval];
}

- (UILocalNotification *)postNotificationOnNow:(BOOL)presentNow
                                      fireDate:(NSDate *)fireDate
                                       forName:(NSString *)name
                                     alertBody:(NSString *)alertBody
                                   alertAction:(NSString *)alertAction
                                     soundName:(NSString *)soundName
                                   launchImage:(NSString *)launchImage
                                      userInfo:(NSDictionary *)userInfo
                                    badgeCount:(NSUInteger)badgeCount
                                repeatInterval:(NSCalendarUnit)repeatInterval;
{
  if (self.localPushDictionary[name]) {
    // same key already exists
    return self.localPushDictionary[name];
  }

  NSLog(@"push====%@", name);

  UILocalNotification *localNotification = [[UILocalNotification alloc] init];
  if (!localNotification) {
    return nil;
  }

  // return nil, if user denied app's notification requirement

  NSUInteger notificationType; // UIUserNotificationType(>= iOS8) and UIRemoteNotificatioNType(< iOS8) use same value
  UIApplication *application = [UIApplication sharedApplication];
  if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
    notificationType = [[application currentUserNotificationSettings] types];
  } else {
    notificationType = [application enabledRemoteNotificationTypes];
  }
  if (self.checkRemoteNotificationAvailability && notificationType == UIRemoteNotificationTypeNone) {
    return nil;
  }

  BOOL needsNotify = NO;

  // Alert
  if (self.checkRemoteNotificationAvailability &&
      (notificationType & UIRemoteNotificationTypeAlert) != UIRemoteNotificationTypeAlert) {
    needsNotify = NO;
  } else {
    needsNotify = YES;
  }
  // add key name for handling it.
  NSMutableDictionary *userInfoAddingHandlingKey = [NSMutableDictionary dictionaryWithDictionary:userInfo];
  [userInfoAddingHandlingKey setObject:name forKey:kLPDLocalNotificationHandlingKeyName];
  localNotification.userInfo = userInfoAddingHandlingKey;
  localNotification.alertBody = alertBody;
  localNotification.alertAction = alertAction;
  localNotification.alertLaunchImage = launchImage;
  localNotification.repeatInterval = repeatInterval;

  // Sound
  if (self.checkRemoteNotificationAvailability &&
      (notificationType & UIRemoteNotificationTypeSound) != UIRemoteNotificationTypeSound) {
    needsNotify = NO;
  } else {
    needsNotify = YES;
  }
  if (soundName) {
    [localNotification setSoundName:soundName];
  } else {
    localNotification.soundName = @"";
  }

  // Badge
  if (self.checkRemoteNotificationAvailability &&
      (notificationType & UIRemoteNotificationTypeBadge) != UIRemoteNotificationTypeBadge) {
  } else {
    localNotification.applicationIconBadgeNumber = badgeCount;
  }

  if (needsNotify) {
    if (presentNow && !fireDate) {
      [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
    } else {
      localNotification.fireDate = fireDate;
      localNotification.timeZone = [NSTimeZone defaultTimeZone];
      [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    }
    [self.localPushDictionary setObject:localNotification forKey:name];
    return localNotification;
  } else {
    return nil;
  }
}

@end
