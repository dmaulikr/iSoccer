//
//  FindTeamViewController.m
//  iSoccer
//
//  Created by pfg on 16/1/28.
//  Copyright (c) 2016年 iSoccer. All rights reserved.
//

#import "FindTeamViewController.h"
#import "Global.h"
#import "NetConfig.h"
#import "NetRequest.h"
@interface FindTeamViewController ()
{
    
    IBOutlet UITextField *teamCodeText;
}

@end

@implementation FindTeamViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        if([Global getInstance].gameDatas.count > 0)
        {
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backMainView:)];
        }
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//加入球队;
- (IBAction)addTeamHandler:(id)sender {
    if(teamCodeText.text.length == 0 || teamCodeText.text.length != 6)
    {
        [Global alertWithTitle:@"提示" msg:@"请输入正确邀请码"];
        return;
    }
    
    NSDictionary * post = @{@"teamCode":teamCodeText.text};
    NSMutableDictionary * postData = [post mutableCopy];
    
    [NetRequest POST:JOIN_TEAM parameters:postData atView:self.view andHUDMessage:@"确认中.." success:^(id resposeObject) {
        //加入成功;
        
        NSString *code = resposeObject[@"code"];
        
        if(code.integerValue == 2)
        {
            [self dismissViewControllerAnimated:YES completion:^{
                [[Global getInstance].mainVC showLoginView:YES];
            }];
        }else{
            
            [Global alertWithTitle:@"恭喜!" msg:@"加入成功!"];
            
            [Global getInstance].isCreateTeamSuccssed = YES;
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

-(void)backMainView:(UIBarButtonItem*)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
