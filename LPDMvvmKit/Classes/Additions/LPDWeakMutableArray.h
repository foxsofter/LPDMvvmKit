//
//  LPDWeakMutableArray.h
//  Pods
//
//  Created by foxsofter on 17/2/3.
//
//

#import <Foundation/Foundation.h>

@interface NSArray (LPDWeak)

- (instancetype)weakCopy;

@end

@interface LPDWeakMutableArray<ObjectType> : NSMutableArray<ObjectType>

@end
