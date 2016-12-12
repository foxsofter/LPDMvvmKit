//
//  LPDCollectionItemViewModel.m
//  Pods
//
//  Created by foxsofter on 16/12/4.
//
//

#import "LPDCollectionItemViewModel.h"
#import "LPDCollectionViewModelProtocol.h"

@implementation LPDCollectionItemViewModel {
  __weak __kindof id<LPDCollectionViewModelProtocol> _viewModel;
  NSString *_reuseIdentifier;
  NSString *_reuseViewClass;
}

#pragma mark - LPDCollectionItemViewModelProtocol

- (instancetype)initWithViewModel:(__kindof id<LPDCollectionViewModelProtocol>)viewModel {
  self = [super init];
  if (self) {
    _viewModel = viewModel;
  }
  return self;
}

- (NSString *)reuseIdentifier {
  return _reuseIdentifier ?: (_reuseIdentifier =
                              [NSString stringWithFormat:@"reusable-%@-%@",
                               [self reuseViewClass],
                               NSStringFromClass(self.class)]);
}

- (NSString *)reuseViewClass {
  return _reuseViewClass ?: (_reuseViewClass =
                             [[NSStringFromClass(self.class)
                               stringByReplacingOccurrencesOfString:@"LPDCollection" withString:@"LPDCollectionView"]
                              stringByReplacingOccurrencesOfString:@"ViewModel" withString:@""]);
}

@end
