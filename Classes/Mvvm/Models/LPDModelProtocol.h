//
//  LPDModelProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/12.
//  Copyright © 2016年 eleme. All rights reserved.
//

#import "YYModel.h"
#import <Foundation/Foundation.h>

@protocol LPDModelProtocol <YYModel, NSCoding, NSCopying>

/**
 Creates and returns a new instance of the receiver from a json.
 This method is thread-safe.

 @param json  A json object in `NSDictionary`, `NSString` or `NSData`.

 @return A new instance created from the json, or nil if an error occurs.
 */
+ (instancetype)modelWithJSON:(id)json;

/**
 Creates and returns a new instance of the receiver from a key-value dictionary.
 This method is thread-safe.

 @param dictionary  A key-value dictionary mapped to the instance's properties.
 Any invalid key-value pair in dictionary will be ignored.

 @return A new instance created from the dictionary, or nil if an error occurs.

 @discussion The key in `dictionary` will mapped to the reciever's property name,
 and the value will set to the property. If the value's type does not match the
 property, this method will try to convert the value based on these rules:

 `NSString` or `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
 `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
 `NSString` -> NSURL.
 `NSValue` -> struct or union, such as CGRect, CGSize, ...
 `NSString` -> SEL, Class.
 */
+ (instancetype)modelWithDictionary:(NSDictionary *)dictionary;

/**
 Generate a json object from the receiver's properties.

 @return A json object in `NSDictionary` or `NSArray`, or nil if an error occurs.
 See [NSJSONSerialization isValidJSONObject] for more information.

 @discussion Any of the invalid property is ignored.
 If the reciver is `NSArray`, `NSDictionary` or `NSSet`, it just convert
 the inner object to json object.
 */
- (id)modelToJSONObject;

/**
 Generate a json string's data from the receiver's properties.

 @return A json string's data, or nil if an error occurs.

 @discussion Any of the invalid property is ignored.
 If the reciver is `NSArray`, `NSDictionary` or `NSSet`, it will also convert the
 inner object to json string.
 */
- (NSData *)modelToJSONData;

/**
 Generate a json string from the receiver's properties.

 @return A json string, or nil if an error occurs.

 @discussion Any of the invalid property is ignored.
 If the reciver is `NSArray`, `NSDictionary` or `NSSet`, it will also convert the
 inner object to json string.
 */
- (NSString *)modelToJSONString;

/**
 Set the receiver's properties with a json object.

 @discussion Any invalid data in json will be ignored.

 @param json  A json object of `NSDictionary`, `NSString` or `NSData`, mapped to the
 receiver's properties.

 @return Whether succeed.
 */
- (BOOL)modelSetWithJSON:(id)json;

/**
 Set the receiver's properties with a key-value dictionary.

 @param dic  A key-value dictionary mapped to the receiver's properties.
 Any invalid key-value pair in dictionary will be ignored.

 @discussion The key in `dictionary` will mapped to the reciever's property name,
 and the value will set to the property. If the value's type doesn't match the
 property, this method will try to convert the value based on these rules:

 `NSString`, `NSNumber` -> c number, such as BOOL, int, long, float, NSUInteger...
 `NSString` -> NSDate, parsed with format "yyyy-MM-dd'T'HH:mm:ssZ", "yyyy-MM-dd HH:mm:ss" or "yyyy-MM-dd".
 `NSString` -> NSURL.
 `NSValue` -> struct or union, such as CGRect, CGSize, ...
 `NSString` -> SEL, Class.

 @return Whether succeed.
 */
- (BOOL)modelSetWithDictionary:(NSDictionary *)dictionary;

@end