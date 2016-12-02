//
//  LPDLocalNotificationCenter.h
//  LPDTeam
//
//  Created by jarinosuke on 7/27/13.
//  Copyright (c) 2013 jarinosuke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

extern NSString *const kLPDLocalNotificationHandlingKeyName;
extern NSString *const kLPDApplicationDidReceiveLocalNotification;

@interface LPDLocalNotificationCenter : NSObject

@property (nonatomic, copy) void (^localNotificationHandler)(NSString *name, UILocalNotification *notification);

+ (instancetype)defaultCenter;

- (NSArray *)localNotifications;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;

- (void)cancelAllLocalNotifications;

- (void)cancelLocalNotification:(UILocalNotification *)localNotification;

- (void)cancelLocalNotificationForName:(NSString *)name;

- (void)cancelKindOfLocalNotificationForName:(NSString *)contains;

- (UILocalNotification *)postNotificationOnNowForName:(NSString *)key alertBody:(NSString *)alertBody;

- (UILocalNotification *)postNotificationOnNowForName:(NSString *)name
                                            alertBody:(NSString *)alertBody
                                             userInfo:(NSDictionary *)userInfo;

- (UILocalNotification *)postNotificationOnNowForName:(NSString *)name
                                            alertBody:(NSString *)alertBody
                                          alertAction:(NSString *)alertAction
                                            soundName:(NSString *)soundName
                                          launchImage:(NSString *)launchImage
                                             userInfo:(NSDictionary *)userInfo
                                           badgeCount:(NSUInteger)badgeCount
                                       repeatInterval:(NSCalendarUnit)repeatInterval;

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate forName:(NSString *)name alertBody:(NSString *)alertBody;

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                    forName:(NSString *)name
                                  alertBody:(NSString *)alertBody
                                   userInfo:(NSDictionary *)userInfo;

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                    forName:(NSString *)name
                                  alertBody:(NSString *)alertBody
                                   userInfo:(NSDictionary *)userInfo
                                 badgeCount:(NSInteger)badgeCount;

- (UILocalNotification *)postNotificationOn:(NSDate *)fireDate
                                    forName:(NSString *)name
                                  alertBody:(NSString *)alertBody
                                alertAction:(NSString *)alertAction
                                  soundName:(NSString *)soundName
                                launchImage:(NSString *)launchImage
                                   userInfo:(NSDictionary *)userInfo
                                 badgeCount:(NSUInteger)badgeCount
                             repeatInterval:(NSCalendarUnit)repeatInterval;

@end
