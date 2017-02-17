//
//  PayNavigationViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/29.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "PayNavigationViewController.h"

@interface PayNavigationViewController ()

@end

@implementation PayNavigationViewController

- (instancetype)initWithCoder:(NSCoder *)coder andTitle:(NSString*)title
{
    self = [super initWithCoder:coder];
    if (self) {
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



@end
