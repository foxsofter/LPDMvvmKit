//
//  LPDViewModelEmptyProtocol.h
//  LPDMvvmKit
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>

@protocol LPDViewModelEmptyProtocol<NSObject>

/**
 *  @brief  If YES, shows the empty view, default is NO.
 */
@property (nonatomic, assign, getter=isEmpty) BOOL empty;

/**
 *  @brief  Set empty=YES, shows the empty view with description.
 */
- (void)setEmptyWithDescription:(NSString *)description;

@end
