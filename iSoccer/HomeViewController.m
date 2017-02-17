//
//  HomeViewController.m
//  iSoccer
//
//  Created by pfg on 15/10/28.
//  Copyright © 2015年 iSoccer. All rights reserved.
//

#import "HomeViewController.h"
#import "MainViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 40);
    [button setTitle:@"Back" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    button.titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBlack];
    [button addTarget:self action:@selector(backPreViewController) forControlEvents:UIControlEventTouchUpInside];
    
    button.center = CGPointMake(button.frame.size.width/2 + 20, button.frame.size.height/2 + 10);
    
    [self.view addSubview:button];
}
- (void)backPreViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
