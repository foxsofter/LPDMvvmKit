//
//  LPDUserDefaultsManagerSpec.m
//  LPDMvvmKit
//
//  Created by foxsofter on 16/1/22.
//  Copyright 2016年 eleme. All rights reserved.
//

#import "LPDModel.h"
#import "LPDUserDefaultsManager.h"
#import <Kiwi/Kiwi.h>

// describe(@"Team", ^{
//  context(@"when newly created", ^{
//    it(@"has a name", ^{
//      id team = [Team team];
//      [[team.name should] equal:@"Black Hawks"];
//    });
//
//    it(@"has 11 players", ^{
//      id team = [Team team];
//      [[[team should] have:11] players];
//    });
//  });
//});

@interface TestModel : LPDModel

@property (nonatomic, strong) NSNumber *n1;
@property (nonatomic, copy) NSString *s1;
@property (nonatomic, assign) NSInteger i1;

@end

@implementation TestModel

@end

SPEC_BEGIN(LPDUserDefaultsManagerSpec)

describe(@"LPDUserDefaultsManager", ^{
  context(@"when newly created", ^{
    it(@"create newly test", ^{
      TestModel *tm = [[TestModel alloc] init];
      tm.n1 = @3;
      tm.s1 = @"xx";
      [[LPDUserDefaultsManager sharedInstance] saveModel:tm forKey:@"test"];
    });
    it(@"has n1,s1 equal", ^{
      TestModel *tm = (TestModel *)[[LPDUserDefaultsManager sharedInstance] retrieveModelFromKey:@"test"];
      [[tm.n1 should] equal:@3];
      [[tm.s1 should] equal:@"xx"];
    });
  });
});

SPEC_END
