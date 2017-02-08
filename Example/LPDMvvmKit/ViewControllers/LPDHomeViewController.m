//
//  LPDHomeViewController.m
//  LPDMvvmKit
//
//  Created by foxsofter on 15/12/16.
//  Copyright © 2015年 eleme. All rights reserved.
//

#import "LPDHomeViewController.h"
#import "LPDHomeViewModel.h"

@interface LPDHomeViewController ()

@property (nonatomic, strong) UIButton *pushViewControllerButton;
@property (nonatomic, strong) UIButton *popViewControllerButton;
@property (nonatomic, strong) UIButton *popToRootViewControllerButton;
@property (nonatomic, strong) UIButton *presentViewControllerButton;
@property (nonatomic, strong) UIButton *dismissViewControllerButton;

@end

@implementation LPDHomeViewController

#pragma mark - life cycle

- (instancetype)initWithViewModel:(id<LPDViewModelProtocol>)viewModel {
  self = [super initWithViewModel:viewModel];
  if (self) {
    LPDHomeViewModel *selfViewModel = viewModel;
    if (selfViewModel.tabBarItemImage) {
      self.tabBarItem =
        [[UITabBarItem alloc] initWithTitle:selfViewModel.tabBarItemTitle
                                      image:[UIImage imageNamed:selfViewModel.tabBarItemImage] tag:0];
    }
  }
  return self;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  
  UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
  [self.view addSubview:scrollView];
  
  CGPoint center = self.view.center;
  CGFloat y = 10;
  _pushViewControllerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_pushViewControllerButton setTitle:@"pushViewController" forState:UIControlStateNormal];
  [_pushViewControllerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _pushViewControllerButton.backgroundColor = [UIColor lightGrayColor];
  _pushViewControllerButton.frame = CGRectMake(0, y, 250, 35);
  _pushViewControllerButton.centerX = center.x;
  [scrollView addSubview:_pushViewControllerButton];
  [_pushViewControllerButton addTarget:self
                                action:@selector(pushViewController:)
                      forControlEvents:UIControlEventTouchUpInside];

  _popViewControllerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_popViewControllerButton setTitle:@"popViewController" forState:UIControlStateNormal];
  [_popViewControllerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _popViewControllerButton.backgroundColor = [UIColor lightGrayColor];
  _popViewControllerButton.frame = CGRectMake(0, y += 45, 250, 35);
  _popViewControllerButton.centerX = center.x;
  [scrollView addSubview:_popViewControllerButton];
  [_popViewControllerButton addTarget:self
                               action:@selector(popViewController:)
                     forControlEvents:UIControlEventTouchUpInside];

  _popToRootViewControllerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_popToRootViewControllerButton setTitle:@"popToRootViewController" forState:UIControlStateNormal];
  [_popToRootViewControllerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _popToRootViewControllerButton.backgroundColor = [UIColor lightGrayColor];
  _popToRootViewControllerButton.frame = CGRectMake(0, y += 45, 250, 35);
  _popToRootViewControllerButton.centerX = center.x;;
  [scrollView addSubview:_popToRootViewControllerButton];
  [_popToRootViewControllerButton addTarget:self
                                     action:@selector(popToRootViewController:)
                           forControlEvents:UIControlEventTouchUpInside];

  _presentViewControllerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_presentViewControllerButton setTitle:@"presentViewController" forState:UIControlStateNormal];
  [_presentViewControllerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _presentViewControllerButton.backgroundColor = [UIColor lightGrayColor];
  _presentViewControllerButton.frame = CGRectMake(0, y += 45, 250, 35);
  _presentViewControllerButton.centerX = center.x;
  [scrollView addSubview:_presentViewControllerButton];
  [_presentViewControllerButton addTarget:self
                                   action:@selector(presentViewController:)
                         forControlEvents:UIControlEventTouchUpInside];

  _dismissViewControllerButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [_dismissViewControllerButton setTitle:@"dismissViewController" forState:UIControlStateNormal];
  [_dismissViewControllerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  _dismissViewControllerButton.backgroundColor = [UIColor lightGrayColor];
  _dismissViewControllerButton.frame = CGRectMake(0, y += 45, 250, 35);
  _dismissViewControllerButton.centerX = center.x;
  [scrollView addSubview:_dismissViewControllerButton];
  [_dismissViewControllerButton addTarget:self
                                   action:@selector(dismissViewController:)
                         forControlEvents:UIControlEventTouchUpInside];

  UIButton *pushViewModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [pushViewModelButton setTitle:@"pushViewModel" forState:UIControlStateNormal];
  [pushViewModelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  pushViewModelButton.backgroundColor = [UIColor grayColor];
  pushViewModelButton.frame = CGRectMake(0, y += 45, 250, 35);
  pushViewModelButton.centerX = center.x;
  [scrollView addSubview:pushViewModelButton];
  pushViewModelButton.rac_command = [[self viewModel] pushViewModelCommand];

  UIButton *popViewModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [popViewModelButton setTitle:@"popViewModel" forState:UIControlStateNormal];
  [popViewModelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  popViewModelButton.backgroundColor = [UIColor grayColor];
  popViewModelButton.frame = CGRectMake(0, y += 45, 250, 35);
  popViewModelButton.centerX = center.x;
  [scrollView addSubview:popViewModelButton];
  popViewModelButton.rac_command = [[self viewModel] popViewModelCommand];

  UIButton *popToRootViewModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [popToRootViewModelButton setTitle:@"popToRootViewModel" forState:UIControlStateNormal];
  [popToRootViewModelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  popToRootViewModelButton.backgroundColor = [UIColor grayColor];
  popToRootViewModelButton.frame = CGRectMake(0, y += 45, 250, 35);
  popToRootViewModelButton.centerX = center.x;
  [scrollView addSubview:popToRootViewModelButton];
  popToRootViewModelButton.rac_command = [[self viewModel] popToRootViewModelCommand];

  UIButton *presentViewModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [presentViewModelButton setTitle:@"presentViewModel" forState:UIControlStateNormal];
  [presentViewModelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  presentViewModelButton.backgroundColor = [UIColor grayColor];
  presentViewModelButton.frame = CGRectMake(0, y += 45, 250, 35);
  presentViewModelButton.centerX = center.x;
  [scrollView addSubview:presentViewModelButton];
  presentViewModelButton.rac_command = [[self viewModel] presentViewModelCommand];

  UIButton *dismissViewModelButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [dismissViewModelButton setTitle:@"dismissViewModel" forState:UIControlStateNormal];
  [dismissViewModelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  dismissViewModelButton.backgroundColor = [UIColor grayColor];
  dismissViewModelButton.frame = CGRectMake(0, y += 45, 250, 35);
  dismissViewModelButton.centerX = center.x;
  [scrollView addSubview:dismissViewModelButton];
  dismissViewModelButton.rac_command = [[self viewModel] dismissViewModelCommand];
  
  scrollView.contentSize= CGSizeMake(UIScreen.width, y + 45);
  scrollView.userInteractionEnabled = YES;
  scrollView.exclusiveTouch = YES;
  scrollView.canCancelContentTouches = YES;
  scrollView.delaysContentTouches = YES;
}

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
}

#pragma mark - actions

- (void)pushViewController:(UIButton *)sender {
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  LPDHomeViewController *vc = [[LPDHomeViewController alloc] initWithViewModel:vm];
  [self.navigationController pushViewController:vc animated:YES];
}

- (void)popViewController:(UIButton *)sender {
  [self.navigationController popViewControllerAnimated:YES];
}

- (void)popToRootViewController:(UIButton *)sender {
  UINavigationController *navigation = self.navigationController;
  [navigation popToRootViewControllerAnimated:YES];
}


- (void)presentViewController:(UIButton *)sender {
  LPDHomeViewModel *vm = [[LPDHomeViewModel alloc] init];
  LPDNavigationViewModel *nvm = [[LPDNavigationViewModel alloc] initWithRootViewModel:vm];
  [self.navigationController presentNavigationController:[[LPDNavigationController alloc] initWithViewModel:nvm]
                                    animated:YES
                                  completion:^{

                                  }];
}

- (void)dismissViewController:(UIButton *)sender {
  [self.navigationController dismissNavigationControllerAnimated:YES
                                          completion:^{

                                          }];
}

@end
