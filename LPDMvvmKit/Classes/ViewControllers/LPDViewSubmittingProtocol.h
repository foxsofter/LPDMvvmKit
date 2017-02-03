//
//  LPDViewSubmittingProtocol.h
//  Pods
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>

@protocol LPDViewSubmittingProtocol <NSObject>

@optional

+ (void)showSubmitting:(NSString *_Nullable)status;

+ (void)hideSubmitting;


@end
