//
//  ChooseViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/20.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "ChooseViewController.h"
#import "Global.h"

@interface ChooseViewController ()
{
    
    IBOutlet UIButton *createMatchButton;
}

@end

@implementation ChooseViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if([Global getInstance].isMeTeam == NO)
    {
        createMatchButton.enabled = NO;
        
        [createMatchButton setTitle:@"不是本队队长无法创建比赛" forState:UIControlStateNormal];
    }
    
}


- (void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
